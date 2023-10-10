import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../colors.dart' as color;
import '../WidgetAnimation.dart' as animations;
import 'gender.dart';

class EnterPasswordWidget extends StatefulWidget {
  final String emailFwd;
  final String nameFwd;
  const EnterPasswordWidget({Key? key, required this.emailFwd, required this.nameFwd}) : super(key: key);

  @override
  State<EnterPasswordWidget> createState() => _EnterPasswordWidgetState();
}

class _EnterPasswordWidgetState extends State<EnterPasswordWidget>
    with TickerProviderStateMixin {
  //late EnterPasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final TextEditingController _textFieldCtrlPwd = TextEditingController();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //_textFieldCtrlPwd.dispose();
    //_model = createModel(context, () => EnterPasswordModel());

    //textController ??= TextEditingController();
  }

  Future _goNext(BuildContext cont) async {
    if (_textFieldCtrlPwd.text == "") {
      Fluttertoast.showToast(msg: "Email fields cannot be blank!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
    else{
      String pwd = _textFieldCtrlPwd.text;
      String nm = widget.nameFwd;
      String eml = widget.emailFwd;
      Navigator.push(
        cont,
        //'SetName',
        //arguments:
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return GenderSelectionWidget(emlFwd: eml, nameFwd: nm, passFwd: pwd);
          },
        ),
      );
    }
  }

  bool isPasswordValid(String password) {
    // Define the regex patterns for each requirement
    final lengthRegex = RegExp(r'^.{8,}$');
    final symbolRegex = RegExp(r'(?=.*[@#$%^&+=!])');
    final numberRegex = RegExp(r'(?=.*[0-9])');
    final lowercaseRegex = RegExp(r'(?=.*[a-z])');
    final uppercaseRegex = RegExp(r'(?=.*[A-Z])');

    // Check if the password meets all requirements
    return lengthRegex.hasMatch(password) &&
        symbolRegex.hasMatch(password) &&
        numberRegex.hasMatch(password) &&
        lowercaseRegex.hasMatch(password) &&
        uppercaseRegex.hasMatch(password);
  }

  @override
  void dispose() {
    _textFieldCtrlPwd.dispose();
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
                      percent: 0.33,
                      width: 120,
                      lineHeight: 5,
                      animation: true,
                      progressColor: color.AppColor.textBlack,
                      backgroundColor: const Color(0xFFB7B3B3),
                      barRadius: const Radius.circular(12), // Set the radius to half of the line height (8 / 2 = 4)
                      padding: EdgeInsets.zero,
                    ),
                    TextButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: "This part cannot be skipped!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          fontSize: 16.0,
                        );
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
                            text: '2',
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
                      padding: EdgeInsetsDirectional.fromSTEB(96, 12, 96, 0),
                      child: Text(
                        'Set your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(84, 12, 84, 0),
                      child: Text(
                        'Enter a strong password for your account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.normal,
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
                    children: [
                      TickerMode(
                        enabled: true,
                        child: SvgPicture.asset(
                          'assets/images/mobile_encryption.svg',
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ).animateOnPageLoad(
                        animations.animationsMap['imageOnPageLoadAnimation']!, tickerProvider: this,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(48, 48, 48, 0),
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color.AppColor.homePageBackground,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 12,
                                color: Color(0x0D000000),
                                offset: Offset(0, 0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: const AlignmentDirectional(0, 0),
                          child: TextFormField(
                            controller: _textFieldCtrlPwd,
                            obscureText: false,
                            decoration: const InputDecoration(
                              hintText: 'Enter you password',
                              hintStyle: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            ),
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              color: color.AppColor.textGreenHard,
                              fontWeight: FontWeight.normal,
                            ),
                            keyboardType: TextInputType.visiblePassword,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 72, 60),
                child: ElevatedButton(
                  onPressed: () {
                    String password = _textFieldCtrlPwd.text;
                    bool isValid = isPasswordValid(password);
                    if (isValid) {
                      _goNext(context);
                    }
                    else{
                      Fluttertoast.showToast(
                        msg: "Please enter at least 8 character, 1 caps word, "
                            "1 symbol and number",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        fontSize: 16.0,
                      );
                    }
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
                        color: color.AppColor.iconBlack,
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