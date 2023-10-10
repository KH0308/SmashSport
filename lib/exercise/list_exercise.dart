import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../colors.dart' as color;
import '../home_page_new.dart';
import '../connection_class.dart';
import 'package:http/http.dart' as http;
import 'details_exercise.dart';
/*import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';*/

class Exercise {
  final String id;
  final String name;
  final String categories;
  final String setExercise;
  final int duration;
  final String calories;
  final String image;

  Exercise({
    required this.id,
    required this.name,
    required this.categories,
    required this.setExercise,
    required this.duration,
    required this.calories,
    required this.image,
  });
}

class ListExerciseWidget extends StatefulWidget {
  final String userID, cgyFwd;
  const ListExerciseWidget({Key? key, required this.userID, required this.cgyFwd}) : super(key: key);

  @override
  State<ListExerciseWidget> createState() => _ListExerciseWidgetState();
}

class _ListExerciseWidgetState extends State<ListExerciseWidget> {
  //late ListExerciseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<Exercise> exerciseList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    //_model = createModel(context, () => ListExerciseModel());
  }

  Future<void> fetchData() async {
    String cgy = widget.cgyFwd;
    var baseUrl = ConnectionClass.ipUrl;
    final response = await http.get(Uri.parse('${baseUrl}get_exercise.php?cgy=$cgy'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Exercise> exercise = [];

      for (var exerciseData in data) {
        final exs = Exercise(
          id: exerciseData['id'],
          name: exerciseData['name'],
          categories: exerciseData['training_category'],
          setExercise: exerciseData['setExercise'],
          duration: int.parse(exerciseData['duration_minutes']),
          calories: exerciseData['calories_burned'],
          image: exerciseData['img_exr'],
        );
        exercise.add(exs);
      }

      setState(() {
        exerciseList = exercise;
      });
    } else {
      throw Exception('Failed to fetch data');
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: color.AppColor.homePageBackground,
        appBar: AppBar(
          backgroundColor: color.AppColor.homePageBackground,
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
                  builder: (context) => HomePageWidget(userID: email),
                ),
              );
            },
          ),
          title: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Text(
              'Exercise List',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                fontFamily: 'Rubik',
                color: color.AppColor.textBlack,
              ),
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Text(
                        'Below are the list of badminton exercise',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: exerciseList.isEmpty
                          ? Center(
                        child: Text('No exercise for ${widget.cgyFwd}'),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: exerciseList.length,
                        itemBuilder: (context, index) {
                          final listExs = exerciseList[index];
                          final email = widget.userID;
                          return WidgetExercise(
                            lExs: listExs,
                            idUser: email,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetExercise extends StatelessWidget {
  final Exercise lExs;
  final String idUser;

  const WidgetExercise({
    super.key,
    required this.lExs,
    required this.idUser,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = Uint8List.fromList(base64.decode(lExs.image));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.AppColor.home2PageBackground,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x320E151B),
            offset: Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                imageBytes,
                width: 80,
                height: 80,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        lExs.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'Set Exercise: ${lExs.setExercise} set',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'Duration: ${lExs.duration} minutes',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'Calories: ${lExs.calories}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.AppColor.gradientTurquoise,
                size: 20,
              ),
              onPressed: () async {
                String email = idUser;
                String idExs = lExs.id;
                String cat = lExs.categories;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailsExerciseWidget(
                            userID: email, exsID: idExs, cgyExs: cat),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}