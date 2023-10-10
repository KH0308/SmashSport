import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
//import 'package:smooth_page_indicator/smooth_page_indicator.dart' as smooth_page_indicator;
import 'colors.dart' as color;
import 'WidgetAnimation.dart' as animations;
import 'package:http/http.dart' as http;
import 'WelcomePage.dart';
import 'exercise/details_exercise.dart';
import 'shop/categories_product.dart';
import 'connection_class.dart';
import 'booking/main_booking.dart';
import 'booking/booking_history.dart';
import 'shop/purchase_history.dart';
import 'exercise/list_exercise.dart';
import 'exercise/fitness_tracking.dart';
import 'profile.dart';
import 'news_widget.dart';
//import 'news/news_details.dart';
/*class News {
  final int id;
  final String eventName;
  final String organizer;
  final int numOfParticipant;
  final String eventImg;

  News({
    required this.id,
    required this.eventName,
    required this.organizer,
    required this.numOfParticipant,
    required this.eventImg,
  });
}*/

class HomePageWidget extends StatefulWidget {
  final String userID;
  const HomePageWidget({Key? key, required this.userID}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  //late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  //final List<double> xData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  //final List<double> yData = [0, 2, 4, 3, 5, 6, 8, 7, 9, 10, 12];
  String name = '';
  String profPic = '';
  String exsID = '';
  String exsName = '';
  String exsCategory = '';
  /*List<News> newsList = [];
  PageController? pageViewController;
  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;*/

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataExs();
    //fetchNewsData();
  }

  Future<void> fetchData() async {
    String userid = widget.userID;
    var baseUrl = ConnectionClass.ipUrl;
    final userResponse = await http.get(Uri.parse('${baseUrl}getData.php?userID=$userid'));

    if (userResponse.statusCode == 200) {
      final userData = json.decode(userResponse.body);
      if (userData.isNotEmpty) {
        setState(() {
          name = userData[0]['name'];
          profPic = userData[0]['profilePhoto'];
        });
      }
    } else {
      throw Exception('Failed to fetch user data');
    }

    // Fetch random exercise
    final exerciseResponse = await http.get(Uri.parse('${baseUrl}getRanExs.php'));

    if (exerciseResponse.statusCode == 200) {
      final exerciseData = json.decode(exerciseResponse.body);
      if (exerciseData.isNotEmpty) {
        exsID = exerciseData[0]['id'];
        exsName = exerciseData[0]['name'];
        exsCategory = exerciseData[0]['training_category'];
      }
    } else {
      throw Exception('Failed to fetch random exercise');
    }
  }

  Future<void> fetchDataExs() async {
    String userid = widget.userID;
    var baseUrl = ConnectionClass.ipUrl;

    // Fetch random exercise
    final exerciseResponse = await http.get(Uri.parse('${baseUrl}getRanExs.php'));

    if (exerciseResponse.statusCode == 200) {
      final exerciseData = json.decode(exerciseResponse.body);
      if (exerciseData.isNotEmpty) {
        exsID = exerciseData[0]['id'];
        exsName = exerciseData[0]['name'];
        exsCategory = exerciseData[0]['training_category'];
      }
    } else {
      throw Exception('Failed to fetch random exercise');
    }
  }

  /*Future<void> fetchNewsData() async {
    String function = 'allNews';
    var baseUrl = ConnectionClass.ipUrl;
    final response =
        await http.get(Uri.parse('${baseUrl}getNews.php?function=$function'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<News> news = [];

      for (var newsData in data) {
        final nws = News(
          id: newsData['id'],
          eventName: newsData['eventName'],
          organizer: newsData['organizer'],
          numOfParticipant: newsData['numOfParticipant'],
          eventImg: newsData['eventImg'],
        );
        news.add(nws);
      }

      setState(() {
        newsList = news;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }*/

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //context.watch<FFAppState>();
    DateTime now = DateTime.now();

