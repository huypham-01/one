import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/cmms/presentation/providers/report_provider.dart';
import 'package:mobile/cmms/data/models/equipment.dart';

// ─── Modern Light Industrial Theme Colors ─────────────────────────────────────
const _kBgColor = Color(0xFFF4F7FA);
const _kCardColor = Colors.white;
const _kTextColor = Color(0xFF2C3E50);
const _kTextSecondary = Color(0xFF7F8C8D);
const _kBorderColor = Color(0xFFE0E6ED);
const _kSuccessColor = Color(0xFF27AE60);
const _kErrorColor = Color(0xFFE74C3C);

class SubmitRepairResultScreen extends StatefulWidget {
  final String scanResult;

  const SubmitRepairResultScreen({super.key, required this.scanResult});

  @override
  State<SubmitRepairResultScreen> createState() =>
      _SubmitRepairResultScreenState();
}

class _SubmitRepairResultScreenState extends State<SubmitRepairResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  String? _selectedIssueType;
  String? _selectedRepairMethod;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ReportProvider>();
      provider.fetchRepairMethods();
      provider.fetchIssueTypes();
      provider.fetchEquipmentByMachineId(widget.scanResult);
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ReportProvider>();
    final equipment = provider.equipment;

    if (equipment == null) {
      _showSnackBar(
        'Không tìm thấy thông tin thiết bị. Vui lòng thử lại.',
        isError: true,
      );
      return;
    }

    HapticFeedback.mediumImpact();

    await provider.submitRepairResult(
      breakdownUuid: equipment.breakdownUuid!,
      issueTypeUuid: _selectedIssueType!,
      methodTypeUuid: _selectedRepairMethod!,
      otp: _otpController.text.trim(),
    );

    if (!mounted) return;

    if (provider.submitSuccess) {
      _showSnackBar('Kết quả sửa chữa đã được gửi thành công!', isError: false);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    } else if (provider.submitErrorMessage != null) {
      _showSnackBar('Lỗi: ${provider.submitErrorMessage}', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? _kErrorColor : _kSuccessColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String get _currentLanguageCode {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'zh') return 'zh';
    return 'vi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgColor,
      appBar: AppBar(
        title: const Text(
          'SUBMIT REPAIR RESULT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontSize: 18,
          ),
        ),
        backgroundColor: cusBlue,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionTitle('Machine Scanned'),
                const SizedBox(height: 12),
                _buildMachineSection(),

                const SizedBox(height: 24),
                _buildSectionTitle('Diagnostics & Action'),
                const SizedBox(height: 12),
                _buildDiagnosticsSection(),

                const SizedBox(height: 24),
                _buildSectionTitle('Authorization'),
                const SizedBox(height: 12),
                _buildOtpSection(),

                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: _kTextSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: _kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ─── Machine Section ───────────────────────────────────────────────────────
  Widget _buildMachineSection() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cusBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.qr_code, color: cusBlue, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ID THIẾT BỊ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _kTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.scanResult,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _kTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle, color: _kSuccessColor, size: 28),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: _kBorderColor, height: 1),
            ),
            Consumer<ReportProvider>(
              builder: (context, provider, _) {
                if (provider.isLoadingEquipment) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (provider.equipment == null &&
                    provider.errorMessage != null) {
                  return _buildErrorBox(
                    'Lỗi tải thông tin thiết bị:\n${provider.errorMessage!}',
                  );
                }
                if (provider.equipment != null) {
                  return _buildEquipmentDetails(provider.equipment!);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentDetails(EquipmentData equipment) {
    return Column(
      children: [
        _buildDetailRow('Family', equipment.family),
        const SizedBox(height: 8),
        _buildDetailRow('Category', equipment.category),
        const SizedBox(height: 8),
        _buildDetailRow('Unit', equipment.unit),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: _kTextSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _kTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── Diagnostics Section ───────────────────────────────────────────────────
  Widget _buildDiagnosticsSection() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loại Sự Cố',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _kTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Consumer<ReportProvider>(
              builder: (context, provider, child) {
                if (provider.isLoadingIssues) {
                  return _buildLoadingField();
                }
                if (provider.errorMessage != null &&
                    provider.issueTypes.isEmpty) {
                  return _buildErrorBox(provider.errorMessage!);
                }
                return _buildSelectorField(
                  hint: 'Chọn loại sự cố...',
                  value: _selectedIssueType,
                  items: provider.issueTypes,
                  getLabel: (item) =>
                      item.getDisplayNameByLocale(_currentLanguageCode),
                  getValue: (item) => item.uuid,
                  onChanged: (value) =>
                      setState(() => _selectedIssueType = value),
                );
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Phương Pháp Sửa Chữa',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _kTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Consumer<ReportProvider>(
              builder: (context, provider, child) {
                if (provider.isLoadingMethods) {
                  return _buildLoadingField();
                }
                if (provider.errorMessage != null &&
                    provider.repairMethods.isEmpty) {
                  return _buildErrorBox(provider.errorMessage!);
                }
                return _buildSelectorField(
                  hint: 'Chọn phương pháp...',
                  value: _selectedRepairMethod,
                  items: provider.repairMethods,
                  getLabel: (item) =>
                      item.getDisplayNameByLocale(_currentLanguageCode),
                  getValue: (item) => item.uuid,
                  onChanged: (value) =>
                      setState(() => _selectedRepairMethod = value),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── OTP Section ───────────────────────────────────────────────────────────
  Widget _buildOtpSection() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Nhập mã OTP để xác nhận kết quả sửa chữa',
              style: TextStyle(color: _kTextSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 28,
                letterSpacing: 10,
                fontWeight: FontWeight.bold,
                color: cusBlue,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: _kBgColor,
                counterText: '',
                hintText: '000000',
                hintStyle: TextStyle(
                  color: _kBorderColor,
                  fontSize: 28,
                  letterSpacing: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _kBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _kBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: cusBlue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _kErrorColor),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Vui lòng nhập mã OTP';
                if (value.length != 6) return 'Mã OTP phải có 6 chữ số';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Submit Button ─────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    return Consumer<ReportProvider>(
      builder: (context, provider, _) {
        final isSubmitting = provider.isSubmitting;
        return SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: _kSuccessColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: _kBorderColor,
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'SUBMIT RESULT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
          ),
        );
      },
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  Widget _buildSelectorField<T>({
    required String hint,
    required String? value,
    required List<T> items,
    required String Function(T) getLabel,
    required String Function(T) getValue,
    required void Function(String?) onChanged,
  }) {
    String displayLabel = hint;
    bool hasValue = false;
    if (value != null) {
      try {
        final selected = items.firstWhere((item) => getValue(item) == value);
        displayLabel = getLabel(selected);
        hasValue = true;
      } catch (_) {}
    }

    return FormField<String>(
      initialValue: value,
      validator: (val) => val == null || val.isEmpty ? 'Vui lòng chọn' : null,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final selectedValue = await _showSelectorBottomSheet<T>(
                  context: context,
                  title: hint,
                  items: items,
                  getLabel: getLabel,
                  getValue: getValue,
                  currentValue: value,
                );
                if (selectedValue != null) {
                  onChanged(selectedValue);
                  state.didChange(selectedValue);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: _kBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: state.hasError
                        ? _kErrorColor
                        : (hasValue ? cusBlue : _kBorderColor),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        displayLabel,
                        style: TextStyle(
                          fontSize: 15,
                          color: hasValue ? _kTextColor : _kTextSecondary,
                          fontWeight: hasValue
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: hasValue ? cusBlue : _kTextSecondary,
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: _kErrorColor, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<String?> _showSelectorBottomSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) getLabel,
    required String Function(T) getValue,
    required String? currentValue,
  }) {
    final searchController = TextEditingController();

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final query = searchController.text.toLowerCase();
            final filteredItems = query.isEmpty
                ? items
                : items
                      .where(
                        (item) => getLabel(item).toLowerCase().contains(query),
                      )
                      .toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _kTextColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: _kTextSecondary,
                          ),
                          filled: true,
                          fillColor: _kBgColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: _kBorderColor),
                    Expanded(
                      child: filteredItems.isEmpty
                          ? const Center(
                              child: Text(
                                'Không tìm thấy kết quả',
                                style: TextStyle(color: _kTextSecondary),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final label = getLabel(item);
                                final val = getValue(item);
                                final isSelected = val == currentValue;

                                return ListTile(
                                  title: Text(
                                    label,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected ? cusBlue : _kTextColor,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? Icon(Icons.check, color: cusBlue)
                                      : null,
                                  onTap: () => Navigator.pop(context, val),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingField() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: _kBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorderColor),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorBox(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kErrorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kErrorColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: _kErrorColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: _kErrorColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
