import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart' as color;
import 'register/EmailSignUp.dart';
import 'login/login_new.dart';

class WelcomePageWidget extends StatefulWidget {
  const WelcomePageWidget({Key? key}) : super(key: key);

  @override
  State<WelcomePageWidget> createState() => _WelcomePageWidgetState();
}

class _WelcomePageWidgetState extends State<WelcomePageWidget> {
  //late WelcomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //_model = createModel(context, () => WelcomePageModel());
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        // Exit the app when the back button is pressed
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: color.AppColor.homePageBackground,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 120, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                        child: Image.asset(
                          'assets/images/SMASH_SPORT_LOGO.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontFamily: 'Rubik', color: color.AppColor.textBlack,
                          fontSize: 24,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                child: Text(
                                  'Smash Sport',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.gradientTurquoise,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                child: Text(
                                  'Your booking court and fitness application',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                      child: Image.asset(
                        'assets/images/45330464.jpg',
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 72, 60),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      //'EmailSignInWidget',
                      //arguments:
                      PageRouteBuilder(
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const EmailSignUpWidget();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: color.AppColor.gradientTurquoise,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Container(
                    width: 150,
                    height: 55,
                    alignment: Alignment.center,
                    child: Text(
                      'Get Started',
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                      child: Text(
                        'Have Account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 50),
                      child: TextButton(
                        onPressed: () async{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginWidget(),
                            ),
                          );
                          },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            color: color.AppColor.textGreenHard,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}