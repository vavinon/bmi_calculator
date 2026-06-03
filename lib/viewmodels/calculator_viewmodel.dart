import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculator_model.dart';
import '../models/calculator_result.dart';

/// วิวโมเดลสำหรับการควบคุมสถานะ (UI State) และผูกโยงข้อมูลการคำนวณน้ำหนัก
/// สืบทอดความสามารถจาก [ChangeNotifier] เพื่อแจ้งการอัปเดตสถานะกับ UI
class CalculatorViewModel extends ChangeNotifier {
  
  // กุญแจสำคัญสำหรับเก็บข้อมูลใน Local Storage (SharedPreferences)
  static const String _keyLanguage = 'pref_language';
  static const String _keyWeightUnit = 'pref_weight_unit';
  static const String _keyThemeMode = 'pref_theme_mode';
  static const String _keyGender = 'pref_gender';
  static const String _keyHeight = 'pref_height';

  // ค่าสถานะปัจจุบันเริ่มต้น
  double _height = 170.0;
  String _heightInputText = '170';
  bool _isMale = true;
  String _language = 'th';
  String _weightUnit = 'kg'; // 'kg' หรือ 'lbs'
  String _themeMode = 'dark'; // 'dark' หรือ 'light'
  String? _heightError;

  /// ดึงข้อมูลค่าส่วนสูงปัจจุบัน (หน่วยเซนติเมตร)
  double get height => _height;

  /// ดึงข้อมูลตัวเลขที่ผู้ใช้กรอกใน Text Box
  String get heightInputText => _heightInputText;

  /// ดึงค่าตัวเลือกเพศ (true = ชาย, false = หญิง)
  bool get isMale => _isMale;

  /// ดึงข้อมูลภาษาที่เลือกใช้งาน ('th' หรือ 'en')
  String get language => _language;

  /// ดึงข้อมูลหน่วยวัดน้ำหนักที่เลือกแสดงผล ('kg' หรือ 'lbs')
  String get weightUnit => _weightUnit;

  /// ดึงข้อมูลโหมดธีมสไตล์ปัจจุบัน ('dark' หรือ 'light')
  String get themeMode => _themeMode;

  /// ดึงสถานะข้อความผิดพลาดในการป้อนข้อมูลส่วนสูง (ถ้ามี)
  String? get heightError => _heightError;

  /// ดึงข้อมูลเวอร์ชันของแอปพลิเคชัน
  String get appVersion => '1.0.0';

  /// ออบเจกต์คำนวณผลลัพธ์ข้อมูลสุขภาพแบบไดนามิกอิงตามส่วนสูงและเพศล่าสุด
  CalculatorResult get result => CalculatorModel.calculate(
        heightCm: _height,
        isMale: _isMale,
      );

  /// คอนสตรัคเตอร์เรียกเริ่มต้นโหลดข้อมูลจากการตั้งค่าเดิมที่เก็บไว้
  CalculatorViewModel() {
    _loadSettings();
  }

