import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../colors.dart' as color;
import '../WidgetAnimation.dart' as animations;
import 'height.dart';

class WeightEntryWidget extends StatefulWidget {
  final String emlFwd, passFwd, nameFwd, gdrFwd, ageFwd;
  const WeightEntryWidget(
      {Key? key,
      required this.emlFwd,
      required this.passFwd,
      required this.nameFwd,
      required this.gdrFwd, required this.ageFwd})
      : super(key: key);

  @override
  State<WeightEntryWidget> createState() => _WeightEntryWidgetState();
}

class _WeightEntryWidgetState extends State<WeightEntryWidget>
    with TickerProviderStateMixin {
  //late WeightEntryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String fmtWeight = '';
  double sldWeight = 150.00;
  bool isSelected = false;
  double defVal = 150.00;
  //double sldWghLbs = 0.00;

  @override
  void initState() {
    super.initState();
    //_model = createModel(context, () => WeightEntryModel());
  }

  Future _goNext(BuildContext cont) async {
    String pwd = widget.passFwd;
    String nm = widget.nameFwd;
    String eml = widget.emlFwd;
    String gdr = widget.gdrFwd;
    String age = widget.ageFwd;
    if (sldWeight == 0.00 || sldWeight == defVal) {
      Fluttertoast.showToast(msg: "Please select your weight first!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
    else{
      Navigator.push(
        cont,
        MaterialPageRoute(
          builder: (context) => HeightEntryWidget(
              emlFwd: eml, passFwd: pwd, nameFwd: nm, gdrFwd: gdr, ageFwd: age, wghFwd: sldWeight.toStringAsFixed(2)),
        ),
      );
    }
  }

  Future _goSkip(BuildContext cont) async {
    String pwd = widget.passFwd;
    String eml = widget.emlFwd;
    String nm = widget.nameFwd;
    String gdr = widget.gdrFwd;
    String age = widget.ageFwd;
    String skipWgt = 'NULL';

      Navigator.push(
        cont,
        MaterialPageRoute(
          builder: (context) => HeightEntryWidget(
              emlFwd: eml, passFwd: pwd, gdrFwd: gdr, ageFwd: age, nameFwd: nm, wghFwd: skipWgt),
        ),
      );
  }

  @override
  void dispose() {
    //selectedGender.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: color.AppColor.homePageBackground,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: color.AppColor.iconBlack,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    LinearPercentIndicator(
                      percent: 0.67,
                      width: 120,
                      lineHeight: 5,
                      animation: true,
                      progressColor: color.AppColor.textBlack,
                      backgroundColor: const Color(0xFFE9E9E9),
                      barRadius: const Radius.circular(12),
                      padding: EdgeInsets.zero,
                    ),
                    TextButton(
                      onPressed: () {
                        _goSkip(context);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'STEP ',
                            style: GoogleFonts.getFont(
                              'Rubik',
                              color: color.AppColor.textGreenHard,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: '4',
                            style: TextStyle(),
                          ),
                          const TextSpan(
                            text: '/',
                            style: TextStyle(),
                          ),
                          const TextSpan(
                            text: '6',
                            style: TextStyle(),
                          )
                        ],
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(84, 12, 84, 0),
                      child: Text(
                        'What is your weight?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/working_out.svg',
                        height: 144,
                        fit: BoxFit.cover,
                      ).animateOnPageLoad(
                          animations.animationsMap['imageOnPageLoadAnimation']!,
                          tickerProvider: this),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 12, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isSelected = !isSelected;
                                    fmtWeight = 'lbs';
                                  });
                                  //print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color.AppColor.iconWhite,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: AnimatedContainer(
                                  width: 96,
                                  height: 48,
                                  alignment: Alignment.center,
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.grey : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'lbs',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: color.AppColor.textGreenHard,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 0, 0, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isSelected = !isSelected;
                                    fmtWeight = 'kg';
                                  });
                                  //print('Button pressed ...');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color.AppColor.iconWhite,
                                  padding: EdgeInsets.zero,
                                  elevation: 2,
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: AnimatedContainer(
                                  width: 96,
                                  height: 48,
                                  alignment: Alignment.center,
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.white : Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'kg',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: color.AppColor.textGreenHard,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    sldWeight.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: color.AppColor.textGreenHard,
                                      fontSize: 36,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 6),
                                    child: Text(
                                      fmtWeight,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        color: color.AppColor.textGreenHard,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 2,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.gradientTurquoise,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 3, 0),
                                  child: Container(
                                    width: 1,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: color.AppColor.iconBlack,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textGreenHard,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors
                                        .white, // Customize the active track color
                                    inactiveTrackColor: Colors
                                        .white, // Customize the inactive track color
                                    thumbColor: Colors
                                        .blue, // Customize the thumb color
                                    overlayColor: Colors.blue.withOpacity(
                                        0.4), // Customize the overlay color
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius:
                                            12.0), // Customize the thumb shape
                                    overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius:
                                            24.0), // Customize the overlay shape
                                  ),
                                  child: Slider(
                                    value: sldWeight,
                                    min: 0,
                                    max: 300,
                                    onChanged: (newValue) {
                                      setState(() {
                                        if(fmtWeight == 'kg'){
                                          sldWeight = newValue;
                                        }
                                        else if(fmtWeight == 'lbs'){
                                          //sldWghLbs = sldWeight * 2.20;
                                          sldWeight = newValue;
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                            msg: "Please select your format weight first",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            fontSize: 16.0,
                                          );
                                        }
                                      });
                                    },
                                    onChangeEnd: (finalValue) {
                                      // Handle the final selected value
                                      sldWeight = finalValue;
                                    },
                                  ),
                                ),
                                Text(
                                  '300',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textGreenHard,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 72, 60),
                child: ElevatedButton(
                  onPressed: () async {
                    _goNext(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.AppColor.gradientTurquoise,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Container(
                    width: 150,
                    height: 55,
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        color: color.AppColor.textBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
