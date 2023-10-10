import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../colors.dart' as color;
import 'package:flutter/services.dart' show rootBundle;
import 'get_started.dart';
import '../connection_class.dart';

class ProfilePictureWidget extends StatefulWidget {
  final String emlFwd, passFwd, nameFwd, gdrFwd, ageFwd, wghFwd, hgtFwd;
  const ProfilePictureWidget(
      {Key? key,
      required this.emlFwd,
      required this.passFwd,
      required this.nameFwd,
      required this.gdrFwd,
      required this.wghFwd,
      required this.hgtFwd, required this.ageFwd})
      : super(key: key);

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget>
    with TickerProviderStateMixin {
  //late ProfilePictureModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  XFile? _pickedImage;
  String? base64Image;
  int selectedImageIndex = -1;
  double containerWidth = 60;
  double containerHeight = 60;

  @override
  void initState() {
    super.initState();
    //_model = createModel(context, () => ProfilePictureModel());
  }

  Future<void> selectImage(String pathImg, int index) async {
    final imageBytes = await rootBundle.load(pathImg);
    final bytes = imageBytes.buffer.asUint8List();
    final base64 = base64Encode(bytes);
    setState(() {
      selectedImageIndex = index;
      base64Image = base64;
    });
  }

  Future<void> _openGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        //_pickedImage = XFile(pickedImage.path);
        _pickedImage = pickedImage;
        final File imageFile = File(pickedImage.path);
        base64Image = base64Encode(imageFile.readAsBytesSync());
      });
    }
  }

  Future<void> _regAll(BuildContext cont) async {
    //String baseUrl = 'http://10.131.76.142:8080/FYP/';
    String baseUrl = ConnectionClass.ipUrl;
    String functionName = 'regAll';
    String url = '${baseUrl}Register.php?function=$functionName';
    String pwd = widget.passFwd;
    String eml = widget.emlFwd;
    String nm = widget.nameFwd;
    String age = widget.ageFwd;
    String gdr = widget.gdrFwd;
    String wgt = widget.wghFwd;
    String hgt = widget.hgtFwd;
    String? bs64 = base64Image;
    //final BuildContext context = cont;

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': eml,
        'password': pwd,
        'name': nm,
        'gender': gdr,
        'age' : age,
        'weight': wgt,
        'height': hgt,
        'profPic': bs64,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      Navigator.push(
        cont,
        MaterialPageRoute(
          builder: (context) => GetStartedWidget(emlFwd: eml, passFwd: pwd),
        ),
      );
      Fluttertoast.showToast(
        msg: "Registration Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    } else {
      // Registration failed
      Fluttertoast.showToast(
        msg: "Registration failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _regUpdate(BuildContext cont) async {
    //String baseUrl = 'http://10.131.76.142:8080/FYP/';
    String baseUrl = ConnectionClass.ipUrl;
    String functionName = 'regUpdate';
    String url = '${baseUrl}Register.php?function=$functionName';
    String pwd = widget.passFwd;
    String eml = widget.emlFwd;
    String nm = widget.nameFwd;
    String gdr = widget.gdrFwd;
    String age = widget.ageFwd;
    String wgt = widget.wghFwd;
    String hgt = widget.hgtFwd;
    String? bs64 = base64Image;
    //final BuildContext context = cont;

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': eml,
        'password': pwd,
        'name': nm,
        'gender': gdr,
        'age' : age,
        'weight': wgt,
        'height': hgt,
        'profPic': bs64,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      Navigator.push(
        cont,
        MaterialPageRoute(
          builder: (context) => GetStartedWidget(emlFwd: eml, passFwd: pwd),
        ),
      );
      Fluttertoast.showToast(
        msg: "Registration Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    } else {
      // Registration failed
      Fluttertoast.showToast(
        msg: "Registration failed!",
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
          top: true,
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
                      percent: 0.77,
                      width: 120,
                      lineHeight: 8,
                      animation: true,
                      progressColor: color.AppColor.textBlack,
                      backgroundColor: const Color(0xFFE9E9E9),
                      barRadius: const Radius.circular(12),
                      padding: EdgeInsets.zero,
                    ),
                    TextButton(
                        onPressed: () {
                          _regUpdate(context);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            color: color.AppColor.textGreenHard,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
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
                            text: '6',
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
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(96, 12, 96, 0),
                      child: Text(
                        'Profile Picture',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
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
                    Icon(
                      Icons.arrow_drop_down,
                      color: color.AppColor.gradientTurquoise,
                      size: 24,
                    ),
                    // Generated code for this Row Widget...
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 6),
                      child: _pickedImage != null
                          ? SizedBox(
                              height: 200, // Set the desired height
                              width: 200, // Set the desired width
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.contain,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 12, 0),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectImage('assets/images/Sad.jpg', 0);
                                      print('Image select to base64 $base64Image');
                                    },
                                    child: Container(
                                      width: containerWidth,
                                      height: containerHeight,
                                      decoration: BoxDecoration(
                                        color: selectedImageIndex == 0
                                            ? color.AppColor.gradientTurquoise
                                            : color.AppColor.home2PageBackground,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 4, 4, 4),
                                        child: Image.asset(
                                          'assets/images/Sad.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
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
                                      selectImage('assets/images/Happy.jpg', 1);
                                      print('Image select to base64 $base64Image');
                                    },
                                    child: Container(
                                      width: containerWidth,
                                      height: containerHeight,
                                      decoration: BoxDecoration(
                                        color: selectedImageIndex == 1
                                            ? color.AppColor.gradientTurquoise
                                            : color.AppColor.home2PageBackground,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 4, 4, 4),
                                        child: Image.asset(
                                          'assets/images/Happy.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
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
                                      selectImage('assets/images/Laughing.jpg', 2);
                                      print('Image select to base64 $base64Image');
                                    },
                                    child: Container(
                                      width: containerWidth,
                                      height: containerHeight,
                                      decoration: BoxDecoration(
                                        color: selectedImageIndex == 2
                                            ? color.AppColor.gradientTurquoise
                                            : color.AppColor.home2PageBackground,
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 4, 4, 4),
                                        child: Image.asset(
                                          'assets/images/Laughing.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Icon(
                      Icons.arrow_drop_up,
                      color: color.AppColor.gradientTurquoise,
                      size: 24,
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(84, 0, 84, 0),
                        child: Text(
                          'You can double click photo from one of this emoji or add your own photo as profile picture',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            color: color.AppColor.textGreenHard,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                        child: TextButton(
                          onPressed: _openGallery,
                          child: Text(
                            'Add Custom Photo',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              color: color.AppColor.textGreenHard,
                              fontWeight: FontWeight.w500,
                            ),
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
                  onPressed: () async {
                    _regAll(context);
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
