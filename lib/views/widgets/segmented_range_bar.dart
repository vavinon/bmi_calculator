import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';

/// วิดเจ็ตแถบสีแสดงระดับน้ำหนักแบ่งตามส่วน (Segmented Range Bar)
/// จำลองแถบสีตามเกณฑ์ WHO และเกณฑ์เอเชีย พร้อมแสดงช่วงน้ำหนักแบบสลับหน่วยได้
class SegmentedRangeBar extends StatelessWidget {
  /// ชื่อหัวข้อเกณฑ์ (เช่น เกณฑ์เอเชีย หรือ เกณฑ์สากล)
  final String title;

  /// ขอบเขตน้ำหนัก BMI 18.5 (ขีดจำกัดบนของ Underweight)
  final double w18_5;

  /// ขีดจำกัดบนของช่วง Normal (22.9 สำหรับเอเชีย, 24.9 สำหรับ WHO)
  final double wNormalMax;

  /// ขีดจำกัดล่างของช่วง Overweight (23.0 สำหรับเอเชีย, 25.0 สำหรับ WHO)
  final double wOverweightMin;

  /// ขีดจำกัดบนของช่วง Overweight (24.9 สำหรับเอเชีย, 29.9 สำหรับ WHO)
  final double wOverweightMax;

  /// ขีดจำกัดล่างของช่วง Obese (25.0 สำหรับเอเชีย, 30.0 สำหรับ WHO)
  final double wObeseMin;

  /// สัญลักษณ์หน่วยน้ำหนักแสดงผลปัจจุบัน (เช่น 'กก.', 'ปอนด์', 'kg', 'lbs')
  final String weightUnitLabel;

  /// ชุดสีของระบบดีไซน์ปัจจุบัน (AppTheme)
  final AppTheme theme;

  /// พจนานุกรมแปลภาษาประจำแอปพลิเคชัน
  final AppLocalizations localizations;

  /// คอนสตรัคเตอร์สำหรับสร้างแถบแบ่งกลุ่มน้ำหนักสุขภาพดี
  const SegmentedRangeBar({
    super.key,
    required this.title,
    required this.w18_5,
    required this.wNormalMax,
    required this.wOverweightMin,
    required this.wOverweightMax,
    required this.wObeseMin,
    required this.weightUnitLabel,
    required this.theme,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    // ปรับรูปแบบตัวเลขทศนิยม 1 ตำแหน่งสำหรับช่วงน้ำหนัก
    final String txtUnder = '< ${w18_5.toStringAsFixed(1)}';
    final String txtNormal = '${w18_5.toStringAsFixed(1)}-${wNormalMax.toStringAsFixed(1)}';
    final String txtOver = '${wOverweightMin.toStringAsFixed(1)}-${wOverweightMax.toStringAsFixed(1)}';
    final String txtObese = '≥ ${wObeseMin.toStringAsFixed(1)}';

    final bool isDark = theme.textPrimary.value == const Color(0xFFF8FAFC).value;

    // กำหนดสีตัวอักษรของข้อความด้านในแต่ละช่วงแถบสี
    // โหมดมืด: ขาวสว่าง, โหมดสว่าง: สีคู่ตรงข้ามที่มีความเปรียบต่างสูง (High Contrast) เพื่อความชัดเจน
    final Color colorUnderText = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0369A1);
    final Color colorNormalText = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF065F46);
    final Color colorOverText = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF92400E);
    final Color colorObeseText = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF991B1B);

    // ปรับขนาดฟอนต์ให้เล็กลงในภาษาอังกฤษเนื่องจากคำศัพท์ยาวกว่า หรือสเกลข้อความให้พอดี
    final double textFontSize = localizations.locale == 'th' ? 10.5 : 9.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // หัวข้อระบุประเภทเกณฑ์คำนวณ
        Text(
          '$title ($weightUnitLabel)',
          style: AppTheme.getTextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: theme.textPrimary,
            lang: localizations.locale,
          ),
        ),
        const SizedBox(height: 8.0),
        
        // แถบสีแบ่งสัดส่วนน้ำหนักตัวจำลองด้วย Row + Flexible
        Container(
          height: 38.0,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.cardBorder,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11.0),
            child: Row(
              children: [
                // ช่วง Underweight: Flex 24%
                Expanded(
                  flex: 24,
                  child: Container(
                    color: theme.segBgUnder,
                    alignment: Alignment.center,
                    child: Text(
                      txtUnder,
                      style: TextStyle(
                        fontFamily: 'Outfit', // ตัวเลขใช้ฟอนต์ Outfit เสมอเพื่อความพรีเมียม
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                        color: colorUnderText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // เส้นกั้นพิกเซลระเบียบสายตา
                Container(width: 1.0, color: theme.cardBorder),
                
                // ช่วง Normal Weight: Flex 34%
                Expanded(
                  flex: 34,
                  child: Container(
                    color: theme.segBgNormal,
                    alignment: Alignment.center,
                    child: Text(
                      txtNormal,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                        color: colorNormalText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // เส้นกั้นพิกเซลระเบียบสายตา
                Container(width: 1.0, color: theme.cardBorder),
                
                // ช่วง Overweight: Flex 22%
                Expanded(
                  flex: 22,
                  child: Container(
                    color: theme.segBgOver,
                    alignment: Alignment.center,
                    child: Text(
                      txtOver,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                        color: colorOverText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // เส้นกั้นพิกเซลระเบียบสายตา
                Container(width: 1.0, color: theme.cardBorder),
                
                // ช่วง Obese: Flex 20%
                Expanded(
                  flex: 20,
                  child: Container(
                    color: theme.segBgObese,
                    alignment: Alignment.center,
                    child: Text(
                      txtObese,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w700,
                        color: colorObeseText,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
