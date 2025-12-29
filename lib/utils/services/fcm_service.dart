import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class FcmService {
  static Future<void> init() async {
    // 1️⃣ Xin quyền (iOS cần)
    await FirebaseMessaging.instance.requestPermission();

    // 2️⃣ Lấy token
    final token = await FirebaseMessaging.instance.getToken();
    print('🔥 FCM TOKEN: $token');

    // TODO: gửi token này lên backend sau

    // 3️⃣ Lắng nghe refresh token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('♻️ Token refreshed: $newToken');
      // TODO: update token lên backend
    });
  }
}
