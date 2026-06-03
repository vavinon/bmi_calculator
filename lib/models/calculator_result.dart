/// คลาสเก็บผลลัพธ์จากการคำนวณทั้งหมดของแอปพลิเคชัน
/// ประกอบด้วยน้ำหนักที่เหมาะสมและขนาดรอบเอวสูงสุด
class CalculatorResult {
  /// น้ำหนักตัวในอุดมคติ (Ideal Body Weight) ในหน่วยกิโลกรัม (kg)
  final double idealBodyWeight;

  /// ขนาดรอบเอวที่เหมาะสมสูงสุด (Target Waist) ในหน่วยเซนติเมตร (cm)
  final double recommendedWaistCm;

  /// ขนาดรอบเอวที่เหมาะสมสูงสุด (Target Waist) ในหน่วยนิ้ว (inches)
  final double recommendedWaistInches;

  /// น้ำหนักต่ำสุดสำหรับเกณฑ์ปกติสากล (WHO Min Weight) ในหน่วยกิโลกรัม (kg)
  final double whoMinWeight;

  /// น้ำหนักสูงสุดสำหรับเกณฑ์ปกติสากล (WHO Max Weight) ในหน่วยกิโลกรัม (kg)
  final double whoMaxWeight;

  /// น้ำหนักต่ำสุดสำหรับเกณฑ์ปกติเอเชีย (Asian Min Weight) ในหน่วยกิโลกรัม (kg)
  final double asianMinWeight;

  /// น้ำหนักสูงสุดสำหรับเกณฑ์ปกติเอเชีย (Asian Max Weight) ในหน่วยกิโลกรัม (kg)
  final double asianMaxWeight;

  /// น้ำหนักตัวในอุดมคติของชาวเอเชีย (Asian Ideal Body Weight) ในหน่วยกิโลกรัม (kg)
  final double asianIdealBodyWeight;

  /// สถานะกรณีขอบเขตส่วนสูงต่ำกว่า 5 ฟุต (152.4 cm)
  final bool isEdgeCase;

  /// คอนสตรัคเตอร์สำหรับสร้างออบเจกต์ผลลัพธ์
  const CalculatorResult({
    required this.idealBodyWeight,
    required this.asianIdealBodyWeight,
    required this.recommendedWaistCm,
    required this.recommendedWaistInches,
    required this.whoMinWeight,
    required this.whoMaxWeight,
    required this.asianMinWeight,
    required this.asianMaxWeight,
    required this.isEdgeCase,
  });
}
