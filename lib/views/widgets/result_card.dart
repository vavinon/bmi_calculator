import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';

/// วิดเจ็ตการ์ดแสดงผลลัพธ์แบบแก้วกึ่งโปร่งแสง (Glassmorphic Result Card)
/// มีแถบสีเด่นซ้ายมือ (Border Left Accent) และกรอบขอบแก้วบางเฉียบ
class ResultCard extends StatelessWidget {
  /// หัวข้อการ์ดด้านบน (Label)
  final String label;

  /// วิดเจ็ตแสดงตัวเลขและหน่วยผลลัพธ์ตรงกลาง (Value Widget)
  final Widget valueWidget;

  /// ข้อความคำอธิบายด้านล่าง (Description)
  final String description;

  /// สีเด่นฝั่งซ้ายมือ (Left Border Accent Color)
  final Color borderAccentColor;

  /// โทนสีพื้นหลังย้อมพิเศษสำหรับการ์ดแต่ละประเภท
  final Color cardBgColor;

  /// ชุดสีของระบบดีไซน์ปัจจุบัน (AppTheme)
  final AppTheme theme;

  /// พจนานุกรมแปลภาษาประจำแอปพลิเคชัน
  final AppLocalizations localizations;

  /// คอนสตรัคเตอร์สำหรับสร้างการ์ดแสดงผลลัพธ์
  const ResultCard({
    super.key,
    required this.label,
    required this.valueWidget,
    required this.description,
    required this.borderAccentColor,
    required this.cardBgColor,
    required this.theme,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border.all(
          color: theme.cardBorder,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          // สร้างแทบสีแนวขวางซ้ายมือด้วยการซ้อนแถบสีในขอบเขต Container
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: borderAccentColor,
                width: 5.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ป้ายหัวข้อการ์ด
              Text(
                label,
                style: AppTheme.getTextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  color: theme.textSecondary,
                  lang: localizations.locale,
                ),
              ),
              const SizedBox(height: 8.0),
              
              // ตัวเลขผลลัพธ์หลักตรงกลาง
              valueWidget,
              const SizedBox(height: 8.0),
              
              // เส้นคั่นบางๆ ด้านล่างก่อนแสดงคำอธิบาย
              Divider(
                color: theme.cardBorder,
                height: 1.0,
                thickness: 1.0,
              ),
              const SizedBox(height: 8.0),
              
              // คำอธิบายสูตรคำนวณหรือเป้าหมายสุขภาพ
              Text(
                description,
                style: AppTheme.getTextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: theme.textSecondary,
                  lang: localizations.locale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
