import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../colors.dart' as color;
import 'package:http/http.dart' as http;
import '../connection_class.dart';
import '../home_page_new.dart';

class EventDetailsWidget extends StatefulWidget {
  final String userID;
  final int newsFwd;
  const EventDetailsWidget({Key? key, required this.userID, required this.newsFwd}) : super(key: key);

  @override
  State<EventDetailsWidget> createState() => _EventDetailsWidgetState();
}

class _EventDetailsWidgetState extends State<EventDetailsWidget>
    with TickerProviderStateMixin {
  //late EventDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  ScrollController? columnController;
  late int id = 0;
  late String eventName = '';
  late String organizer = '';
  late int numOfParticipant = 0;
  late int crtParticipant = 0;
  late String dateEvent = '';
  late String timeRange = '';
  late String eventPlace = '';
  late String description = '';

  @override
  void initState() {
    super.initState();
    columnController = ScrollController();
    fetchNewsData();
    //_model = createModel(context, () => EventDetailsModel());
  }

  Future<void> fetchNewsData() async {
    String function = 'newsByID';
    String idNews = widget.newsFwd.toString();
    var baseUrl = ConnectionClass.ipUrl;
    final response =
    await http.get(Uri.parse('${baseUrl}getNews.php?function=$function&newsID=$idNews'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        id = jsonData[0]['id'];
        eventName = jsonData[0]['eventName'];
        organizer = jsonData[0]['organizer'];
        numOfParticipant = jsonData[0]['numOfParticipant'];
        crtParticipant = jsonData[0]['currentParticipant'];
        dateEvent = jsonData[0]['eventDate'];
        timeRange = jsonData[0]['timeRange'];
        eventPlace = jsonData[0]['eventPlace'];
        description = jsonData[0]['eventDesc'];

        //countDownDuration = Duration(minutes: durationExs);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<String> addToEvent() async {
    int idEvent = widget.newsFwd;
    String idUser = widget.userID;
    var baseUrl = ConnectionClass.ipUrl;
    final response =
    await http.get(Uri.parse('${baseUrl}joinEvent.php?userID=$idUser&eventID=$idEvent'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['respond'];
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void dispose() {
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
        backgroundColor: color.AppColor.home2PageBackground,
        body: SingleChildScrollView(
          controller: columnController,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 650,
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
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 36, 24, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: color.AppColor.gradientTurquoise,
                                  size: 24,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 650, 0, 0),
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
                          padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            await columnController
                                                ?.animateTo(
                                              columnController!.position
                                                  .maxScrollExtent,
                                              duration:
                                              const Duration(milliseconds: 100),
                                              curve: Curves.ease,
                                            );
                                          },
                                          child: Text(
                                            'DETAIL EVENTS',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              color: color.AppColor.gradientTurquoise,
                                              fontSize: 12,
                                              letterSpacing: 0.4,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                          child: Text(
                                            eventName,
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              color: color.AppColor.textBlack,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                organizer,
                                                style:
                                                TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  color: color.AppColor.textBlack,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  addToEvent().then((response) {
                                                    Fluttertoast.showToast(
                                                      msg: response,
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      fontSize: 16.0,
                                                    );
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                                  backgroundColor: color.AppColor.gradientTurquoise,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Join',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    color: color.AppColor.textBlack,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Limit Join: $numOfParticipant',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        color: color.AppColor.textBlack,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: color.AppColor.home2PageBackground,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: Image.network(
                                                  'https://images.unsplash.com/photo-1604004555489-723a93d6ce74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
                                                ).image,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(14),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                            child: Container(
                                              width: 42,
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: color.AppColor.gradientTurquoise,
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$crtParticipant are join',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    color: color.AppColor.iconWhite,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 24, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            color: color.AppColor.gradientTurquoise,
                                            size: 24,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                12, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  dateEvent,
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: color.AppColor.textBlack,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(0, 6, 0, 0),
                                                  child: Text(
                                                    timeRange,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      fontSize: 14,
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
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 16, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: color.AppColor.gradientTurquoise,
                                            size: 24,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                12, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  eventPlace,
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: color.AppColor.textBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'About',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 20,
                                        color: color.AppColor.textBlack,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Text(
                                        description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Rubik',
                                          color: color.AppColor.textBlack,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 16, 0, 0),
                                      child: Text(
                                        'Location',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 20,
                                          color: color.AppColor.textBlack,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: color.AppColor.home2PageBackground,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.asset(
                                              'assets/images/map.png',
                                            ).image,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(24),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 48, 0, 48),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      organizer,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: color.AppColor.textBlack,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w600,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}