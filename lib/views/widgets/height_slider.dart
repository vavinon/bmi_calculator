import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../core/localization.dart';

/// วิดเจ็ตสไลเดอร์ส่วนสูงและช่องพิมพ์ป้อนตัวเลขแบบซิงค์ข้อมูลเรียลไทม์
/// มาพร้อมกับระบบตรวจสอบความถูกต้อง (Validation Highlight) แสดงสถานะขอบสีแดงเมื่อเกิดข้อผิดพลาด
class HeightSlider extends StatefulWidget {
  /// ค่าข้อความในช่องพิมพ์ปัจจุบัน (จาก ViewModel)
  final String initialText;

  /// ค่าส่วนสูงตัวเลขปัจจุบัน (สำหรับควบคุมสไลเดอร์)
  final double currentHeight;

  /// ข้อความระบุข้อผิดพลาด (null หากข้อมูลปกติ)
  final String? errorText;

  /// ฟังก์ชัน Callback เมื่อสไลเดอร์มีการเลื่อนค่า
  final ValueChanged<double> onSliderChanged;

  /// ฟังก์ชัน Callback เมื่อผู้ใช้พิมพ์ข้อความลงช่องข้อมูล
  final ValueChanged<String> onTextChanged;

  /// ชุดสีของระบบดีไซน์ปัจจุบัน (AppTheme)
  final AppTheme theme;

  /// พจนานุกรมแปลภาษาประจำแอปพลิเคชัน
  final AppLocalizations localizations;

  /// คอนสตรัคเตอร์จัดเตรียมค่าพารามิเตอร์สำหรับการสไลด์และกรอกส่วนสูง
  const HeightSlider({
    super.key,
    required this.initialText,
    required this.currentHeight,
    required this.errorText,
    required this.onSliderChanged,
    required this.onTextChanged,
    required this.theme,
    required this.localizations,
  });

  @override
  State<HeightSlider> createState() => _HeightSliderState();
}

class _HeightSliderState extends State<HeightSlider> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    
    // คอยตรวจจับการเสียโฟกัสเพื่อรีเซ็ตค่ากรณีพิมพ์ข้อมูลค้างไว้
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // หากผู้ใช้พิมพ์ผิดหรือช่องว่าง แล้วคลิกออกนอกช่อง ให้จัดระเบียบให้กลับมาเป็นค่าซิงค์ปัจจุบัน
        if (widget.errorText != null) {
          widget.onTextChanged(widget.currentHeight.round().toString());
        }
      }
    });
  }

  @override
  void didUpdateWidget(HeightSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ซิงค์ข้อความจาก Slider มายังช่องพิมพ์ เฉพาะตอนที่ผู้ใช้ไม่ได้โฟกัสพิมพ์อยู่ หรือข้อความภายนอกเปลี่ยน
    if (widget.initialText != oldWidget.initialText &&
        widget.initialText != _controller.text) {
      _controller.text = widget.initialText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null;
    final double textWidth = widget.localizations.locale == 'th' ? 76.0 : 80.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ส่วนหัว: หัวข้อ และ ช่องกรอกข้อมูล + หน่วยวัด
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.localizations.translate('height'),
              style: AppTheme.getTextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: widget.theme.textPrimary,
                lang: widget.localizations.locale,
              ),
            ),
            Row(
              children: [
                // ช่องพิมพ์ข้อมูล (Numeric Text Field)
                SizedBox(
                  width: textWidth,
                  height: 38.0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // รับเฉพาะตัวเลขจำนวนเต็มบวกเท่านั้น
                    ],
                    onChanged: widget.onTextChanged,
                    style: AppTheme.getTextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: hasError ? widget.theme.colorObese : widget.theme.accentColor,
                      lang: widget.localizations.locale,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      filled: true,
                      fillColor: widget.theme.cardBg,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: hasError ? widget.theme.colorObese : widget.theme.cardBorder,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: hasError ? widget.theme.colorObese : widget.theme.accentColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // ป้ายหน่วยวัด cm ป้องกันการหดตัวด้วยการใช้ SizedBox / flex-shrink
                SizedBox(
                  width: 25.0,
                  child: Text(
                    'cm',
                    style: AppTheme.getTextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: widget.theme.textSecondary,
                      lang: widget.localizations.locale,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        
        // ตัวเลื่อนสไลเดอร์ ปรับปรุงดีไซน์ให้ตรงตาม Mockup
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.0,
            activeTrackColor: widget.theme.accentColor,
            inactiveTrackColor: widget.theme.sliderTrack,
            thumbColor: Colors.white,
            overlayColor: widget.theme.accentColor.withOpacity(0.12),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 10.0,
              elevation: 4.0,
              pressedElevation: 6.0,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            // ปรับแต่งสีขอบรอบ Thumb
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            min: 100.0,
            max: 250.0,
            divisions: 150, // ละเอียดทีละ 1 เซนติเมตร
            value: widget.currentHeight,
            onChanged: (val) {
              // เอาโฟกัสออกจากช่องพิมพ์หากผู้ใช้คลิกเลื่อนสไลเดอร์
              if (_focusNode.hasFocus) {
                _focusNode.unfocus();
              }
              widget.onSliderChanged(val);
            },
          ),
        ),
        
        // ข้อความแสดงข้อผิดพลาด (ถ้ามี)
        if (hasError) ...[
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              widget.localizations.translate(widget.errorText!),
              style: AppTheme.getTextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: widget.theme.colorObese,
                lang: widget.localizations.locale,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
