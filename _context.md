# Project Context: bmi-calculator

## Goal & Scope
- เป้าหมายสูงสุด: พัฒนาแอปพลิเคชันที่รองรับการใช้งานข้ามแพลตฟอร์มอย่างสมบูรณ์ (iOS, Android, Windows, Web)
- ฟีเจอร์หลัก: คำนวณช่วงน้ำหนักที่เหมาะสม (Healthy Weight Range) ตามเกณฑ์ดัชนีมวลกาย WHO และ Asia, หาน้ำหนักในอุดมคติ (Ideal Body Weight), แสดงคำแนะนำรอบเอวที่เหมาะสม (Target Waist Circumference) โดยไม่ต้องกรอกข้อมูลเพิ่ม และรองรับระบบ 2 ภาษา (ไทย/อังกฤษ)
- เน้นความง่ายในการบำรุงรักษา (Maintainability) และความเร็วในการพัฒนา (Development Speed)

## Tech Stack & Standards
- Language: Dart
- Architecture: MVVM (Model-View-ViewModel using ChangeNotifier / Provider)
- Shared Library: provider, shared_preferences (for history data)
- UI Framework: Flutter
- Backend Framework: Offline-first

## Constraints & Rules
- **No Hardcoding:** ห้ามฝังค่า Configuration หรือ Path ลงในโค้ดโดยตรง (ใช้ไฟล์คอนฟิกแทน)
- **Separation of Concerns:** โค้ดส่วน Business Logic ต้องรันได้โดยไม่ขึ้นกับ UI Layer
- **Async/Await:** งานทุกอย่างที่เกี่ยวข้องกับ I/O หรือ Network ต้องเป็น Async เสมอ
- **Documentation:** ทุก Class และ Method สำคัญ ต้องมีการเขียน Dart Doc Comments (`///`) ให้ชัดเจน

## Platform-Specific Notes 
- โครงสร้างไฟล์สำหรับส่วนแยกแพลตฟอร์ม: `android/`, `ios/`, `windows/`, `web/`
- ต้องรองรับทั้ง Light Mode และ Dark Mode (สลับตามระบบหรือสลับด้วยตนเอง)
- รองรับหน้าจอขนาดเล็กและใหญ่

## Current Status & Priority
- สถานะปัจจุบัน: อยู่ในช่วงเริ่มต้นวางโครงสร้าง