    // Format the date
    String day = DateFormat('EEE').format(now); // Full day name (e.g., Monday)
    String date = DateFormat('d').format(now); // Day of the month (e.g., 24)
    String month =
        DateFormat('MMM').format(now); // Full month name (e.g., September)
    Uint8List imageBytes = Uint8List.fromList(base64.decode(profPic));

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String email = widget.userID;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainPageBookWidget(userID: email)));
            },
            backgroundColor: color.AppColor.gradientTurquoise,
            elevation: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Book',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: color.AppColor.textGreenHard,
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          drawer: Drawer(
            elevation: 16,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: color.AppColor.homePageBackground,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: color.AppColor.gradientTurquoise,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                width: 120,
                                height: 120,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: imageBytes != null && imageBytes.isNotEmpty
                                    ? Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  'assets/images/profile-user.png', // Provide the path to your default image
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: color.AppColor.textGreenHard,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Text(
                                widget.userID,
                                style: TextStyle(
                                  color: color.AppColor.textGreenHard,
                                  fontFamily: 'Rubik',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      String email = widget.userID;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePageWidget(userID: email)));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: color.AppColor.iconBlack,
                      ),
                      title: Text(
                        'PROFILE',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Your details account',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          color: color.AppColor.textGreenHard,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: color.AppColor.iconBlack,
                        size: 20,
                      ),
                      tileColor: color.AppColor.gradientTurquoise,
                      dense: false,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      String email = widget.userID;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FitnessTrackerWidget(userID: email)));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.track_changes_sharp,
                        color: color.AppColor.iconBlack,
                      ),
                      title: Text(
                        'FITNESS PROGRESS',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Trace your goal',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: color.AppColor.iconBlack,
                        size: 20,
                      ),
                      dense: true,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      String email = widget.userID;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CategoriesProductsWidget(userID: email)));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.sports_tennis,
                        color: color.AppColor.iconBlack,
                      ),
                      title: Text(
                        'Sport Equipment',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Jersey, Pants, Shoes..',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: color.AppColor.iconBlack,
                        size: 20,
                      ),
                      //tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                      dense: true,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      String email = widget.userID;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListBookingWidget(userID: email)));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.history_sharp,
                        color: color.AppColor.iconBlack,
                      ),
                      title: Text(
                        'Booking History',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Details Booking',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: color.AppColor.iconBlack,
                        size: 20,
                      ),
                      //tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                      dense: true,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      String email = widget.userID;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ListPurchaseWidget(userID: email)));
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.history_sharp,
                        color: color.AppColor.iconBlack,
                      ),
                      title: Text(
                        'Purchase History',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        'Details Purchased',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: color.AppColor.iconBlack,
                        size: 20,
                      ),
                      //tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                      dense: true,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context);
                      String id = widget.userID;
                      showDialog(
                        context: context,
                        builder: (context) => FeedbackDialog(userID: id),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.feedback_rounded,
                        color: color.AppColor.iconBlack,
                      ),
                      title: Text(
                        'Feedback',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: color.AppColor.iconBlack,
                        size: 20,
                      ),
                      dense: true,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePageWidget(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: color.AppColor.iconBlack,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.textGreenHard,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: color.AppColor.iconBlack,
                        size: 20,
                      ),
                      //tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                      dense: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: color.AppColor.gradientTurquoise,
            automaticallyImplyLeading: true,
            actions: const [],
            centerTitle: true,
            elevation: 4,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Sun.svg',
                                    width: 16,
                                    height: 16,
                                    fit: BoxFit.cover,
                                  ).animateOnPageLoad(
                                      animations.animationsMap[
                                          'imageOnPageLoadAnimation']!,
                                      tickerProvider: this),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            6, 0, 0, 0),
                                    child: Text(
                                      '$day $date $month',
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        color: Color(0xFF8B80F8),
                                        //color: color.AppColor.gradientTurquoise,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 6, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Hi, ',
                                      ),
                                      TextSpan(
                                        text: name,
                                      )
                                    ],
                                    style: TextStyle(
                                      color: color.AppColor.textGreenHard,
                                      fontFamily: 'Rubik',
                                      fontSize: 24,
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
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 24, 16, 24),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: const AlignmentDirectional(0, 0),
                                  children: [
                                    Image.asset(
                                      'assets/images/runner.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exsName,
                                          style: TextStyle(
                                            color: color.AppColor.textBlack,
                                            fontFamily: 'Rubik',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 6, 0, 6),
                                          child: Text(
                                            'Daily recommended exercise only for you, Stay Fit',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              color: Color(0xFF828282),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            String email = widget.userID;
                                            String category = exsCategory;
                                            String id = exsID;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsExerciseWidget(
                                                            userID: email,
                                                            exsID: id,
                                                            cgyExs: category)));
                                          },
                                          child: const Text(
                                            'Read more',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              color: Color(0xFF8B80F8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animateOnPageLoad(
                        animations.animationsMap['columnOnPageLoadAnimation']!,
                        tickerProvider: this),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Training Metrics',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_control,
                              color: Color(0xFFE9E9E9),
                              size: 24,
                            ),
                          ],
                        ).animateOnPageLoad(
                            animations.animationsMap['rowOnPageLoadAnimation']!,
                            tickerProvider: this),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  String email = widget.userID;
                                  String category = 'Footwork Drills';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListExerciseWidget(
                                                  userID: email,
                                                  cgyFwd: category)));
                                },
                                child: Container(
                                  width: 156,
                                  height: 216,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B80F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          'assets/images/shoes.png',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text(
                                          'Footwork Drills',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  String email = widget.userID;
                                  String category = 'Agility and Speed Training';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListExerciseWidget(
                                                  userID: email,
                                                  cgyFwd: category)));
                                },
                                child: Container(
                                  width: 156,
                                  height: 216,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B80F8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          'assets/images/running.png',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text(
                                          'Agility & Speed Training',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  String email = widget.userID;
                                  String category = 'Strength Training';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListExerciseWidget(
                                                  userID: email,
                                                  cgyFwd: category)));
                                },
                                child: Container(
                                  width: 156,
                                  height: 216,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E87FD),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          'assets/images/weight-lifting.png',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text(
                                          'Strength Training',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  String email = widget.userID;
                                  String category = 'Endurance Training';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListExerciseWidget(
                                                  userID: email,
                                                  cgyFwd: category)));
                                },
                                child: Container(
                                  width: 156,
                                  height: 216,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E87FD),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          'assets/images/patience.png',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text(
                                          'Endurance Training',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  String email = widget.userID;
                                  String category = 'Hand-Eye Coordination';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListExerciseWidget(
                                                  userID: email,
                                                  cgyFwd: category)));
                                },
                                child: Container(
                                  width: 156,
                                  height: 216,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4C5A81),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          'assets/images/people.png',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text(
                                          'Hand-Eye Coordination',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  String email = widget.userID;
                                  String category = 'Balance and Core Strength';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListExerciseWidget(
                                                  userID: email,
                                                  cgyFwd: category)));
                                },
                                child: Container(
                                  width: 156,
                                  height: 216,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4C5A81),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            16, 16, 16, 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.asset(
                                          'assets/images/tightrope-walker.png',
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text(
                                          'Balance & Core Strength',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 500,
                        child: NewsCarousel(userID: widget.userID),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  final String userID;
  const FeedbackDialog({Key? key, required this.userID}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  String? _selectedType;
  String? _feedbackText;

  final List<String> _feedbackTypes = [
    'Service',
    'Booking',
    'Application',
    'Rental',
    'News',
  ];

  Future<void> sendFeedback(BuildContext cont) async {
    //String baseUrl = 'http://10.131.76.142:8080/FYP/';
    String uid = widget.userID;
    String? fbkType = _selectedType;
    String? fbkDetails = _feedbackText;
    String baseUrl = ConnectionClass.ipUrl;
    String url = '${baseUrl}insertFeedback.php';
    //final BuildContext context = cont;

    if (_selectedType != null && _feedbackText != null) {
      // Send registration data to the server
      var response = await http.post(
        Uri.parse(url),
        body: {
          'userID': uid,
          'fbkType': fbkType,
          'fbkDetails': fbkDetails,
        },
      );

      // Handle the response from the server
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Thank Yor for your feedback",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
        Navigator.pop(cont);
      } else {
        // Registration failed
        Fluttertoast.showToast(
          msg: "Feedback cannot send",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please choose type feedback and insert the details!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Provide Feedback'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            value: _selectedType,
            hint: const Text('Choose type of feedback'),
            items: _feedbackTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter your feedback',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _feedbackText = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: color.AppColor.gradientRed),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            sendFeedback(context);
          },
          child: Text(
            'Submit',
            style: TextStyle(color: color.AppColor.gradientTurquoise),
          ),
        ),
      ],
    );
  }
}
