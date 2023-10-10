import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main_booking.dart';
import '../home_page_new.dart';
import 'package:SmashSport/colors.dart' as color;
import 'qr_pay.dart';
//import 'package:toggle_switch/toggle_switch.dart';

class CheckoutBookingWidget extends StatefulWidget {
  final String userID, crtFwd;
  final String? sTime, eTime;
  final DateTime dateFwd;
  final int tCourt;
  const CheckoutBookingWidget(
      {Key? key,
      required this.userID,
      required this.dateFwd,
      required this.sTime,
      required this.eTime,
      required this.crtFwd,
      required this.tCourt})
      : super(key: key);

  @override
  State<CheckoutBookingWidget> createState() => _CheckoutBookingWidgetState();
}

class _CheckoutBookingWidgetState extends State<CheckoutBookingWidget> {
  //late CheckoutBookingModel _model;
  late int _countValue;
  //late ValueNotifier<String?> radioButtonValueController;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String rckChoice = '';
  late int numRkt;
  // initialize all forward data
  late DateTime date;
  late String email, court;
  String? start, end;
  // State field(s) for Switch widget.
  bool switchValue = false;
  // State field(s) for CountController widget.
  int? countControllerValue;
  //bool isPaySelect = false;
  //bool isButtonPressed = false;
  int selectedOption = 0;
  double subTotal = 0.0;
  double taxes = 0.06;
  double totalAll = 0.0;
  String racket = '';

  @override
  void initState() {
    super.initState();
    _countValue = 1;
    numRkt = 0;
    // retrieve all forward data
    date = widget.dateFwd;
    email = widget.userID;
    start = widget.sTime;
    end = widget.eTime;
    court = widget.crtFwd;
    // calculate price
    calculateSubTotal();
  }

