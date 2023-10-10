import 'dart:async';
//import 'package:flick_video_player/flick_video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import '../colors.dart' as color;
import 'complete_exercise.dart';
import 'list_exercise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../connection_class.dart';

class DetailsExerciseWidget extends StatefulWidget {
  final String userID, exsID, cgyExs;
  const DetailsExerciseWidget({Key? key, required this.userID, required this.exsID, required this.cgyExs}) : super(key: key);

  @override
  State<DetailsExerciseWidget> createState() => _DetailsExerciseWidgetState();
}

class _DetailsExerciseWidgetState extends State<DetailsExerciseWidget> {
  //late DetailsExerciseModel _model;

  //late VideoPlayerController _controller;
  //late YoutubePlayerController _controller;
  //final videoURL = "https://www.youtube.com/watch?v=xqvCmoLULNY";
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  Duration countDownDuration = Duration();
  Duration duration = Duration();
  Timer? timer;
  bool isCountdown = true;
  late String id = '';
  late String name = '';
  late String description = '';
  late String categories = '';
  late int setExercise = 0;
  late int durationExs = 0;
  late double calories = 0.0;
  late String image = '';
  late String videoURL = '';
  late String dateExsFormat;
  DateTime dateExs = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchExerciseDetail().then((_) {
      countDownDuration = Duration(minutes: durationExs);
      dateExsFormat = DateFormat('yyyy/MM/dd').format(dateExs);
      //startTimer();
      reset();
    });
  }

  /*Future<void> _initializeController() async {
    // Your initialization code here
    // Await any asynchronous operations if necessary
    final videoID = YoutubePlayer.convertUrlToId(videoURL!);
    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }*/

  Future<void> fetchExerciseDetail() async {
    // Make an HTTP request to your API endpoint
    // Pass the category as a parameter to retrieve products based on the category
    String idExs = widget.exsID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getExsDtl.php?exs=$idExs';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      //final List<ProductDetail> products = [];

      if (jsonData.isNotEmpty) {
        setState(() {
          id = jsonData[0]['id'];
          name = jsonData[0]['name'];
          description = jsonData[0]['description'];
          categories = jsonData[0]['training_category'];
          setExercise = int.parse(jsonData[0]['setExercise']);
          durationExs = int.parse(jsonData[0]['duration_minutes']);
          calories = double.parse(jsonData[0]['calories_burned']);
          image = jsonData[0]['img_exr'];
          videoURL = jsonData[0]['vid_exr'];

          //countDownDuration = Duration(minutes: durationExs);
        });
      }
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> insertExsRcd(BuildContext cont) async {
    String baseUrl = ConnectionClass.ipUrl;
    String url = '${baseUrl}insertFitness.php';
    String userID = widget.userID;
    String exerciseID = widget.exsID;
    String exerciseName = name;
    String timeTaken = (countDownDuration-duration).toString();
    Duration finishTime = (countDownDuration-duration);
    double calPerSec = calories/(durationExs*60);
    double caloriesBurn = finishTime.inSeconds*calPerSec;
    String caloriesBurnValue = caloriesBurn.toStringAsFixed(2);
    String dateExercise = dateExsFormat;

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'userID': userID,
        'exerciseID': exerciseID,
        'exerciseName': exerciseName,
        'timeTaken': timeTaken,
        'caloriesBurn': caloriesBurnValue,
        'dateExercise': dateExercise,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      String email = widget.userID;
      Navigator.push(
        cont,
        MaterialPageRoute(builder: (context) => SuccessExercisePageWidget(userID: email)),
      );
    } else {
      // Registration failed
      Fluttertoast.showToast(
        msg: "Record failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
  }

  void reset() {
    if (isCountdown) {
      setState(() => duration = countDownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() => timer?.cancel());
  }

  void addTime() {
    final addSecond = isCountdown ? -1 : 1;

    setState(() {
      final second = duration.inSeconds + addSecond;

      if (second < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: second);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //_model.dispose();
    _unfocusNode.dispose();
    //_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoID = YoutubePlayer.convertUrlToId(videoURL);

    //context.watch<FFAppState>();
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hour = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final second = twoDigits(duration.inSeconds.remainder(60));

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
              Icons.close_rounded,
              color: color.AppColor.iconBlack,
              size: 30,
            ),
            onPressed: () async {
              String email = widget.userID;
              String category = widget.cgyExs;
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) =>
                      ListExerciseWidget(userID: email, cgyFwd: category)),
              );
            },
          ),
          title: Text(
            'Exercise',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: color.AppColor.textBlack,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            videoURL.isNotEmpty
                ? YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoID!,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            )
                : const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(32, 8, 32, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time Left',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: color.AppColor.textGreenHard,
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.refresh_rounded,
                              color: color.AppColor.iconBlack,
                              size: 20,
                            ),
                            onPressed: (stopTimer)
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTimeCard(time: hour, header: 'HOURS'),
                      const SizedBox(width: 8),
                      buildTimeCard(time: minutes, header: 'MINUTES'),
                      const SizedBox(width: 8),
                      buildTimeCard(time: second, header: 'SECONDS'),
                    ],
                  ),
                  buildButtons(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color.AppColor.home2PageBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Color(0x34111417),
                            offset: Offset(0, -2),
                          )
                        ],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 12, 15, 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 4, 0),
                                        child: Text(
                                          'Workout ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: color.AppColor.textBlack,
                                            fontSize: 20,
                                            fontFamily: 'Rubik',
                                          ),
                                        ),
                                      ),
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          color: color.AppColor.gradientTurquoise,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Current Set',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: color.AppColor.textGray,
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$setExercise in $durationExs minute',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: color.AppColor.iconBlack,
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: color.AppColor.textBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 24, 0, 44),
                              child: ElevatedButton(
                                onPressed: () async {
                                  insertExsRcd(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color.AppColor.iconBlack,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Complete Workout',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 16,
                                      color: color.AppColor.iconWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;

    return isRunning || !isCompleted
        ? Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: isRunning
              ? Icon(
            Icons.pause_rounded,
            color: color.AppColor.iconBlack,
            size: 30,
          )
              : Icon(
            Icons.play_arrow_rounded,
            color: color.AppColor.iconBlack,
            size: 30,
          ),
          onPressed: () async {
            if (isRunning) {
              stopTimer(resets: false);
            }
            else{
              startTimer(resets: false);
            }
          },
        ),
        IconButton(
            icon: Icon(
              Icons.done_rounded,
              color: color.AppColor.iconBlack,
              size: 30,
            ),
            onPressed: (stopTimer)
        ),
      ],
    )
        : IconButton(
      onPressed: () {
        startTimer();
      },
      icon: Icon(
        Icons.play_arrow_rounded,
        color: color.AppColor.iconBlack,
        size: 30,
      ),
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.AppColor.gradientTurquoise,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.AppColor.textGreenHard,
                fontSize: 64,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(header),
        ],
      );
}