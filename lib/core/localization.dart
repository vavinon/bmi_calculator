/// การจัดการระบบแปลสองภาษา (ไทย/อังกฤษ) ภายในแอปพลิเคชัน
/// เป็นคลาสเก็บพจนานุกรมและแปลงข้อความแบบ Offline-first
class AppLocalizations {
  /// ตัวระบุภาษาปัจจุบัน (เช่น 'th', 'en')
  final String locale;

  /// คอนสตรัคเตอร์สำหรับตั้งค่าภาษาตั้งต้น
  const AppLocalizations(this.locale);

  /// พจนานุกรมเก็บข้อความแปลภาษาของแอปพลิเคชัน
  static const Map<String, Map<String, String>> _localizedValues = {
    'th': {
      'app_title': 'เครื่องมือคำนวณน้ำหนักที่เหมาะสม',
      'gender': 'เพศ',
      'male': 'ชาย',
      'female': 'หญิง',
      'height': 'ส่วนสูง',
      'ideal_weight': 'น้ำหนักในอุดมคติ (Ideal Body Weight)',
      'ideal_weight_global': 'น้ำหนักอุดมคติเกณฑ์สากล (Global IBW)',
      'ideal_weight_asian': 'น้ำหนักอุดมคติเกณฑ์เอเชีย (Asian IBW)',
      'healthy_weight_range': 'ช่วงน้ำหนักที่เหมาะสม',
      'who_criteria': 'เกณฑ์สากล (WHO)',
      'asian_criteria': 'เกณฑ์เอเชีย (Asia)',
      'target_waist': 'คำแนะนำรอบเอวที่เหมาะสม',
      'target_waist_desc': 'รอบเอวของคุณไม่ควรเกิน',
      'underweight': 'ต่ำกว่าเกณฑ์',
      'normal_weight': 'ปกติ (เหมาะสมที่สุด)',
      'overweight': 'น้ำหนักเกิน',
      'obesity': 'ภาวะโรคอ้วน',
      'weight_unit': 'หน่วยน้ำหนัก',
      'kg': 'กก.',
      'lbs': 'ปอนด์',
      'theme': 'ธีม',
      'light': 'สว่าง',
      'dark': 'มืด',
      'personal_info': 'ข้อมูลส่วนตัว / PERSONAL INFO',
      'analysis_results': 'ผลวิเคราะห์ / ANALYSIS RESULTS',
      'waist_circumference_desc': 'รอบเอวที่ดีต่อสุขภาพไม่ควรเกินครึ่งหนึ่งของส่วนสูง',
      'formula_desc': 'คำนวณตามสูตร Devine Formula สำหรับส่วนสูงนี้',
      'formula_edge_desc': 'คงที่ค่าฐานส่วนสูงต่ำกว่าเกณฑ์ 5 ฟุต',
      'formula_asian_desc': 'คำนวณตามค่ากึ่งกลางช่วงดัชนีมวลกายปกติสำหรับเอเชีย (BMI 20.7)',
      'inches': 'นิ้ว',
      'less_than': 'ไม่เกิน',
      'error_empty_height': 'กรุณากรอกส่วนสูง',
      'error_invalid_height': 'กรุณากรอกส่วนสูงระหว่าง 100 - 250 ซม.',
    },
    'en': {
      'app_title': 'Ideal Weight Finder',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'height': 'Height',
      'ideal_weight': 'Ideal Body Weight (IBW)',
      'ideal_weight_global': 'Ideal Weight (Global IBW)',
      'ideal_weight_asian': 'Ideal Weight (Asian IBW)',
      'healthy_weight_range': 'Healthy Weight Range',
      'who_criteria': 'International (WHO)',
      'asian_criteria': 'Asian Criteria',
      'target_waist': 'Target Waist Circumference',
      'target_waist_desc': 'Your waist should be less than',
      'underweight': 'Underweight',
      'normal_weight': 'Normal (Optimal)',
      'overweight': 'Overweight',
      'obesity': 'Obesity',
      'weight_unit': 'Weight Unit',
      'kg': 'kg',
      'lbs': 'lbs',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'personal_info': 'Personal Info',
      'analysis_results': 'Analysis Results',
      'waist_circumference_desc': 'Healthy waist should be less than half of height',
      'formula_desc': 'Calculated via Devine Formula for this height',
      'formula_edge_desc': 'Capped at base weight (< 5 ft)',
      'formula_asian_desc': 'Calculated via healthy Asian BMI target midpoint (BMI 20.7)',
      'inches': 'inches',
      'less_than': 'Less than',
      'error_empty_height': 'Height cannot be empty.',
      'error_invalid_height': 'Please enter height between 100 - 250 cm.',
    }
  };

  /// แปลข้อความจาก Dictionary ตามภาษาที่กังหนดผ่าน [key]
  /// หากไม่พบคำศัพท์จะส่งกลับข้อความที่เป็น [key] เอง
  String translate(String key) {
    return _localizedValues[locale]?[key] ?? key;
  }
}