  // โหลดค่าการตั้งค่าล่าสุดจากหน่วยความจำ
  Future<void> _loadSettings() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _language = prefs.getString(_keyLanguage) ?? 'th';
      _weightUnit = prefs.getString(_keyWeightUnit) ?? 'kg';
      _themeMode = prefs.getString(_keyThemeMode) ?? 'dark';
      _isMale = prefs.getBool(_keyGender) ?? true;
      _height = prefs.getDouble(_keyHeight) ?? 170.0;
      _heightInputText = _height.round().toString();
      _heightError = null;
      notifyListeners();
    } catch (e) {
      // กรณีมีปัญหากับ Storage (เช่น ในเว็บที่ถูกบล็อกแคช) ให้รันด้วยค่าดีฟอลต์ต่อไป
      debugPrint('Error loading preferences: $e');
    }
  }

  /// สลับภาษาใช้งานระหว่างภาษาไทย ('th') และภาษาอังกฤษ ('en')
  void setLanguage(String lang) {
    if (lang != _language) {
      _language = lang;
      notifyListeners();
      _saveSetting(_keyLanguage, lang);
    }
  }

  /// สลับหน่วยวัดแสดงผลน้ำหนักระหว่าง 'kg' (กิโลกรัม) และ 'lbs' (ปอนด์)
  void setWeightUnit(String unit) {
    if (unit != _weightUnit) {
      _weightUnit = unit;
      notifyListeners();
      _saveSetting(_keyWeightUnit, unit);
    }
  }

  /// สลับโหมดธีมการแสดงผลระหว่างสีมืด ('dark') และสีสว่าง ('light')
  void setThemeMode(String theme) {
    if (theme != _themeMode) {
      _themeMode = theme;
      notifyListeners();
      _saveSetting(_keyThemeMode, theme);
    }
  }

  /// ตั้งค่าเพศผู้ใช้งาน (true = ชาย, false = หญิง)
  void setGender(bool male) {
    if (male != _isMale) {
      _isMale = male;
      notifyListeners();
      _saveBoolSetting(_keyGender, male);
    }
  }

  /// อัปเดตข้อมูลส่วนสูงจากการเลื่อนแถบสไลเดอร์ (Slider)
  /// จะอัปเดตข้อมูลข้อความในช่องพิมพ์ให้ซิงก์กันโดยอัตโนมัติ
  void updateHeightFromSlider(double value) {
    _height = value;
    _heightInputText = value.round().toString();
    _heightError = null; // ปิดข้อความเตือนเสมอเนื่องจากการเลื่อนสไลเดอร์อยู่ภายในช่วงที่ถูกต้องเสมอ
    notifyListeners();
    _saveDoubleSetting(_keyHeight, value);
  }

  /// อัปเดตและตรวจสอบความถูกต้องของการกรอกข้อความส่วนสูงโดยตรง (Text Input)
  /// 
  /// รองรับกฎการซิงโครไนซ์และความปลอดภัย:
  /// 1. ตรวจสอบค่าว่าง -> แสดงสีแดงแจ้งเตือน แต่ผลลัพธ์คำนวณยังเป็นค่าเดิม
  /// 2. ตรวจสอบขอบเขต 100 - 250 -> แสดงเตือน แต่ผลลัพธ์คำนวณยังค้างค่าเดิมที่ถูกต้องล่าสุด
  /// 3. ค่าถูกต้อง -> ซิงก์ตำแหน่งสไลเดอร์ และคำนวณน้ำหนักตัวใหม่แบบเรียลไทม์
  void updateHeightFromText(String text) {
    _heightInputText = text;

    if (text.trim().isEmpty) {
      _heightError = 'error_empty_height';
      notifyListeners();
      return;
    }

    final double? parsedValue = double.tryParse(text);
    
    // ตรวจสอบว่าต้องเป็นตัวเลขจำนวนเต็มบวก หรือทศนิยมตามขอบเขต
    if (parsedValue == null || parsedValue < 100.0 || parsedValue > 250.0) {
      _heightError = 'error_invalid_height';
      notifyListeners();
      return;
    }

    // ผ่านการยืนยันข้อมูล (Input Validated)
    _height = parsedValue;
    _heightError = null;
    notifyListeners();
    _saveDoubleSetting(_keyHeight, parsedValue);
  }

  // ตัวช่วยบันทึกการตั้งค่าลง Local Storage
  Future<void> _saveSetting(String key, String value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      debugPrint('Error saving preference $key: $e');
    }
  }

  Future<void> _saveBoolSetting(String key, bool value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e) {
      debugPrint('Error saving preference $key: $e');
    }
  }

  Future<void> _saveDoubleSetting(String key, double value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, value);
    } catch (e) {
      debugPrint('Error saving preference $key: $e');
    }
  }
}
