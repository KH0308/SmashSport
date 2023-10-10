import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:SmashSport/colors.dart' as color;
import '../home_page_new.dart';
import 'map_court.dart';
import 'checkout_booking.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import '../connection_class.dart';

class MainPageBookWidget extends StatefulWidget {
  final String userID;
  const MainPageBookWidget({Key? key, required this.userID}) : super(key: key);

  @override
  State<MainPageBookWidget> createState() => _MainPageBookWidgetState();
}

class _MainPageBookWidgetState extends State<MainPageBookWidget> {
  //late MainPageBookModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  // bool button based on number court
  bool isButton1Pressed = false;
  bool isButton2Pressed = false;
  bool isButton3Pressed = false;
  bool isButton4Pressed = false;
  bool isButton5Pressed = false;
  bool isButton6Pressed = false;
  bool isButton7Pressed = false;
  bool isButton8Pressed = false;
  bool isButton9Pressed = false;
  bool isButton10Pressed = false;
  // String that store selected court
  List<String> selectedCourts = [];
  List<String> courtStatuses = [];
  late int numberOfSelectedCourts;
  String courtSelected = '';
  // State field(s) for Calendar widget.
  DateTime today = DateTime.now();
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;

  void _onDateSelect(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      print("Selected day: ${today.toString().split(" ")[0]}");
    });
  }

  List<String> dropdownItemsStart = [
    '1100',
    '1200',
    '1300',
    '1400',
    '1500',
    '1600',
    '1700',
    '1800',
    '1900',
    '2000',
    '2100',
    '2200',
    '2300',
  ];

  List<String> dropdownItemsEnd = [
    '1200',
    '1300',
    '1400',
    '1500',
    '1600',
    '1700',
    '1800',
    '1900',
    '2000',
    '2100',
    '2200',
    '2300',
    '0000',
  ];

  // Fetch court statuses from the database
  Future<List<String>> fetchCourtStatuses() async {
    var baseUrl = ConnectionClass.ipUrl;
    final response = await http.get(Uri.parse('${baseUrl}getCourtStatus.php'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data is List<dynamic> && data.every((item) => item is String)) {
        // Data is a list of strings, so map it to courtStatuses
        final List<String> courtStatuses = List<String>.from(data);
        return courtStatuses;
      }
    }

    throw Exception('Failed to fetch court statuses');
  }

  Future<bool> checkCourtAvailability(
      String selectedDate, String startTime, String endTime, String selectedCourts) async {
    var baseUrl = ConnectionClass.ipUrl;
    final response = await http.get(
      Uri.parse('$baseUrl/checkCourtAvailability.php?selectedDate=$selectedDate&startTime=$startTime&endTime=$endTime&selectedCourts=$selectedCourts'),
    );

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        if (data != null && data['clash'] == true) {
          return false;
        } else {
          return true;
        }
      } catch (e) {
        print("Error parsing JSON: $e");
        return false;
      }
    } else {
      print("HTTP Error: ${response.statusCode}");
      return false;
    }
  }

  void initState() {
    super.initState();
    fetchCourtStatuses().then((statuses) {
      setState(() {
        courtStatuses = statuses;
      });
      // Print the fetched statuses
      print('Court Statuses in initState: $courtStatuses');
    });
    //_model = createModel(context, () => MainPageBookModel());
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: color.AppColor.homePageBackground,
        appBar: AppBar(
          backgroundColor: color.AppColor.gradientTurquoise,
          iconTheme: IconThemeData(color: color.AppColor.iconBlack),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: color.AppColor.iconBlack,
              size: 24,
            ),
            onPressed: () async {
              String email = widget.userID;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePageWidget(userID: email)),
              );
            },
          ),
          title: Text(
            'Court Booking',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w600,
              color: color.AppColor.textBlack,
              fontSize: 20,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                // Handle the selected option
                print('Selected: $value');
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Info',
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Info'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'Help & Feedback',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Help & Feedback'),
                  ),
                ),
              ],
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.more_vert_rounded,
                  size: 30,
                ),
              ),
            )
          ],
          centerTitle: true,
          elevation: 4,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  focusedDay: today,
                  firstDay: DateTime.utc(today.year - 1),
                  lastDay: DateTime.utc(today.year + 1),
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  calendarStyle: CalendarStyle(
                    // Customize the selected day decoration
                    selectedDecoration: BoxDecoration(
                      color: color.AppColor.gradientTurquoise,
                      shape: BoxShape.circle,
                    ),
                    // Customize the today's day decoration
                    todayDecoration: BoxDecoration(
                      color: color.AppColor.gradient10Turquoise,
                      shape: BoxShape.circle,
                    ),
                    // Customize the weekend text style
                    weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: color.AppColor.textBlack,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    // Hide the outside days
                    outsideDaysVisible: true,
                    // Customize the outside days text style
                    outsideTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: color.AppColor.textGray,
                      fontSize: 12,
                    ),
                    // Customize the selected day text style
                    selectedTextStyle: TextStyle(
                      color: color.AppColor
                          .iconWhite, // Change to the desired text color for selected day
                    ),
                    // Customize the today's day text style
                    todayTextStyle: TextStyle(
                      color: color.AppColor
                          .iconWhite, // Change to the desired text color for today's date
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    // Customize the weekday text style
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: color.AppColor.textBlack,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  rowHeight: 64,
                  onDaySelected: _onDateSelect,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 10, 0, 0),
                      child: Text(
                        'Time:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: color.AppColor.textBlack,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 12, 6, 0),
                          child: Container(
                            width: 150,
                            height: 50,
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                24, 4, 12, 4),
                            decoration: BoxDecoration(
                              color: color.AppColor.home2PageBackground,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: color.AppColor.gradientTurquoise,
                                width: 2,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                value: dropDownValue1,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownValue1 = newValue;
                                  });
                                },
                                items: dropdownItemsStart
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          color: color.AppColor.textBlack,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  color: color.AppColor.textBlack,
                                ),
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'Start',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: color.AppColor.textBlack
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: color.AppColor.iconBlack,
                                  size: 15,
                                ),
                                dropdownColor:
                                    color.AppColor.home2PageBackground,
                                elevation: 2,
                                underline: Container(
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                                isDense: true,
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(6, 12, 0, 0),
                          child: Container(
                            width: 150,
                            height: 50,
                            margin: const EdgeInsetsDirectional.fromSTEB(
                                24, 4, 12, 4),
                            decoration: BoxDecoration(
                              color: color.AppColor.home2PageBackground,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: color.AppColor.gradientTurquoise,
                                width: 2,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                value: dropDownValue2,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropDownValue2 = newValue;
                                  });
                                },
                                items: dropdownItemsEnd
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          color: color.AppColor.textBlack,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  color: color.AppColor.textBlack,
                                ),
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    'End',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: color.AppColor.textBlack
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: color.AppColor.iconBlack,
                                  size: 15,
                                ),
                                dropdownColor:
                                    color.AppColor.home2PageBackground,
                                elevation: 2,
                                underline: Container(
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                                isDense: true,
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 10, 0, 0),
                      child: Text(
                        'Court:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: color.AppColor.homePageBackground,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[0] != 'Closed') {
                                  setState(() {
                                    isButton1Pressed = !isButton1Pressed;
                                    if (isButton1Pressed) {
                                      selectedCourts.add('1');
                                    } else {
                                      selectedCourts.remove('1');
                                    }
                                  });
                                  print('Button 1 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton1Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[1] != 'Closed') {
                                  setState(() {
                                    isButton2Pressed = !isButton2Pressed;
                                    if (isButton2Pressed) {
                                      selectedCourts.add('2');
                                    } else {
                                      selectedCourts.remove('2');
                                    }
                                  });
                                  print('Button 2 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton2Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[2] != 'Closed') {
                                  setState(() {
                                    isButton3Pressed = !isButton3Pressed;
                                    if (isButton3Pressed) {
                                      selectedCourts.add('3');
                                    } else {
                                      selectedCourts.remove('3');
                                    }
                                  });
                                  print('Button 3 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton3Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[3] != 'Closed') {
                                  setState(() {
                                    isButton4Pressed = !isButton4Pressed;
                                    if (isButton4Pressed) {
                                      selectedCourts.add('4');
                                    } else {
                                      selectedCourts.remove('4');
                                    }
                                  });
                                  print('Button 4 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '4',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton4Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[4] != 'Closed') {
                                  setState(() {
                                    isButton5Pressed = !isButton5Pressed;
                                    if (isButton5Pressed) {
                                      selectedCourts.add('5');
                                    } else {
                                      selectedCourts.remove('5');
                                    }
                                  });
                                  print('Button 5 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '5',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton5Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[5] != 'Closed') {
                                  setState(() {
                                    isButton6Pressed = !isButton6Pressed;
                                    if (isButton6Pressed) {
                                      selectedCourts.add('6');
                                    } else {
                                      selectedCourts.remove('6');
                                    }
                                  });
                                  print('Button 6 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '6',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton6Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[6] != 'Closed') {
                                  setState(() {
                                    isButton7Pressed = !isButton7Pressed;
                                    if (isButton7Pressed) {
                                      selectedCourts.add('7');
                                    } else {
                                      selectedCourts.remove('7');
                                    }
                                  });
                                  print('Button 7 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '7',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton7Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[7] != 'Closed') {
                                  setState(() {
                                    isButton8Pressed = !isButton8Pressed;
                                    if (isButton8Pressed) {
                                      selectedCourts.add('8');
                                    } else {
                                      selectedCourts.remove('8');
                                    }
                                  });
                                  print('Button 8 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '8',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton8Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (courtStatuses.isNotEmpty && courtStatuses[8] != 'Closed') {
                                  setState(() {
                                    isButton9Pressed = !isButton9Pressed;
                                    if (isButton9Pressed) {
                                      selectedCourts.add('9');
                                    } else {
                                      selectedCourts.remove('9');
                                    }
                                  });
                                  print('Button 9 pressed ...');
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '9',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton9Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('Button 10 pressed ...');
                                if (courtStatuses.isNotEmpty && courtStatuses[9] != 'Closed') {
                                  setState(() {
                                    isButton10Pressed = !isButton10Pressed;
                                    if (isButton10Pressed) {
                                      selectedCourts.add('10');
                                    } else {
                                      selectedCourts.remove('10');
                                    }
                                  });
                                }
                                else {
                                  // Court is closed, display a message or handle it accordingly.
                                  Fluttertoast.showToast(
                                    msg: "Court Under Maintenance",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    color.AppColor.gradientTurquoise,
                                elevation: 3,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: 60,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Rubik',
                                    color: isButton10Pressed
                                        ? color.AppColor.textBlack
                                        : color.AppColor.textGray,
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View ',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: color.AppColor.textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        String email = widget.userID;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MapCourtWidget(userID: email)));
                      },
                      child: Text(
                        'Court Map',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          courtSelected = selectedCourts.join(", ");
                          // Check if today is a valid booking date (e.g., not in the past)
                          DateTime currentDate = DateTime.now();
                          if (today.isBefore(currentDate)) {
                            Fluttertoast.showToast(
                              msg: "Invalid Date Range",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              fontSize: 16.0,
                            );
                            return;
                          }

                          // Create DateTime objects with the same date (e.g., today's date)
                          DateTime currentDateBook = DateTime.now();
                          DateTime startTime = DateTime(currentDateBook.year, currentDateBook.month, currentDateBook.day, int.parse(dropDownValue1!.substring(0, 2)), int.parse(dropDownValue1!.substring(2)));
                          DateTime endTime = DateTime(currentDateBook.year, currentDateBook.month, currentDateBook.day, int.parse(dropDownValue2!.substring(0, 2)), int.parse(dropDownValue2!.substring(2)));

                          // Check the time difference
                          if (endTime.isBefore(startTime)) {
                            Fluttertoast.showToast(
                              msg: "Invalid Time Range",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              fontSize: 16.0,
                            );
                            return;
                          }

                          // Check if the selected courts are available
                          try {
                            // Check if the selected courts are available

                            bool courtsAvailable = await checkCourtAvailability(
                              today.toString(),
                              dropDownValue1!,
                              dropDownValue2!,
                              courtSelected,
                            );

                            if (!courtsAvailable) {
                              Fluttertoast.showToast(
                                msg: "Opsss! Sorry Booking Doesn't Available.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                fontSize: 16.0,
                              );
                            }
                            else{
                              String email = widget.userID;
                              numberOfSelectedCourts = selectedCourts.length;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckoutBookingWidget(userID: email, dateFwd: today, sTime: dropDownValue1, eTime: dropDownValue2, crtFwd: courtSelected, tCourt: numberOfSelectedCourts)),
                              );
                            }
                          } catch (e) {
                            print("Error: $e");
                            if (e is http.Response) {
                              print("Response Body: ${e.body}");
                            }
                          }


                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.AppColor.gradientTurquoise,
                          elevation: 3,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            'Book',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              color: color.AppColor.textBlack,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String email = widget.userID;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePageWidget(userID: email)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.AppColor.gradientTurquoise,
                          elevation: 3,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              color: color.AppColor.textBlack,
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
    );
  }
}