  void calculateSubTotal() {
    int startTime = int.parse(start!);
    int endTime = int.parse(end!);
    // Convert the time values to DateTime objects
    DateTime endDate = DateTime(0, 0, 0, endTime ~/ 100, endTime % 100);
    DateTime startDate = DateTime(0, 0, 0, startTime ~/ 100, startTime % 100);

    // Calculate the time difference
    Duration difference = endDate.difference(startDate);

    // Calculate the difference in hours
    int duration = difference.inHours;
    //int duration = endTime - startTime;
    int courtCount = widget.tCourt;

    if (startTime >= 1100 && endTime < 1800) {
      // Time range: 1100-1800
      subTotal = 18.0 * duration * courtCount;
    } else if (startTime >= 1800 && endTime <= 2400) {
      // Time range: 1800-0000 (assuming the end time is within 24:00)
      subTotal = 20.0 * duration * courtCount;
    } else {
      // Handle other time ranges or invalid cases
      subTotal = 0.0;
    }

    print('Subtotal: RM $subTotal');
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return const SimpleDialog(
          title: Text('Information'),
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Total value after includes taxes'),
            ),
          ],
        );
      },
    );
  }

  void showInfoDialogRacket(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return const SimpleDialog(
          title: Text('Information'),
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Remark racket not will be calculate on total pay.\n'
                  'Please pay and get your racket at court TQ'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    //_model.dispose();

    //radioButtonValueController.dispose();
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.watch<FFAppState>();
    totalAll = ((subTotal * taxes) + subTotal);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: color.AppColor.homePageBackground,
        appBar: AppBar(
          backgroundColor: color.AppColor.gradientTurquoise,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: color.AppColor.iconBlack,
              size: 24,
            ),
            onPressed: () async {
              String email = widget.userID;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPageBookWidget(userID: email)),
              );
            },
          ),
          title: Text(
            'Check Out',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w600,
              color: color.AppColor.textBlack,
              fontSize: 20,
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: color.AppColor.home2PageBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              date.toString().split(" ")[0],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start Time:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              start!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'End Time:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              end!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Court Number:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              court,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Remark Rental Racket:',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '$rckChoice $numRkt',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal(RM):',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              subTotal.toStringAsFixed(2),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 0,
                              runSpacing: 0,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              direction: Axis.horizontal,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  'Total(RM):',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: color.AppColor.textBlack,
                                    fontFamily: 'Rubik',
                                    fontSize: 14,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.info_outlined,
                                    color: color.AppColor.iconBlack,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    showInfoDialog(context);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              totalAll.toStringAsFixed(2),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.AppColor.textBlack,
                                fontFamily: 'Rubik',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust this to your preference
                children: [
                  Row(
                    children: [
                      Text(
                        'Remark Rental Racket',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: color.AppColor.textBlack,
                          fontFamily: 'Rubik',
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.info_outlined,
                          color: color.AppColor.iconBlack,
                          size: 18,
                        ),
                        onPressed: () {
                          showInfoDialogRacket(context);
                        },
                      ),
                    ],
                  ),
                  Switch.adaptive(
                    value: switchValue,
                    onChanged: (newValue) async {
                      setState(() => switchValue = newValue);
                    },
                    activeColor: color.AppColor.gradientTurquoise,
                    activeTrackColor: color.AppColor.gradientTurquoise,
                    inactiveTrackColor: color.AppColor.textGray,
                    inactiveThumbColor: color.AppColor.textGray,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color.AppColor.homePageBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                        child: ToggleButtons(
                          isSelected: List<bool>.generate(
                              4, (index) => index == selectedOption),
                          borderRadius: BorderRadius.circular(12.0),
                          selectedColor: Colors.white,
                          fillColor: color.AppColor.gradientTurquoise,
                          color: color.AppColor.textBlack,
                          borderWidth: 2,
                          borderColor: color.AppColor.gradientTurquoise,
                          selectedBorderColor: color.AppColor.gradientTurquoise,
                          onPressed: switchValue
                              ? (index) {
                                  setState(() {
                                    selectedOption = index;
                                    if (index == 0) {
                                      rckChoice = "Yonex";
                                    } else if (index == 1) {
                                      rckChoice = "Maxbolt";
                                    } else if (index == 2) {
                                      rckChoice = "Apacs";
                                    } else if (index == 3) {
                                      rckChoice = "Li-ning";
                                    } else {
                                      rckChoice = "";
                                    }
                                  });
                                }
                              : null,
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Yonex'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Maxbolt'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Apacs'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Li-ning'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Container(
                  width: 156,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.AppColor.home2PageBackground,
                    borderRadius: BorderRadius.circular(25),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: color.AppColor.gradientTurquoise,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: switchValue
                            ? () {
                                setState(() {
                                  if (_countValue > 1) {
                                    _countValue--;
                                    numRkt = _countValue;
                                  }
                                });
                              }
                            : null,
                        icon: Icon(
                          FontAwesomeIcons.minus,
                          color: _countValue > 1
                              ? color.AppColor.textGray
                              : const Color(0xFFE0E3E7),
                          size: 20,
                        ),
                      ),
                      Text(
                        _countValue.toString(),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Rubik',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                      IconButton(
                        onPressed: switchValue
                            ? () {
                                setState(() {
                                  if (_countValue < 10) {
                                    _countValue++;
                                    numRkt = _countValue;
                                  }
                                });
                              }
                            : null,
                        icon: Icon(
                          FontAwesomeIcons.plus,
                          color: _countValue < 10
                              ? color.AppColor.textBlack
                              : const Color(0xFFE0E3E7),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        racket = '$rckChoice $numRkt';
                        String email = widget.userID;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QrPaymentWidget(
                                  userID: email,
                                  dateFwd: date,
                                  sTime: start,
                                  eTime: end,
                                  crtFwd: court,
                                  rckFwd: racket,
                                  tPayFwd: totalAll,
                                  tCourt: widget.tCourt)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(80, 40),
                        backgroundColor: color.AppColor.gradientTurquoise,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Rubik',
                          color: color.AppColor.textBlack,
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
                        minimumSize: const Size(80, 40),
                        backgroundColor: color.AppColor.gradientTurquoise,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
