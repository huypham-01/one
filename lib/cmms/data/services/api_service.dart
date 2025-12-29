import 'dart:async' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mobile/cmms/data/mock_data.dart';
import 'package:mobile/fmcs/data/mock_data2.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/helper/onboarding_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  // Constants cho SharedPreferences keys
  static const String _tokenKey = "token";
  static const String _userIdKey = "userId";
  static const String _roleKey = "role";

  // Timeout cho HTTP requests
  static const Duration _timeout = Duration(seconds: 30);
  static Future<bool> isFirstLogin(String username) async {
    final url = Uri.parse(
      "$baseUrl/iam/cip3/index.php?c=AuthController&m=getVerify&username=$username",
    );

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        final verify = data["verify"]?.toString(); // Mặc định "1" nếu null
        // "0" nghĩa là lần đầu => true; "1" nghĩa là đã đăng nhập => false
        return verify == "0"; //0000 ok
      }
    } catch (e) {
      print("Lỗi khi kiểm tra đăng nhập lần đầu: $e");
    }
    // Mặc định coi như không phải lần đầu (để tránh lỗi)
    return false;
  }

  static Future<List<String>> getPermissions(String username) async {
    final url =
        "$baseUrl/iam/cip3/?c=PermissionController&m=getPermissionByUsername";

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"username": username}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is List) {
          return body.map<String>((p) => p.toString()).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static const mockTestAccounts = {"demo": "demo123", "test": "123456"};

  /// Đăng nhập
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
    String otp,
  ) async {
    final isMockAccount = mockTestAccounts[username.trim()] == password;
    if (isMockAccount) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isMockAccount", true);
      print("🟢 Đăng nhập bằng tài khoản mock");
      return MockAuthService.login(username, password, otp);
    }
    // Validate input
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return {
        "success": false,
        "message": "Username and password cannot be blank",
      };
    }
    // Nếu là tài khoản thật
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isMockAccount", false);
    // final isFirstTime = await isFirstLogin(username.trim());

    // final url = _urlCust(keyw);
    final url = "$baseUrl/cmms/cip3/index.php?c=AuthController&m=login";

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "username": username.trim(),
              "password": password,
              "otp": otp.trim(),
            }),
          )
          .timeout(_timeout);

      if (response.body.isEmpty) {
        return {"success": false, "message": "Server trả về dữ liệu rỗng"};
      }

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body["accessToken"] != null) {
        final token = body["accessToken"] as String;

        // Validate token format
        if (!_isValidJwtToken(token)) {
          return {"success": false, "message": "Token không hợp lệ"};
        }

        await _saveTokenData(token);

        // Decode token để lấy thông tin user
        Map<String, dynamic> payload = Jwt.parseJwt(token);

        final role = payload["role"]?.toString() ?? "";
        final userId = payload["sub"];

        // 🔥 GỬI FCM TOKEN SAU KHI LOGIN THÀNH CÔNG
        await ApiService.sendFcmTokenToBackend(token);

        final usernameDecoded = payload["username"] ?? username;
        final permissions = await getPermissions(usernameDecoded);
        // 🔒 Lưu quyền vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList("permissions", permissions);

        // openOtpApp(userId);
        // Kiểm tra nếu là lần đầu đăng nhập thì mới mở openOtpApp

        // if (isFirstTime) {
        //   openOtpApp(userId);
        //   await OnboardingHelper.setFirstTimeFalse();
        // }

        return {
          "success": true,
          "data": body,
          "userId": userId,
          "role": role,
          "permissions": permissions,
        };
      } else {
        return {
          "success": false,
          "message": body["error"] ?? body["message"] ?? "Đăng nhập thất bại",
        };
      }
    } on http.TimeoutException {
      return {"success": false, "message": "Kết nối timeout, vui lòng thử lại"};
    } on FormatException {
      return {"success": false, "message": "Dữ liệu trả về không hợp lệ"};
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi kết nối server: ${e.toString()}",
      };
    }
  }

  static Future<void> openOtpApp(String uuid) async {
    final Uri uri = Uri.parse('myotpapp://verify?uuid=$uuid');
    print('🟢 Mở link: $uri');

    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // 👈 Bắt buộc để mở riêng app
      );

      if (!launched) {
        print('⚠️ Không thể mở app OTP (app chưa cài hoặc scheme sai)');
      }
    } catch (e) {
      print('🚫 Lỗi khi mở app OTP: $e');
    }
  }

  static Future<Map<String, dynamic>> setPassword(String password) async {
    try {
      final isMock = await OnboardingHelper.isMockUser();
      if (isMock) {
        return {
          'success': true,
          'statusCode': 200,
          'data': {
            "status": "success",
            "message": "Password updated successfully (mock)",
            "updated_at": "2025-12-01 10:00:00",
          },
        };
      }
      final token = await ApiService.getToken();
      final decoded = await ApiService.decodeToken();
      print('🔓 Decode token: $decoded');
      if (decoded == null) {
        return {
          'success': false,
          'statusCode': null,
          'message': 'Token decode failed (decoded = null)',
        };
      }

      final headers = <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        "uuid": decoded['sub'],
        "username": decoded['username'],
        "roles": (decoded['role'] as List).map((r) => r['uuid']).toList(),
        "password": password,
        "reason": "User changed password",
      });

      final response = await http
          .post(
            Uri.parse("$baseUrl/iam/cip3/?c=UserController&m=updateUser"),
            headers: headers,
            body: body,
          )
          .timeout(_timeout);

      // Bạn có thể thay đổi logic này tuỳ cấu trúc response của backend
      if (response.statusCode >= 200 && response.statusCode < 300) {
        dynamic parsed;
        try {
          parsed = jsonDecode(response.body);
          openOtpApp(decoded['sub']);
          await OnboardingHelper.setFirstTimeFalse();
        } catch (_) {
          parsed = response.body;
        }
        return {
          'success': true,
          'statusCode': response.statusCode,
          'data': parsed,
        };
      } else {
        String message = response.body;
        try {
          final parsed = jsonDecode(response.body);
          if (parsed is Map && parsed['message'] != null)
            message = parsed['message'];
        } catch (_) {}
        return {
          'success': false,
          'statusCode': response.statusCode,
          'message': message,
        };
      }
    } on SocketException {
      return {
        'success': false,
        'statusCode': null,
        'message': 'Không có kết nối mạng.',
      };
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'statusCode': null,
        'message': 'Client error: ${e.message}',
      };
    } on TimeoutException {
      return {
        'success': false,
        'statusCode': null,
        'message': 'Yêu cầu vượt quá thời gian chờ.',
      };
    } catch (e) {
      return {'success': false, 'statusCode': null, 'message': 'Lỗi: $e'};
    }
  }

  static Future<void> sendFcmTokenToBackend(String accessToken) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        print("⚠️ Không lấy được FCM token");
        return;
      }

      final url =
          "$baseUrl/cmms/cip3/index.php?c=UserController&m=updateFcmToken";

      await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // ⭐ RẤT QUAN TRỌNG
        },
        body: jsonEncode({"fcm_token": fcmToken}),
      );

      print("✅ Đã gửi FCM token lên backend");
    } catch (e) {
      print("❌ Lỗi gửi FCM token: $e");
    }
  }

  static Future<String?> getUserIdFromToken() async {
    final token = await ApiService.getToken();
    if (token == null) return null;

    try {
      final payload = Jwt.parseJwt(token);
      // print("JWT Payload: $payload"); // 👉 In ra toàn bộ payload

      return payload["sub"]
          ?.toString(); // đổi key nếu server dùng "id" hoặc "sub"
    } catch (e) {
      print("Error decoding token: $e");
      return null;
    }
  }

  /// Lưu token và thông tin user
  static Future<void> _saveTokenData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    try {
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      final userId = payload["userId"]?.toString() ?? "";
      final role = payload["role"]?.toString() ?? "";

      await prefs.setString(_userIdKey, userId);
      await prefs.setString(_roleKey, role);
    } catch (e) {
      // Log error but don't fail the login
      print("Error saving user data: $e");
    }
  }

  /// Validate JWT token format
  static bool _isValidJwtToken(String token) {
    final parts = token.split('.');
    return parts.length == 3;
  }

  /// Đăng xuất
  static Future<Map<String, dynamic>> logout() async {
    final url = Uri.parse(
      "$baseUrl/cmms/cip3/index.php?c=AuthController&m=logout",
    );

    try {
      final token = await getToken();
      if (token == null) {
        // Vẫn clear local data nếu không có token
        await _clearAuthData();
        return {"success": true, "message": "Đã đăng xuất"};
      }

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(_timeout);

      // Clear local data regardless of server response
      await _clearAuthData();

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return {
          "success": true,
          "message": body["message"] ?? "Đăng xuất thành công",
        };
      } else {
        // Still return success since we cleared local data
        return {"success": true, "message": "Đã đăng xuất khỏi thiết bị"};
      }
    } on http.TimeoutException {
      await _clearAuthData();
      return {"success": true, "message": "Đã đăng xuất (timeout)"};
    } catch (e) {
      await _clearAuthData();
      return {"success": true, "message": "Đã đăng xuất khỏi thiết bị"};
    }
  }

  /// Clear all auth data from local storage
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_tokenKey),
      prefs.remove(_userIdKey),
      prefs.remove(_roleKey),
    ]);
  }

  /// Lấy token từ local
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Lấy userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Lấy role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Kiểm tra user đã đăng nhập chưa
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;

    // Kiểm tra token có hết hạn không
    return !isTokenExpired(token);
  }

  /// Kiểm tra token có hết hạn không
  static bool isTokenExpired(String token) {
    try {
      return Jwt.isExpired(token);
    } catch (e) {
      return true; // Nếu không parse được thì coi như expired
    }
  }

  static Future<String?> getUsername() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final payload = Jwt.parseJwt(token);
      return payload["username"]?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Lấy thông tin user từ token
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final token = await getToken();
    if (token == null || isTokenExpired(token)) return null;

    try {
      final payload = Jwt.parseJwt(token);
      return {
        "userId": payload["userId"]?.toString() ?? "",
        "role": payload["role"]?.toString() ?? "",
        "username": payload["username"]?.toString() ?? "",
        "exp": payload["exp"],
        "iat": payload["iat"],
      };
    } catch (e) {
      return null;
    }
  }

  /// Refresh token (nếu API hỗ trợ)
  static Future<Map<String, dynamic>> refreshToken() async {
    final url = Uri.parse(
      "$baseUrl/cmms/cip3/index.php?c=AuthController&m=refresh",
    );

    try {
      final token = await getToken();
      if (token == null) {
        return {"success": false, "message": "Không tìm thấy token"};
      }

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body["accessToken"] != null) {
        final newToken = body["accessToken"] as String;
        await _saveTokenData(newToken);

        return {"success": true, "data": body};
      } else {
        return {
          "success": false,
          "message": body["error"] ?? "Refresh token thất bại",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Lỗi refresh token: ${e.toString()}",
      };
    }
  }

  /// Giải mã token thủ công (backup method)
  static Future<Map<String, dynamic>?> decodeToken() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      return jsonDecode(payload);
    } catch (e) {
      return null;
    }
  }
}
