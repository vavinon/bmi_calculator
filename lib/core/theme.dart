import 'package:flutter/material.dart';

/// ระบบดีไซน์โทนสีและฟอนต์ (Design System) ประจำแอปพลิเคชัน
/// จัดเตรียมสไตล์สำหรับโหมดมืด แก้วกึ่งโปร่งแสง (Dark Glassmorphic) และโหมดสว่างความเปรียบต่างสูง (High-Contrast Light Mode)
class AppTheme {
  /// สีเริ่มต้นไล่เฉดของพื้นหลัง (Gradient Start)
  final Color bgStart;

  /// สีสิ้นสุดไล่เฉดของพื้นหลัง (Gradient End)
  final Color bgEnd;

  /// สีพื้นหลังของแผงหน้าจอหลัก (Panel Background)
  final Color panelBg;

  /// สีขอบของแผงหน้าจอหลัก (Panel Border)
  final Color panelBorder;

  /// สีเด่นประจำแอปพลิเคชัน (Accent Color)
  final Color accentColor;

  /// สีตัวหนังสือหลัก (Primary Text)
  final Color textPrimary;

  /// สีตัวหนังสือรอง/ป้ายกำกับ (Secondary Text)
  final Color textSecondary;
  
  /// สีสัญลักษณ์สถานะน้ำหนักต่ำกว่าเกณฑ์
  final Color colorUnderweight;

  /// สีสัญลักษณ์สถานะน้ำหนักปกติ
  final Color colorNormal;

  /// สีสัญลักษณ์สถานะน้ำหนักเกิน
  final Color colorOverweight;

  /// สีสัญลักษณ์สถานะภาวะโรคอ้วน
  final Color colorObese;

  /// สีพื้นหลังของแถบน้ำหนักต่ำกว่าเกณฑ์
  final Color segBgUnder;

  /// สีพื้นหลังของแถบน้ำหนักปกติ
  final Color segBgNormal;

  /// สีพื้นหลังของแถบน้ำหนักเกิน
  final Color segBgOver;

  /// สีพื้นหลังของแถบภาวะโรคอ้วน
  final Color segBgObese;

  /// สีพื้นหลังการ์ดรายงานผลลัพธ์
  final Color cardBg;

  /// สีขอบการ์ดรายงานผลลัพธ์
  final Color cardBorder;

  /// สีแถบสไลเดอร์เลื่อนค่า (Slider Track)
  final Color sliderTrack;

  /// สีพื้นหลังของปุ่มเลือกสลับค่า (Switcher Background)
  final Color switcherBg;

  /// สีขอบของปุ่มเลือกสลับค่า (Switcher Border)
  final Color switcherBorder;

  /// คอนสตรัคเตอร์จัดเตรียมค่าดีไซน์
  const AppTheme({
    required this.bgStart,
    required this.bgEnd,
    required this.panelBg,
    required this.panelBorder,
    required this.accentColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.colorUnderweight,
    required this.colorNormal,
    required this.colorOverweight,
    required this.colorObese,
    required this.segBgUnder,
    required this.segBgNormal,
    required this.segBgOver,
    required this.segBgObese,
    required this.cardBg,
    required this.cardBorder,
    required this.sliderTrack,
    required this.switcherBg,
    required this.switcherBorder,
  });

  /// ค่าสไตล์โหมดมืด (Dark Mode) - ออกแบบตามกระจกฝ้าสีเข้มสไตล์ Premium
  static const AppTheme dark = AppTheme(
    bgStart: Color(0xFF0F172A),
    bgEnd: Color(0xFF1E1B4B),
    panelBg: Color(0x741E293B), // rgba(30, 41, 59, 0.45)
    panelBorder: Color(0x14FFFFFF), // rgba(255, 255, 255, 0.08)
    accentColor: Color(0xFF6366F1), // สีน้ำเงิน Indigo
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    colorUnderweight: Color(0xFF38BDF8),
    colorNormal: Color(0xFF10B981),
    colorOverweight: Color(0xFFF59E0B),
    colorObese: Color(0xFFEF4444),
    segBgUnder: Color(0x3838BDF8), // rgba(56, 189, 248, 0.22)
    segBgNormal: Color(0x4D10B981), // rgba(16, 185, 129, 0.30)
    segBgOver: Color(0x40F59E0B), // rgba(245, 158, 11, 0.25)
    segBgObese: Color(0x40EF4444), // rgba(239, 68, 68, 0.25)
    cardBg: Color(0x05FFFFFF), // rgba(255, 255, 255, 0.02)
    cardBorder: Color(0x0AFFFFFF), // rgba(255, 255, 255, 0.04)
    sliderTrack: Color(0x14FFFFFF), // rgba(255, 255, 255, 0.08)
    switcherBg: Color(0x0DFFFFFF), // rgba(255, 255, 255, 0.05)
    switcherBorder: Color(0x14FFFFFF), // rgba(255, 255, 255, 0.08)
  );

  /// ค่าสไตล์โหมดสว่าง (Light Mode) - ปรับปรุงค่าสีให้มี Contrast สูงเพื่ออ่านง่าย
  static const AppTheme light = AppTheme(
    bgStart: Color(0xFFF1F5F9),
    bgEnd: Color(0xFFCBD5E1),
    panelBg: Color(0x8CFFFFFF), // rgba(255, 255, 255, 0.55)
    panelBorder: Color(0x140F172A), // rgba(15, 23, 42, 0.08)
    accentColor: Color(0xFF4F46E5),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    colorUnderweight: Color(0xFF0284C7),
    colorNormal: Color(0xFF059669),
    colorOverweight: Color(0xFFD97706),
    colorObese: Color(0xFFDC2626),
    segBgUnder: Color(0xFFE0F2FE),
    segBgNormal: Color(0xFFD1FAE5),
    segBgOver: Color(0xFFFEF3C7),
    segBgObese: Color(0xFFFEE2E2),
    cardBg: Color(0x080F172A), // rgba(15, 23, 42, 0.03)
    cardBorder: Color(0x0F0F172A), // rgba(15, 23, 42, 0.06)
    sliderTrack: Color(0x140F172A), // rgba(15, 23, 42, 0.08)
    switcherBg: Color(0x0D0F172A), // rgba(15, 23, 42, 0.05)
    switcherBorder: Color(0x140F172A), // rgba(15, 23, 42, 0.08)
  );

  /// คืนค่าสไตล์ข้อความแบบเลือกฟอนต์ตามภาษา (Outfit สำหรับ EN, Sarabun สำหรับ TH)
  /// และควบคุมระยะความสูงบรรทัด [height] เพื่อรักษาวรรณยุกต์ไทยให้สมบูรณ์แบบข้ามแพลตฟอร์ม
  static TextStyle getTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required String lang,
  }) {
    final String fontFamily = lang == 'th' ? 'Sarabun' : 'Outfit';
    // เพิ่มระยะความสูงบรรทัด (height) เป็น 1.4 สำหรับภาษาไทย เพื่อป้องกันการทับซ้อนและวรรณยุกต์ไทยถูกบดบัง
    final double heightValue = lang == 'th' ? 1.4 : 1.15;

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: heightValue,
    );
  }
}
