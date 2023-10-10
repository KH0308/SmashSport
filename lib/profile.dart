import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'colors.dart' as color;
import 'package:http/http.dart' as http;
import 'home_page_new.dart';
import '../connection_class.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ProfilePageWidget extends StatefulWidget {
  final String userID;
  const ProfilePageWidget({Key? key, required this.userID}) : super(key: key);

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget>
    with TickerProviderStateMixin {
  //late ProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  DateTime lastUpdate = DateTime.now();
  String formattedTimeDifference = '';
  String name = '';
  String profPic = '';
  String gender = '';
  double totalAllCal = 0.0;
  double totalBMRCal = 0.0;
  double percent = 0.0;
  double weight = 0.0;
  double height = 0.0;
  int age = 0;
  String usrPwd = '';
  XFile? _pickedImage;
  String _base64Image = '';
  final List<String> randomQuotes = [
    "Take care of your body. It's the only place you have to live. - Jim Rohn",
    "The only bad workout is the one that didn't happen. - Unknown",
    "Success is not given, it's earned. You have to work for it. - Unknown",
    "Don't limit your challenges, challenge your limits. - Unknown",
    "Fitness is not about being better than someone else, it's about being better than you used to be. - Unknown",
    "The only way to do great work is to love what you do. - Steve Jobs",
    "Your body can stand almost anything. It's your mind that you have to convince. - Unknown",
    "The difference between try and triumph is just a little umph! - Marvin Phillips",
    "Strive for progress, not perfection. - Unknown",
    "The only way to get started is to quit talking and start doing. - Walt Disney"
  ];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCalories();
    // Initialize the time difference when the widget is first created
    updateTimeDifference();

    // Initialize a Timer to refresh the time difference every 3 minutes
    Timer.periodic(Duration(minutes: 3), (Timer timer) {
      updateTimeDifference();
    });
    //_model = createModel(context, () => ProfilePageModel());
  }

  void updateTimeDifference() {
    setState(() {
      // Calculate the time difference
      Duration difference = DateTime.now().difference(lastUpdate);

      // Format the time difference as a string
      formattedTimeDifference = _formatTimeDifference(difference);
    });
  }

  String _formatTimeDifference(Duration difference) {
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return DateFormat('MM/dd/yyyy').format(lastUpdate);
    }
  }

  Future<void> fetchData() async {
    String userid = widget.userID;
    var baseUrl = ConnectionClass.ipUrl;
    final response =
        await http.get(Uri.parse('${baseUrl}getData.php?userID=$userid'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          usrPwd = data[0]['userPassword'];
          name = data[0]['name'];
          gender = data[0]['gender'];
          String weightString = data[0]['weight'];
          weight = double.parse(weightString);
          String heightString = data[0]['height'];
          height = double.parse(heightString);
          String ageString = data[0]['age'];
          age = int.parse(ageString);
          profPic = data[0]['profilePhoto'];

          emailController.text = widget.userID;
          passwordController.text = usrPwd;
          nameController.text = name;
          weightController.text = weight.toString();
          heightController.text = height.toString();
          ageController.text = age.toString();
        });
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> fetchCalories() async {
    String id = widget.userID;
    String functionName = 'retrieveCal';
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getFitness.php?function=$functionName&userID=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          totalAllCal = double.parse(data[0]['totalCaloriesBurned']);
          totalBMRCal = data[0]['target_calories'].toDouble();
          percent = (totalAllCal/totalBMRCal)*1.0;
        });
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        //_pickedImage = XFile(pickedImage.path);
        _pickedImage = pickedImage;
        final File imageFile = File(pickedImage.path);
        _base64Image = base64Encode(imageFile.readAsBytesSync());
      });

      // Call the insertNewImage function after the image is selected
      await insertNewImage();

      // Refresh the data after uploading the image
      await fetchData();
    }
  }

  Future<void> insertNewImage() async {
    String baseUrl = ConnectionClass.ipUrl;
    String functionName = 'insertImg';
    String userID = widget.userID;
    String url =
        '${baseUrl}Register.php?function=$functionName&userID=$userID';
    String? imageNew = _base64Image;

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'userID': userID,
        'profPic': imageNew,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Upload Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    } else {
      // Registration failed
      Fluttertoast.showToast(
        msg: "Upload failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
  }

  Future<void> userUpdate(BuildContext cont) async {
    //String baseUrl = 'http://10.131.76.142:8080/FYP/';
    String eml = emailController.text;
    String pwd = passwordController.text;
    String nm = nameController.text;
    String gdr = gender;
    String wgt = weightController.text;
    String hgt = heightController.text;
    String ageUser = ageController.text;
    String baseUrl = ConnectionClass.ipUrl;
    String functionName = 'updateUser';
    String url = '${baseUrl}Register.php?function=$functionName';
    //final BuildContext context = cont;

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'userID': eml,
        'password': pwd,
        'name': nm,
        'gender': gdr,
        'weight': wgt,
        'height': hgt,
        'age': ageUser,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Update Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      ).then((value) {
        // Fetch the updated list after the toast is shown
        fetchData();
        Navigator.of(context).pop();
      });
    } else {
      // Registration failed
      Fluttertoast.showToast(
        msg: "Update failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    //_model.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.watch<FFAppState>();
    Uint8List imageBytes = Uint8List.fromList(base64.decode(profPic));
    Random random = Random();
    int randomIndex = random.nextInt(randomQuotes.length);
    String randomQuote = randomQuotes[randomIndex];

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: color.AppColor.homePageBackground,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 600,
                    decoration: BoxDecoration(
                      color: color.AppColor.home2PageBackground,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.network(
                          'https://w0.peakpx.com/wallpaper/57/913/HD-wallpaper-gym-motivation-design-iphone-nodaysoff-power-push-samsung-saying.jpg',
                        ).image,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 36, 24, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: color.AppColor.gradientTurquoise,
                                  size: 34,
                                ),
                                onPressed: () async {
                                  String email = widget.userID;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePageWidget(userID: email)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.photo_camera_outlined,
                                  color: color.AppColor.gradientTurquoise,
                                  size: 34,
                                ),
                                onPressed: () {
                                  selectImage();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 550, 0, 0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: color.AppColor.homePageBackground,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 48, 24, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: color.AppColor.textBlack,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 6, 0, 0),
                                          child: Text(
                                            gender,
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              color: color
                                                  .AppColor.gradientTurquoise,
                                              fontSize: 16,
                                              letterSpacing: 0.4,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {

                                            return AlertDialog(
                                              title: const Text(
                                                  'Edit your profile'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    keyboardType: TextInputType.emailAddress,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Email',
                                                    ),
                                                    controller: emailController,
                                                    readOnly: true,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.text,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Password',
                                                    ),
                                                    controller: passwordController,
                                                    obscureText: true,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.name,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Name',
                                                    ),
                                                    controller: nameController,
                                                  ),
                                                  FormBuilderRadioGroup(
                                                    name: 'gender',
                                                    decoration: const InputDecoration(
                                                      labelText: 'Gender',
                                                    ),
                                                    initialValue: gender,
                                                    options: const [
                                                      FormBuilderFieldOption(value: 'Male'),
                                                      FormBuilderFieldOption(value: 'Female'),
                                                    ],
                                                    onChanged: (value) {
                                                      gender = value.toString();
                                                      // Update gender value
                                                    },
                                                  ),
                                                  TextField(
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Weight',
                                                    ),
                                                    controller: weightController,
                                                  ),
                                                  TextField(
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Height',
                                                    ),
                                                    controller: heightController,
                                                  ),
                                                  TextField(
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Age',
                                                    ),
                                                    controller: ageController,
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: color
                                                          .AppColor.gradientRed,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Save',
                                                    style: TextStyle(
                                                      color: color.AppColor
                                                          .gradientTurquoise,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    // Perform validation and save the weight and height data
                                                    if (emailController.text.isNotEmpty &&
                                                        passwordController.text.isNotEmpty &&
                                                        nameController.text.isNotEmpty &&
                                                        weightController.text.isNotEmpty &&
                                                        heightController.text.isNotEmpty &&
                                                        ageController.text.isNotEmpty) {
                                                      userUpdate(context);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: "Please fill in all fields!",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        fontSize: 16.0,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(88, 42),
                                        backgroundColor:
                                            color.AppColor.gradientTurquoise,
                                        padding: const EdgeInsets.fromLTRB(
                                            24, 0, 24, 0),
                                        textStyle: TextStyle(
                                          fontFamily: 'Rubik',
                                          color: color.AppColor.iconWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        elevation: 0,
                                        side: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Edit'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 24, 48, 0),
                                child: Text(
                                  randomQuote,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.normal,
                                    color: color.AppColor.textBlack,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 48, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'WEIGHT',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: color
                                                .AppColor.gradientTurquoise,
                                            fontSize: 12,
                                            letterSpacing: 0.6,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 6, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                weight.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  color:
                                                      color.AppColor.textBlack,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(2, 0, 0, 2),
                                                child: Text(
                                                  'kg',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    color:
                                                        color.AppColor.textGray,
                                                    letterSpacing: 0.2,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 48,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        color: Color(0xFFE9E9E9),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'AGE',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: color
                                                .AppColor.gradientTurquoise,
                                            fontSize: 12,
                                            letterSpacing: 0.6,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 6, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                age.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  color:
                                                      color.AppColor.textBlack,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(2, 0, 0, 2),
                                                child: Text(
                                                  'yo',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    color: color.AppColor
                                                        .textGray,
                                                    letterSpacing: 0.2,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 48,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        color: Color(0xFFE9E9E9),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'HEIGHT',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: color
                                                .AppColor.gradientTurquoise,
                                            fontSize: 12,
                                            letterSpacing: 0.6,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 6, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                height.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  color:
                                                      color.AppColor.textBlack,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(2, 0, 0, 2),
                                                child: Text(
                                                  'cm',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    color: color.AppColor
                                                        .textGray,
                                                    letterSpacing: 0.2,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 36, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {},
                                        child: Container(
                                          width: 162,
                                          height: 216,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4C5A81),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(16, 16, 16, 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'CALORIES',
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        color: color
                                                            .AppColor.iconBlack,
                                                        fontSize: 12,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Stack(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  children: [
                                                    CircularPercentIndicator(
                                                      percent: percent,
                                                      radius: 48,
                                                      lineWidth: 12,
                                                      animation: true,
                                                      progressColor: color
                                                          .AppColor.iconBlack,
                                                      backgroundColor:
                                                          const Color(
                                                              0x32FFFFFF),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .directions_run_rounded,
                                                      color: color
                                                          .AppColor.iconBlack,
                                                      size: 36,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '${totalAllCal.toStringAsFixed(
                                                              2)} cal',
                                                          style: TextStyle(
                                                            fontFamily: 'Rubik',
                                                            color: color
                                                                .AppColor
                                                                .textBlack,
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      'Last update $formattedTimeDifference',
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        color: color
                                                            .AppColor.textBlack,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ],
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 540, 0, 0),
                      child: _pickedImage != null
                          ? SizedBox(
                              height: 60, // Set the desired height
                              width: 60, // Set the desired width
                              child: Image.file(
                                File(_pickedImage!.path),
                                fit: BoxFit.contain,
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: color.AppColor.home2PageBackground,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
