import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../colors.dart' as color;
import '../WidgetAnimation.dart' as animations;
import 'weight.dart';
import 'package:http/http.dart' as http;
import '../connection_class.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String emlFwd, nameFwd, passFwd;
  const GenderSelectionWidget(
      {Key? key, required this.emlFwd, required this.passFwd, required this.nameFwd})
      : super(key: key);

  @override
  State<GenderSelectionWidget> createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget>
    with TickerProviderStateMixin {
  //late GenderSelectionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String selectedGender = '';
  bool isSelected = false;
  int selectedAge = 11;

  @override
  void initState() {
    super.initState();
    //_model = createModel(context, () => GenderSelectionModel());
  }

  Future _goNext(BuildContext cont) async {
    String pwd = widget.passFwd;
    String eml = widget.emlFwd;
    String nm = widget.nameFwd;
    if (selectedGender == "" && selectedAge == 11) {
      Fluttertoast.showToast(msg: "Please select your gender and age first!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
    else if (selectedGender == "") {
      Fluttertoast.showToast(msg: "Please select your gender first!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
    else if (selectedAge == 11) {
      Fluttertoast.showToast(msg: "Minimum age must be above 11!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
    else{
      Navigator.push(
        cont,
        MaterialPageRoute(
          builder: (context) => WeightEntryWidget(
              emlFwd: eml, passFwd: pwd, nameFwd: nm, gdrFwd: selectedGender, ageFwd: selectedAge.toStringAsFixed(2)),
        ),
      );
    }
  }

  Future<void> _regUpWthDtl(BuildContext cont) async {
    //String baseUrl = 'http://192.168.0.9:8080/FYP/';
    String baseUrl = ConnectionClass.ipUrl;
    String functionName = 'regBasic';
    String url = '${baseUrl}Register.php?function=$functionName';
    String email = widget.emlFwd;
    String pass = widget.passFwd;
    String name = widget.nameFwd;
    String gdr = "NULL";
    String age = "NULL";
    //final BuildContext context = cont;

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': email,
        'password': pass,
        'name': name,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      Navigator.push(
        cont,
        MaterialPageRoute(
          builder: (context) => WeightEntryWidget(
              emlFwd: email, passFwd: pass, nameFwd: name, gdrFwd: gdr, ageFwd: age),
        ),
      );
    }
    else {
      // Registration failed
      Fluttertoast.showToast(msg: "Registration failed can't skip",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
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
                      percent: 0.50,
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
                        _regUpWthDtl(context);
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
                            text: '3',
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
                        'Which one are you?',
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      alignment: const AlignmentDirectional(0, 0),
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 12, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle "Male" selection
                                    setState(() {
                                      isSelected = !isSelected;
                                      selectedGender = 'Male';
                                    });
                                  },
                                  child: AnimatedContainer(
                                    width: 156,
                                    height: 216,
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.grey : Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 24,
                                          color: Color(0x0D000000),
                                          offset: Offset(0, 0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 16, 16, 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Male',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 12, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle "Male" selection
                                    setState(() {
                                      isSelected = !isSelected;
                                      selectedGender = 'Female';
                                    });
                                  },
                                  child: AnimatedContainer(
                                    width: 156,
                                    height: 216,
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.white : Colors.grey,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 24,
                                          color: Color(0x0D000000),
                                          offset: Offset(0, 0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 16, 16, 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Female',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              color: color.AppColor.textBlack,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 72),
                          child: SvgPicture.asset(
                            'assets/images/love.svg',
                            height: 220,
                            fit: BoxFit.cover,
                          ).animateOnPageLoad(
                              animations
                                  .animationsMap['imageOnPageLoadAnimation']!,
                              tickerProvider: this),
                        ),
                      ],
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
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(84, 0, 84, 0),
                        child: Text(
                          'To give you a customized experience, we need to know your age',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.normal,
                            color: color.AppColor.textBlack,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24), // Add spacing between the text and the slider
                      Slider(
                        value: selectedAge.toDouble(),
                        min: 11,
                        max: 90,
                        divisions: 79,
                        onChanged: (double value) {
                          setState(() {
                            selectedAge = value.round();
                          });
                        },
                      ),
                      Text(
                        'Selected Age: $selectedAge',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.normal,
                          color: color.AppColor.textBlack,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                        child: Text(
                          '*Noted minimum age is 12 and above',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontStyle: FontStyle.italic,
                            color: color.AppColor.gradientRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 72, 30),
                child: ElevatedButton(
                  onPressed: () {
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
