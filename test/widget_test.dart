import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bmi_calculator/models/calculator_model.dart';
import 'package:bmi_calculator/viewmodels/calculator_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('CalculatorModel Unit Tests', () {
    
    test('ชาย สูง 170 cm: ควรคำนวณ Ideal Weight ได้ 65.9 kg และรอบเอวไม่เกิน 85 cm', () {
      final result = CalculatorModel.calculate(heightCm: 170.0, isMale: true);
      
      // Devine: 50 + 2.3 * ((170/2.54) - 60) = 50 + 2.3 * 6.929 = 65.937 kg
      expect(result.idealBodyWeight.toStringAsFixed(1), '65.9');
      
      // Waist: min(170/2, 90) = 85 cm
      expect(result.recommendedWaistCm, 85.0);
      expect(result.isEdgeCase, false);
    });

    test('หญิง สูง 170 cm: ควรคำนวณ Ideal Weight ได้ 61.4 kg และรอบเอวไม่เกิน 80 cm', () {
      final result = CalculatorModel.calculate(heightCm: 170.0, isMale: false);
      
      // Devine: 45.5 + 2.3 * ((170/2.54) - 60) = 45.5 + 2.3 * 6.929 = 61.437 kg
      expect(result.idealBodyWeight.toStringAsFixed(1), '61.4');
      
      // Waist: min(170/2, 80) = 80 cm
      expect(result.recommendedWaistCm, 80.0);
      expect(result.isEdgeCase, false);
    });

    test('กรณีขีดจำกัดล่าง (Height < 152.4 cm): ส่วนสูง 140 cm ชายต้องได้ 50 kg หญิงต้องได้ 45.5 kg', () {
      final maleResult = CalculatorModel.calculate(heightCm: 140.0, isMale: true);
      final femaleResult = CalculatorModel.calculate(heightCm: 140.0, isMale: false);
      
      expect(maleResult.idealBodyWeight, 50.0);
      expect(maleResult.isEdgeCase, true);
      
      expect(femaleResult.idealBodyWeight, 45.5);
      expect(femaleResult.isEdgeCase, true);
    });

    test('การคำนวณช่วง BMI เกณฑ์เอเชียและ WHO ที่ส่วนสูง 170 cm', () {
      final result = CalculatorModel.calculate(heightCm: 170.0, isMale: true);
      
      // Height in meters = 1.7. Height squared = 2.89
      // WHO Min (18.5): 18.5 * 2.89 = 53.465 -> 53.5
      // WHO Max (24.9): 24.9 * 2.89 = 71.961 -> 72.0
      expect(result.whoMinWeight.toStringAsFixed(1), '53.5');
      expect(result.whoMaxWeight.toStringAsFixed(1), '72.0');

      // Asia Min (18.5): 18.5 * 2.89 = 53.465 -> 53.5
      // Asia Max (22.9): 22.9 * 2.89 = 66.181 -> 66.2
      expect(result.asianMinWeight.toStringAsFixed(1), '53.5');
      expect(result.asianMaxWeight.toStringAsFixed(1), '66.2');
    });
  });

  group('CalculatorViewModel State & Validation Tests', () {
    late CalculatorViewModel viewModel;

    setUp(() {
      viewModel = CalculatorViewModel();
    });

    test('ตรวจสอบค่าสถานะเริ่มต้นของ ViewModel', () {
      expect(viewModel.height, 170.0);
      expect(viewModel.heightInputText, '170');
      expect(viewModel.isMale, true);
      expect(viewModel.language, 'th');
      expect(viewModel.weightUnit, 'kg');
      expect(viewModel.heightError, null);
    });

    test('การเลื่อน Slider ส่วนสูง: ค่าข้อความช่องกรอกต้องซิงก์เปลี่ยนตาม', () {
      viewModel.updateHeightFromSlider(182.0);
      expect(viewModel.height, 182.0);
      expect(viewModel.heightInputText, '182');
      expect(viewModel.heightError, null);
    });

    test('การกรอกส่วนสูงที่ถูกต้องในช่องพิมพ์: สไลเดอร์ส่วนสูงต้องเปลี่ยนตาม', () {
      viewModel.updateHeightFromText('165');
      expect(viewModel.height, 165.0);
      expect(viewModel.heightInputText, '165');
      expect(viewModel.heightError, null);
    });

    test('การตรวจสอบความปลอดภัยช่องข้อมูลว่าง: ต้องแจ้ง Error และผลลัพธ์คำนวณน้ำหนักต้องคงที่ตามค่าเดิม', () {
      viewModel.updateHeightFromSlider(170.0);
      viewModel.updateHeightFromText('');
      
      expect(viewModel.heightInputText, '');
      expect(viewModel.heightError, 'error_empty_height');
      // น้ำหนักและส่วนสูงโมเดลยังคงค้างค่าเดิมที่ถูกต้องล่าสุด (170.0)
      expect(viewModel.height, 170.0);
    });

    test('การกรอกส่วนสูงนอกขอบเขตจำกัด (ต่ำกว่า 100 หรือสูงกว่า 250): ต้องแจ้ง Error และค้างค่าคำนวณเดิม', () {
      viewModel.updateHeightFromSlider(170.0);
      
      // ต่ำกว่า 100
      viewModel.updateHeightFromText('99');
      expect(viewModel.heightInputText, '99');
      expect(viewModel.heightError, 'error_invalid_height');
      expect(viewModel.height, 170.0);

      // สูงกว่า 250
      viewModel.updateHeightFromText('251');
      expect(viewModel.heightInputText, '251');
      expect(viewModel.heightError, 'error_invalid_height');
      expect(viewModel.height, 170.0);
    });
  });
}
