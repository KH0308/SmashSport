import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../colors.dart' as color;
import '../home_page_new.dart';
import '../register/EmailSignUp.dart';
import '../connection_class.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  //late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCTRL = TextEditingController();
  final TextEditingController _passCTRL = TextEditingController();
  bool _passwordVisible = false;

  String msgToast = '';

  Future _login(BuildContext cont) async {
    if (_emailCTRL.text == "" || _passCTRL.text == "") {
      Fluttertoast.showToast(
        msg: "Both fields cannot be blank!",
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
        "username": _emailCTRL.text,
        "password": _passCTRL.text,
      });

      var userData = json.decode(response.body);
      if (userData == "Success") {
        String email = _emailCTRL.text;
        Navigator.push(
            cont, MaterialPageRoute(builder: (context) => HomePageWidget(userID: email)));
      } else {
        Fluttertoast.showToast(
          msg: "userID and password doesn't exist!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    }
  }

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fill cannot be blank!';
    }
    // Add additional validation logic if needed
    return value; // Return null if the value is valid
  }

  bool isEmailValid(String email) {
    // Define the regex pattern for email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

    // Check if the email matches the pattern
    return emailRegex.hasMatch(email);
  }

  /*void state(BuildContext cont){
    passwordVisibility = false;
  }*/

  @override
  void dispose() {
    _emailCTRL.dispose();
    _passCTRL.dispose();
    super.dispose();
  }

  /*@override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.emailAddressController ??= TextEditingController();
    _model.passwordController ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    //context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: color.AppColor.homePageBackground,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Image.asset(
                            'assets/images/SMASH SPORT logo long.jpg',
                            width: 171,
                            height: 60,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                //padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: SvgPicture.asset(
                  'assets/images/undraw_among_nature_p1xb_1.svg',
                  width: 300,
                  height: 270,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: color.AppColor.gradientTurquoise,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 3,
                      color: Color(0x24000000),
                      offset: Offset(0, -1),
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20, 16, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              'Welcome Back,',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'Rubik',
                                  color: color.AppColor.textGreenHard,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.phone_enabled,
                              color: color.AppColor.iconBlack,
                              size: 24,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20, 16, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailCTRL,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: color.AppColor.textGreenHard,
                                    fontWeight: FontWeight.w600),
                                hintText: 'Enter your email here...',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: color.AppColor.textGreenHard,
                                    fontWeight: FontWeight.w600),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: color.AppColor.iconBlack,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0x00000000),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0x00000000),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0x00000000),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                color.AppColor.homePageBackground,
                                contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    16, 24, 0, 24),
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: color.AppColor.textGreenHard,
                                  fontWeight: FontWeight.w600),
                              minLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateTextField,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20, 16, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _passCTRL,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: color.AppColor.textGreenHard,
                                    fontWeight: FontWeight.w600),
                                hintText: 'Enter your password here...',
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: color.AppColor.textGreenHard,
                                    fontWeight: FontWeight.w600),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: color.AppColor.iconBlack,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0x00000000),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0x00000000),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0x00000000),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                color.AppColor.homePageBackground,
                                contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    16, 24, 0, 24),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                  focusNode:
                                  FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: color.AppColor.iconBlack,
                                    size: 22,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: color.AppColor.textGreenHard,
                                  fontWeight: FontWeight.w600),
                              minLines: 1,
                              validator: _validateTextField,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20, 12, 20, 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              print('ButtonForgotPassword pressed ...');
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                color.AppColor.gray10PercentBg,
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.zero,
                              ),
                              elevation: MaterialStateProperty.all(0),
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width: 170,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 18,
                                      color: color.AppColor.textGreenHard,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              String email = _emailCTRL.text;
                              bool isValid = isEmailValid(email);
                              if(isValid){
                                _login(context);
                              }
                              else{
                                Fluttertoast.showToast(
                                  msg: "Please enter valid format email",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 16.0,
                                );
                              }
                              /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()
                                        )
                                    );*/
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                color.AppColor.gray10PercentBg,
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.zero,
                              ),
                              elevation: MaterialStateProperty.all(0),
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width: 130,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    color: color.AppColor.textGreenHard,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                      color: color.AppColor.iconBlack,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0, 8, 0, 44),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const EmailSignUpWidget()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            color.AppColor.gray10PercentBg,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.zero,
                          ),
                          elevation: MaterialStateProperty.all(0),
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          width: 170,
                          height: 40,
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: color.AppColor.textGreenHard,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
