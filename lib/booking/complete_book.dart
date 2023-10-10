import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../colors.dart' as color;
import '../home_page_new.dart';
import 'booking_history.dart';

class SuccessBookPageWidget extends StatefulWidget {
  final String userID;
  const SuccessBookPageWidget({Key? key, required this.userID}) : super(key: key);

  @override
  State<SuccessBookPageWidget> createState() => _SuccessBookPageWidgetState();
}

class _SuccessBookPageWidgetState extends State<SuccessBookPageWidget> {
  //late SuccessExercisePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  /*@override
  void initState() {
    super.initState();
    //_model = createModel(context, () => SuccessExercisePageModel());
  }*/

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
        backgroundColor: color.AppColor.gradientTurquoise,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_xlkxtmul.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      frameRate: FrameRate(60),
                      repeat: false,
                      animate: true,
                    ),
                  ],
                ),
              ),
              Text(
                'Reservation Complete!',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  color: color.AppColor.iconBlack,
                  fontSize: 32,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Text(
                  'Thank You for use our service',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: color.AppColor.iconBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 44, 0, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    String email = widget.userID;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ListBookingWidget(userID: email)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.AppColor.iconBlack,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Container(
                    width: 140,
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      'Booking History',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 16,
                        color: color.AppColor.homePageBackground,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 44, 0, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    String email = widget.userID;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageWidget(userID: email)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.AppColor.iconBlack,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Container(
                    width: 140,
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      'Go Home',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 16,
                        color: color.AppColor.homePageBackground,
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