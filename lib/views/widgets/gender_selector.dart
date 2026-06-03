import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';

/// วิดเจ็ตเลือกเพศชาย/หญิง แบบสองการ์ดเคียงข้างกัน
/// มาพร้อมกับอนิเมชันตอนกดสลับเลือกเพศอย่างนุ่มนวล (AnimatedContainer)
class GenderSelector extends StatelessWidget {
  /// สถานะการเลือกเพศปัจจุบัน (true = ชาย, false = หญิง)
  final bool isMale;

  /// ฟังก์ชัน Callback เมื่อผู้ใช้ทำการกดเลือกเพศ
  final ValueChanged<bool> onChanged;

  /// ชุดสีของระบบดีไซน์ปัจจุบัน (AppTheme)
  final AppTheme theme;

  /// พจนานุกรมแปลภาษาประจำแอปพลิเคชัน
  final AppLocalizations localizations;

  /// คอนสตรัคเตอร์สำหรับตั้งค่าพารามิเตอร์ของตัวเลือกเพศ
  const GenderSelector({
    super.key,
    required this.isMale,
    required this.onChanged,
    required this.theme,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('gender'),
          style: AppTheme.getTextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: theme.textSecondary,
            lang: localizations.locale,
          ),
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            // ปุ่มเลือกเพศชาย (Male)
            Expanded(
              child: _buildGenderCard(
                context: context,
                genderVal: true,
                icon: Icons.male_rounded,
                labelKey: 'male',
              ),
            ),
            const SizedBox(width: 12.0),
            // ปุ่มเลือกเพศหญิง (Female)
            Expanded(
              child: _buildGenderCard(
                context: context,
                genderVal: false,
                icon: Icons.female_rounded,
                labelKey: 'female',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ตัวสร้างการ์ดแต่ละปุ่มเพศพร้อมสไตล์กระจกโปร่งแสงและอนิเมชันสลับสี
  Widget _buildGenderCard({
    required BuildContext context,
    required bool genderVal,
    required IconData icon,
    required String labelKey,
  }) {
    final bool isActive = (isMale == genderVal);
    
    // กำหนดสีของการ์ดตามสถานะเปิดใช้งาน (Active / Inactive)
    final Color backgroundColor = isActive
        ? theme.accentColor.withOpacity(0.12)
        : theme.cardBg;
        
    final Color borderColor = isActive
        ? theme.accentColor
        : theme.cardBorder;

    final Color textColor = isActive
        ? theme.accentColor
        : theme.textSecondary;

    return GestureDetector(
      onTap: () => onChanged(genderVal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.accentColor.withOpacity(0.08),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.0,
              color: textColor,
            ),
            const SizedBox(width: 8.0),
            Text(
              localizations.translate(labelKey),
              style: AppTheme.getTextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: textColor,
                lang: localizations.locale,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
