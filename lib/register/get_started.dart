import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home_page_new.dart';
import '../colors.dart' as color;
import '../WidgetAnimation.dart' as animations;
import 'package:http/http.dart' as http;
import '../connection_class.dart';

class GetStartedWidget extends StatefulWidget {
  final String emlFwd, passFwd;
  const GetStartedWidget({Key? key, required this.emlFwd, required this.passFwd}) : super(key: key);

  @override
  State<GetStartedWidget> createState() => _GetStartedWidgetState();
}

class _GetStartedWidgetState extends State<GetStartedWidget>
    with TickerProviderStateMixin {
  //late GetStartedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //_model = createModel(context, () => GetStartedModel());
  }

  Future _login(BuildContext cont) async {
    String email = widget.emlFwd.toString();
    String password = widget.passFwd.toString();

    if (email == "" || password == "") {
      Fluttertoast.showToast(
        msg: "Both fields is empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
    else {
      var baseUrl = ConnectionClass.ipUrl;
      var url = Uri.parse("${baseUrl}Login.php");
      //var url = Uri.parse("http://10.131.76.142:8080/FYP/Login.php");
      var response = await http.post(url, body: {
        "username": email,
        "password": password,
      });

      var userData = json.decode(response.body);
      if (userData == "Success") {
        Navigator.push(
            cont, MaterialPageRoute(builder: (context) => HomePageWidget(userID:email)));
      }
      else {
        Fluttertoast.showToast(
          msg: "userID and password doesn't exist!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
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
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(
                        'assets/images/jogging.svg',
                        height: 228,
                        fit: BoxFit.cover,
                      ).animateOnPageLoad(
                          animations.animationsMap['imageOnPageLoadAnimation']!, tickerProvider: this),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 48),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(96, 12, 96, 0),
                      child: Text(
                        'You are ready to go!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color.AppColor.textGreenHard,
                          fontFamily: 'Rubik',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(60, 12, 60, 0),
                      child: Text(
                        'Thanks for taking your time to create account with us. Now this is the fun part, let’s explore the app.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color.AppColor.textGreenHard,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 72, 60),
                child: ElevatedButton(
                  onPressed: () async {
                    _login(context);
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
                      'Get Started',
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