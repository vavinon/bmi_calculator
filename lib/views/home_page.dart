import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/localization.dart';
import '../viewmodels/calculator_viewmodel.dart';
import 'widgets/gender_selector.dart';
import 'widgets/height_slider.dart';
import 'widgets/result_card.dart';
import 'widgets/segmented_range_bar.dart';

/// หน้าจอหลักของแอปพลิเคชันเครื่องมือคำนวณน้ำหนักที่เหมาะสม
/// รองรับการปรับผังหน้าจอแบบตอบสนอง (Responsive Layout) และผูกโยงข้อมูลผ่าน CalculatorViewModel
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึงสถานะปัจจุบันของแอปพลิเคชันจาก ViewModel
    final viewModel = context.watch<CalculatorViewModel>();
    
    // ตั้งค่าโครงสร้างระบบแปลภาษาและระบบธีมสีตามตัวเลือกปัจจุบัน
    final localizations = AppLocalizations(viewModel.language);
    final theme = viewModel.themeMode == 'light' ? AppTheme.light : AppTheme.dark;

    // คำนวณผลลัพธ์น้ำหนักในอุดมคติและค่าแวดล้อม
    final result = viewModel.result;
    final String currentWeightUnit = localizations.translate(viewModel.weightUnit);

    // ดึงค่าผลลัพธ์การแปลงหน่วยสำหรับหน้าจอแสดงผล
    final double idealWeightDisplay = viewModel.weightUnit == 'lbs'
        ? result.idealBodyWeight * 2.20462
        : result.idealBodyWeight;

    // ตัวแปรช่วงน้ำหนักสำหรับเกณฑ์เอเชีย (แปลงตามหน่วยที่เลือก)
    final double scale = viewModel.weightUnit == 'lbs' ? 2.20462 : 1.0;
    final double asiaUnderLimit = result.asianMinWeight * scale;
    final double asiaNormalLimit = result.asianMaxWeight * scale;
    final double asiaOverLimit = (result.asianMaxWeight + 2.0) * scale; // 24.9 * H^2
    final double asiaObeseLimit = result.asianMaxWeight * scale; // >= 25.0 * H^2 (obese lower limit)
    // สำหรับเอเชีย ขีดจำกัดล่างอ้วนคือ 25.0 * H^2 จากสเปก

    // ตัวแปรช่วงน้ำหนักสำหรับเกณฑ์สากล (WHO) (แปลงตามหน่วยที่เลือก)
    final double whoUnderLimit = result.whoMinWeight * scale;
    final double whoNormalLimit = result.whoMaxWeight * scale;
    final double whoOverLimit = (result.whoMaxWeight + 5.0) * scale; // 29.9 * H^2
    final double whoObeseLimit = result.whoMaxWeight * scale; // >= 30.0 * H^2

    return Scaffold(
      backgroundColor: Colors.transparent, // เพื่อแสดงเฉดสีพื้นหลังแบบไล่สี
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.bgStart, theme.bgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // 1. ตกแต่งพื้นหลังด้วยแสงเรืองรอง (Background Glow Effect) เลียนแบบ mockup
            Positioned(
              top: -150.0,
              left: -150.0,
              child: _buildGlowCircle(theme.accentColor.withOpacity(0.15)),
            ),
            Positioned(
              bottom: -150.0,
              right: -150.0,
              child: _buildGlowCircle(const Color(0xFFA855F7).withOpacity(0.15)),
            ),
            
            // 2. เนื้อหาหน้าจอหลัก
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // ตรวจสอบความกว้างหน้าจอเพื่อเปลี่ยนผังการแสดงผล (Breakpoint: 640px)
                  final bool isWideScreen = constraints.maxWidth >= 640.0;
                  
                  // สร้างแผงหลักการคำนวณด้านใน
                  final Widget content = Container(
                    margin: isWideScreen
                        ? const EdgeInsets.all(32.0)
                        : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    padding: isWideScreen
                        ? const EdgeInsets.all(32.0)
                        : const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: theme.panelBg,
                      border: Border.all(
                        color: theme.panelBorder,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ส่วนหัวข้อแอปและการตั้งค่าสวิตช์
                        _buildHeader(context, viewModel, theme, localizations, isWideScreen),
                        const SizedBox(height: 24.0),
                        
                        // ส่วนจัดวางเนื้อหา
                        if (isWideScreen)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ฝั่งซ้าย (คอนโทรลเลอร์กรอกข้อมูล)
                              Expanded(
                                flex: 4,
                                child: _buildInputPanel(context, viewModel, theme, localizations),
                              ),
                              const SizedBox(width: 32.0),
                              // ฝั่งขวา (รายงานผลลัพธ์)
                              Expanded(
                                flex: 5,
                                child: _buildResultPanel(
                                  context,
                                  viewModel,
                                  theme,
                                  localizations,
                                  idealWeightDisplay,
                                  currentWeightUnit,
                                  result,
                                  asiaUnderLimit,
                                  result.asianMinWeight * scale,
                                  result.asianMaxWeight * scale,
                                  (result.asianMaxWeight + 2.0) * scale,
                                  whoUnderLimit,
                                  result.whoMinWeight * scale,
                                  result.whoMaxWeight * scale,
                                  (result.whoMaxWeight + 5.0) * scale,
                                ),
                              ),
                            ],
                          )
                        else
                          // เวอร์ชันมือถือ จัดแนวตั้งไหลลงไป
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputPanel(context, viewModel, theme, localizations),
                              const SizedBox(height: 24.0),
                              _buildResultPanel(
                                context,
                                viewModel,
                                theme,
                                localizations,
                                idealWeightDisplay,
                                currentWeightUnit,
                                result,
                                asiaUnderLimit,
                                result.asianMinWeight * scale,
                                result.asianMaxWeight * scale,
                                (result.asianMaxWeight + 2.0) * scale,
                                whoUnderLimit,
                                result.whoMinWeight * scale,
                                result.whoMaxWeight * scale,
                                (result.whoMaxWeight + 5.0) * scale,
                              ),
                            ],
                          ),
                      ],
                    ),
                  );

                  return Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 960.0),
                        child: content,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // สร้างแสงเรืองพื้นหลัง
  Widget _buildGlowCircle(Color color) {
    return Container(
      width: 300.0,
      height: 300.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
          stops: const [0.1, 0.8],
        ),
      ),
    );
  }

  // สร้างส่วนหัวเรื่องแอป และกลุ่มปุ่มเลือกตั้งค่า
  Widget _buildHeader(
    BuildContext context,
    CalculatorViewModel viewModel,
    AppTheme theme,
    AppLocalizations localizations,
    bool isWideScreen,
  ) {
    final Widget headerText = Text(
      localizations.translate('app_title'),
      style: AppTheme.getTextStyle(
        fontSize: isWideScreen ? 22.0 : 18.0,
        fontWeight: FontWeight.w800,
        color: theme.textPrimary,
        lang: localizations.locale,
      ).copyWith(
        // ตกแต่งฟอนต์ข้อความหัวเรื่องให้โดดเด่นด้วยโทนสี Gradient ไล่เฉดแบบพรีเมียม
        foreground: Paint()
          ..shader = LinearGradient(
            colors: isWideScreen
                ? [theme.accentColor, const Color(0xFFA855F7)]
                : [theme.accentColor, theme.accentColor],
          ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 50.0)),
      ),
    );

    final Widget controls = Wrap(
      spacing: 12.0,
      runSpacing: 10.0,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // 1. สวิตช์สลับธีม (มืด/สว่าง)
        _buildSwitcherWrapper(
          label: localizations.translate('theme').toUpperCase(),
          theme: theme,
          localizations: localizations,
          child: _buildCustomSwitcher(
            theme: theme,
            options: const [
              SwitcherOption(id: 'dark', child: Icon(Icons.dark_mode_rounded, size: 14.0)),
              SwitcherOption(id: 'light', child: Icon(Icons.light_mode_rounded, size: 14.0)),
            ],
            selectedValue: viewModel.themeMode,
            onSelected: viewModel.setThemeMode,
          ),
        ),
        // 2. สวิตช์สลับหน่วยน้ำหนัก (kg/lbs)
        _buildSwitcherWrapper(
          label: localizations.translate('weight_unit').toUpperCase(),
          theme: theme,
          localizations: localizations,
          child: _buildCustomSwitcher(
            theme: theme,
            options: const [
              SwitcherOption(id: 'kg', label: 'kg'),
              SwitcherOption(id: 'lbs', label: 'lbs'),
            ],
            selectedValue: viewModel.weightUnit,
            onSelected: viewModel.setWeightUnit,
          ),
        ),
        // 3. สวิตช์สลับภาษา (TH/EN)
        _buildSwitcherWrapper(
          label: 'ภาษา / LANG',
          theme: theme,
          localizations: localizations,
          child: _buildCustomSwitcher(
            theme: theme,
            options: const [
              SwitcherOption(id: 'th', label: 'TH'),
              SwitcherOption(id: 'en', label: 'EN'),
            ],
            selectedValue: viewModel.language,
            onSelected: viewModel.setLanguage,
          ),
        ),
      ],
    );

    if (isWideScreen) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.panelBorder,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: headerText),
            controls,
          ],
        ),
      );
    } else {
      // หน้าจอมือถือ จัดวางเป็นคอลัมน์แนวตั้ง
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.panelBorder,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerText,
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: controls,
            ),
          ],
        ),
      );
    }
  }

  // ตัวช่วยสร้างโครงสร้างป้ายกำกับด้านบนหัวปุ่ม Switcher
  Widget _buildSwitcherWrapper({
    required String label,
    required AppTheme theme,
    required AppLocalizations localizations,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTheme.getTextStyle(
            fontSize: 9.0,
            fontWeight: FontWeight.w700,
            color: theme.textSecondary,
            lang: localizations.locale,
          ).copyWith(letterSpacing: 0.8),
        ),
        const SizedBox(height: 4.0),
        child,
      ],
    );
  }

  // ตัวสร้างตัวปุ่ม Switcher แบบแคปซูลแก้ว (Custom Switcher Capsule)
  Widget _buildCustomSwitcher({
    required AppTheme theme,
    required List<SwitcherOption> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.switcherBg,
        border: Border.all(
          color: theme.switcherBorder,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) {
          final bool isSelected = (opt.id == selectedValue);
          return GestureDetector(
            onTap: () => onSelected(opt.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: isSelected ? theme.accentColor : Colors.transparent,
                borderRadius: BorderRadius.circular(9.0),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.accentColor.withOpacity(0.3),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: opt.child ??
                    Text(
                      opt.label ?? '',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : theme.textSecondary,
                      ),
                    ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // สร้างแผงควบคุมฝั่งผู้ใช้งาน (Input Panel)
  Widget _buildInputPanel(
    BuildContext context,
    CalculatorViewModel viewModel,
    AppTheme theme,
    AppLocalizations localizations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('personal_info'),
          style: AppTheme.getTextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            color: theme.textSecondary,
            lang: localizations.locale,
          ).copyWith(letterSpacing: 0.5),
        ),
        const SizedBox(height: 20.0),
        
        // 1. ปุ่มเลือกเพศ
        GenderSelector(
          isMale: viewModel.isMale,
          onChanged: viewModel.setGender,
          theme: theme,
          localizations: localizations,
        ),
        const SizedBox(height: 24.0),
        
        // 2. ตัวเลื่อนส่วนสูงและการกรอก
        HeightSlider(
          initialText: viewModel.heightInputText,
          currentHeight: viewModel.height,
          errorText: viewModel.heightError,
          onSliderChanged: viewModel.updateHeightFromSlider,
          onTextChanged: viewModel.updateHeightFromText,
          theme: theme,
          localizations: localizations,
        ),
      ],
    );
  }

  // สร้างแผงแสดงรายงานผลลัพธ์สุขภาพ (Result Panel)
  Widget _buildResultPanel(
    BuildContext context,
    CalculatorViewModel viewModel,
    AppTheme theme,
    AppLocalizations localizations,
    double idealWeightVal,
    String weightUnitStr,
    dynamic result,
    double asiaUnder,
    double asiaMin,
    double asiaMax,
    double asiaOver,
    double whoUnder,
    double whoMin,
    double whoMax,
    double whoOver,
  ) {
    final double scale = viewModel.weightUnit == 'lbs' ? 2.20462 : 1.0;
    // คำนวณขีดจำกัดสูงสุดรอบเอวในหน่วยนิ้ว
    final double recommendedWaistInches = result.recommendedWaistInches;
    final String lessThanStr = localizations.translate('less_than');
    final String inchesStr = localizations.translate('inches');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate('analysis_results'),
          style: AppTheme.getTextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            color: theme.textSecondary,
            lang: localizations.locale,
          ).copyWith(letterSpacing: 0.5),
        ),
        const SizedBox(height: 20.0),
        
        // 1. แผงการ์ดผลลัพธ์ข้อมูลสุขภาพ
        LayoutBuilder(
          builder: (context, cardConstraints) {
            // ปรับขนาดการจัดวางการ์ดผลลัพธ์: เคียงข้างกันถ้ามีพื้นที่แนวราบเพียงพอ
            final bool isRowCards = cardConstraints.maxWidth >= 460.0;
            final Widget idealCard = ResultCard(
              label: localizations.translate('ideal_weight'),
              valueWidget: RichText(
                text: TextSpan(
                  text: idealWeightVal.toStringAsFixed(1),
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28.0,
                    fontWeight: FontWeight.w800,
                    color: theme.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: ' $weightUnitStr',
                      style: AppTheme.getTextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: theme.textSecondary,
                        lang: localizations.locale,
                      ),
                    )
                  ],
                ),
              ),
              description: result.isEdgeCase
                  ? localizations.translate('formula_edge_desc')
                  : localizations.translate('formula_desc'),
              borderAccentColor: theme.accentColor,
              cardBgColor: theme.accentColor.withOpacity(0.04),
              theme: theme,
              localizations: localizations,
            );

            final Widget waistCard = ResultCard(
              label: localizations.translate('target_waist'),
              valueWidget: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$lessThanStr ${result.recommendedWaistCm.round()}',
                    style: AppTheme.getTextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                      color: theme.textPrimary,
                      lang: localizations.locale,
                    ),
                  ),
                  Text(
                    ' cm',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: theme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '(${recommendedWaistInches.toStringAsFixed(1)} $inchesStr)',
                    style: AppTheme.getTextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      color: theme.textSecondary,
                      lang: localizations.locale,
                    ),
                  ),
                ],
              ),
              description: localizations.translate('waist_circumference_desc'),
              borderAccentColor: theme.colorNormal,
              cardBgColor: theme.colorNormal.withOpacity(0.04),
              theme: theme,
              localizations: localizations,
            );

            if (isRowCards) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: idealCard),
                  const SizedBox(width: 16.0),
                  Expanded(child: waistCard),
                ],
              );
            } else {
              return Column(
                children: [
                  idealCard,
                  const SizedBox(height: 16.0),
                  waistCard,
                ],
              );
            }
          },
        ),
        const SizedBox(height: 24.0),
        
        // 2. แผงแถบเกณฑ์ระดับน้ำหนักร่างกายตามค่า BMI (WHO vs Asian)
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: theme.cardBg,
            border: Border.all(
              color: theme.cardBorder,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // เกณฑ์เอเชีย
              SegmentedRangeBar(
                title: localizations.translate('asian_criteria'),
                w18_5: asiaMin,
                wNormalMax: asiaMax,
                wOverweightMin: (result.asianMaxWeight + 0.1) * scale,
                wOverweightMax: (result.overweightMaxWeight ?? (result.asianMaxWeight + 2.0)) * scale,
                wObeseMin: (result.asianMaxWeight + 2.1) * scale, // >= 25.0
                weightUnitLabel: weightUnitStr,
                theme: theme,
                localizations: localizations,
              ),
              const SizedBox(height: 20.0),
              
              // เกณฑ์สากล (WHO)
              SegmentedRangeBar(
                title: localizations.translate('who_criteria'),
                w18_5: whoMin,
                wNormalMax: whoMax,
                wOverweightMin: (result.whoMaxWeight + 0.1) * scale,
                wOverweightMax: (result.whoMaxWeight + 5.0) * scale, // 29.9
                wObeseMin: (result.whoMaxWeight + 5.1) * scale, // >= 30.0
                weightUnitLabel: weightUnitStr,
                theme: theme,
                localizations: localizations,
              ),
              const SizedBox(height: 20.0),
              
              // เส้นคั่นก่อนแสดงกล่องสีสัญลักษณ์คำอธิบาย
              Divider(
                color: theme.cardBorder,
                height: 1.0,
                thickness: 1.0,
              ),
              const SizedBox(height: 16.0),
              
              // 3. แผงแสดงสัญลักษณ์สีและคำอธิบาย (Legend) ป้องกันปัญหากดบีบตัวด้วย Wrap
              Wrap(
                spacing: 16.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildLegendItem(theme.colorUnderweight, localizations.translate('underweight'), theme, localizations),
                  _buildLegendItem(theme.colorNormal, localizations.translate('normal_weight'), theme, localizations),
                  _buildLegendItem(theme.colorOverweight, localizations.translate('overweight'), theme, localizations),
                  _buildLegendItem(theme.colorObese, localizations.translate('obesity'), theme, localizations),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Center(
          child: Text(
            'Version ${viewModel.appVersion}',
            style: AppTheme.getTextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              color: theme.textSecondary.withOpacity(0.4),
              lang: localizations.locale,
            ),
          ),
        ),
      ],
    );
  }

  // ตัวช่วยสร้างป้ายสัญลักษณ์คำอธิบาย (Legend Item)
  Widget _buildLegendItem(Color dotColor, String label, AppTheme theme, AppLocalizations localizations) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6.0),
        Text(
          label,
          style: AppTheme.getTextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.w500,
            color: theme.textSecondary,
            lang: localizations.locale,
          ),
        ),
      ],
    );
  }
}

/// คลาสจับคู่สำหรับการสร้างกลุ่มตัวเลือกปุ่มสวิตช์
class SwitcherOption {
  final String id;
  final String? label;
  final Widget? child;

  const SwitcherOption({
    required this.id,
    this.label,
    this.child,
  });
}
