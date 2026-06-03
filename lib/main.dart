import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/calculator_viewmodel.dart';
import 'views/home_page.dart';

void main() {
  // เริ่มต้นเตรียมการ Binding พื้นฐานสำหรับช่องทางติดต่อระบบปฎิบัติการ
  // จำเป็นต้องเรียกคำสั่งนี้เนื่องจากเราโหลดข้อมูล SharedPreferences ในตอนเปิดตัวทันทีก่อนการสร้าง UI
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => CalculatorViewModel(),
      child: const MyApp(),
    ),
  );
}

/// รูทวิดเจ็ตหลักของแอปพลิเคชันเครื่องมือคำนวณน้ำหนักที่เหมาะสม
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // สังเกตการณ์การสลับภาษาหรือสลับธีมจาก ViewModel
    final viewModel = context.watch<CalculatorViewModel>();

    return MaterialApp(
      title: 'Ideal Weight Finder',
      debugShowCheckedModeBanner: false,
      // บันทึกและสลับโหมดการแสดงผลของ MaterialApp ให้กลมกลืนกับ ViewModel
      themeMode: viewModel.themeMode == 'light' ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        // กำหนดฟอนต์หลักของระบบสากลตามภาษาที่เลือกใช้งาน
        fontFamily: viewModel.language == 'th' ? 'Sarabun' : 'Outfit',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: viewModel.language == 'th' ? 'Sarabun' : 'Outfit',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
