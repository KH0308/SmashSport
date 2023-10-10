import 'package:flutter/material.dart';
import 'package:SmashSport/colors.dart' as color;
import 'main_booking.dart';

class MapCourtWidget extends StatefulWidget {
  final String userID;
  const MapCourtWidget({Key? key, required this.userID}) : super(key: key);

  @override
  State<MapCourtWidget> createState() => _MapCourtWidgetState();
}

class _MapCourtWidgetState extends State<MapCourtWidget> {
  //late MapCourtModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //_model = createModel(context, () => MapCourtModel());
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: color.AppColor.textBlack,
                          size: 24,
                        ),
                        onPressed: () async {
                          String email = widget.userID;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainPageBookWidget(userID: email)),
                          );
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Badminton Court Map',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w600,
                            color: color.AppColor.textBlack,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                child: Container(
                  width: double.infinity,
                  height: 750,
                  decoration: BoxDecoration(
                    color: color.AppColor.home2PageBackground,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://www.concordrec.com.au/sites/default/files/inline-images/FDLC%20Badminton.png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
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