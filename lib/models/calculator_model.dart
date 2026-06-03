import 'dart:math' as math;
import 'calculator_result.dart';

/// โมเดลคำนวณทางคณิตศาสตร์สำหรับน้ำหนักและสัดส่วนสุขภาพดี
/// ประกอบด้วยการคำนวณ Ideal Body Weight, Target Waist และช่วงน้ำหนักตัวตาม BMI
class CalculatorModel {
  
  /// ค่าคงที่ความสูงฐาน 5 ฟุต (60 นิ้ว) ในหน่วยเซนติเมตร
  static const double baseHeightCm = 152.4;

  /// คำนวณผลลัพธ์ข้อมูลสุขภาพทั้งหมดจากความสูงและเพศ
  /// 
  /// [heightCm] ส่วนสูงหน่วยเซนติเมตร (ต้องอยู่ระหว่าง 100 - 250 cm)
  /// [isMale] เพศผู้ใช้งาน (true = ชาย, false = หญิง)
  static CalculatorResult calculate({
    required double heightCm,
    required bool isMale,
  }) {
    // 1. ตรวจสอบเงื่อนไขส่วนสูงต่ำกว่า 5 ฟุต (152.4 cm)
    final double heightInInches = heightCm / 2.54;
    final double inchesOver60 = heightInInches - 60.0;
    
    double idealBodyWeight;
    bool isEdgeCase = false;

    if (inchesOver60 < 0) {
      // หากส่วนสูงต่ำกว่า 5 ฟุต ให้คงที่น้ำหนักเริ่มต้นมาตรฐานไว้
      idealBodyWeight = isMale ? 50.0 : 45.5;
      isEdgeCase = true;
    } else {
      final double baseWeight = isMale ? 50.0 : 45.5;
      idealBodyWeight = baseWeight + (2.3 * inchesOver60);
    }

    // 2. คำนวณคำแนะนำรอบเอวที่เหมาะสม
    final double maxWaistLimit = isMale ? 90.0 : 80.0;
    final double calculatedWaist = heightCm / 2.0;
    final double recommendedWaistCm = math.min(calculatedWaist, maxWaistLimit);
    final double recommendedWaistInches = recommendedWaistCm / 2.54;

    // 3. คำนวณช่วงน้ำหนักตามดัชนีมวลกาย (BMI)
    final double heightInMeters = heightCm / 100.0;
    final double heightSquared = heightInMeters * heightInMeters;

    // เกณฑ์สากล (WHO Criteria)
    final double whoMinWeight = 18.5 * heightSquared;
    final double whoMaxWeight = 24.9 * heightSquared;

    // เกณฑ์เอเชีย (Asian Criteria)
    final double asianMinWeight = 18.5 * heightSquared;
    final double asianMaxWeight = 22.9 * heightSquared;

    // คำนวณน้ำหนักตัวในอุดมคติของชาวเอเชีย (อิงค่ากึ่งกลางช่วงปกติเอเชีย BMI = 20.7)
    final double asianIdealBodyWeight = 20.7 * heightSquared;

    return CalculatorResult(
      idealBodyWeight: idealBodyWeight,
      asianIdealBodyWeight: asianIdealBodyWeight,
      recommendedWaistCm: recommendedWaistCm,
      recommendedWaistInches: recommendedWaistInches,
      whoMinWeight: whoMinWeight,
      whoMaxWeight: whoMaxWeight,
      asianMinWeight: asianMinWeight,
      asianMaxWeight: asianMaxWeight,
      isEdgeCase: isEdgeCase,
    );
  }
}
