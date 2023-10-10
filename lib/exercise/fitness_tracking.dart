import 'dart:typed_data';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../colors.dart' as color;
//import '../WidgetAnimation.dart' as animations;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home_page_new.dart';
import '../connection_class.dart';

class ListFitnessDetails {
  final String fitnessID;
  final String userID;
  final String exerciseID;
  final String exerciseName;
  final String timeTaken;
  final double caloriesBurn;
  final String dateExercise;
  final String imageExercise;

  ListFitnessDetails({
    required this.fitnessID,
    required this.userID,
    required this.exerciseID,
    required this.exerciseName,
    required this.timeTaken,
    required this.caloriesBurn,
    required this.dateExercise,
    required this.imageExercise,
  });
}

class FitnessTrackerWidget extends StatefulWidget {
  final String userID;
  const FitnessTrackerWidget({Key? key, required this.userID})
      : super(key: key);

  @override
  State<FitnessTrackerWidget> createState() => _FitnessTrackerWidgetState();
}

class _FitnessTrackerWidgetState extends State<FitnessTrackerWidget>
    with TickerProviderStateMixin {
  //late WeightTrackerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String? selectedType;
  double totalAllCal = 0.0;
  double totalBMRCal = 0.0;
  final List<double> xData = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  final List<double> yData = [0, 2, 4, 3, 5, 6, 8, 7, 9, 10, 12];
  List<ListFitnessDetails> listFitnessDetails = [];
  List<DateTime> datesGraph = [];
  List<double> caloriesBurnGraph = [];
  double percent = 0.0;

  @override
  void initState() {
    super.initState();
    selectedType = 'All';
    fetchCalories();
    fetchDataFitness();
    fetchDataGraph();
  }

  Future<void> fetchDataFitness() async {
    String id = widget.userID;
    String functionName = 'retrieveExs';
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getFitness.php?function=$functionName&userID=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final cartData = json.decode(response.body);
      final List<ListFitnessDetails> items = [];

      // Convert cartData into CartItem objects
      for (var itemData in cartData) {
        ListFitnessDetails item = ListFitnessDetails(
          fitnessID: itemData['fitnessID'].toString(),
          userID: itemData['userID'],
          exerciseID: itemData['exerciseID'].toString(),
          exerciseName: itemData['exerciseName'],
          timeTaken: itemData['timeTaken'],
          caloriesBurn: double.parse(itemData['caloriesBurn']),
          dateExercise: itemData['dateExercise'],
          imageExercise: itemData['Image'],
        );
        items.add(item);
      }

      setState(() {
        listFitnessDetails = items;
      });
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
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

  Future<void> updateWeightHeight(BuildContext context, String newWeight, String newHeight) async {
    String id = widget.userID;
    String function = 'updateWH';
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getFitness.php';

    final response = await http.post(Uri.parse(url), body: {
      'function': function,
      'userID': id,
      'weight': newWeight,
      'height': newHeight,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["message"] != null) {
        Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        ).then((value) {
          // Fetch the updated list after the toast is shown
          fetchCalories();
          Navigator.of(context).pop();
        });
      } else {
        Fluttertoast.showToast(
          msg: "Error updating weight and height: ${jsonResponse["respond"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  Future<void> fetchDataGraph() async {
    String id = widget.userID;
    String functionName = 'retrieveGrp';
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getFitness.php?function=$functionName&userID=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        datesGraph.clear();
        caloriesBurnGraph.clear();
        for (var item in jsonData) {
          datesGraph.add(DateTime.parse(item['dateExercise']));
          caloriesBurnGraph.add(double.parse(item['caloriesBurn']));
        }
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<void> getDataGraph(String functionName) async {
    String id = widget.userID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getFitMonth.php?function=$functionName&userID=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        // Clear existing data
        datesGraph.clear();
        caloriesBurnGraph.clear();

        // Update with new data
        for (var item in jsonData) {
          int year = item['year'];
          int month = item['month'];
          caloriesBurnGraph.add(double.parse(item['sltCaloriesBurn']));
          datesGraph.add(DateTime(year, month));
        }
      });
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }

  Future<void> getDGYear(String functionName) async {
    String id = widget.userID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getFitMonth.php?function=$functionName&userID=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        // Clear existing data
        datesGraph.clear();
        caloriesBurnGraph.clear();

        // Update with new data
        for (var item in jsonData) {
          int year = item['year'];
          caloriesBurnGraph.add(double.parse(item['yearlyCaloriesBurn']));
          datesGraph.add(DateTime(year));
        }
      });
    } else {
      throw Exception('Failed to fetch data from API');
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
        backgroundColor: color.AppColor.gradientTurquoise,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                double weightInput = 0.0;
                double heightInput = 0.0;

                return AlertDialog(
                  title: const Text('Enter New Weight and Height'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                        decoration: const InputDecoration(
                          labelText: 'New Weight',
                        ),
                        onChanged: (value) {
                          weightInput = double.tryParse(value)!;
                        },
                      ),
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                        decoration: const InputDecoration(
                          labelText: 'New Height',
                        ),
                        onChanged: (value) {
                          heightInput = double.tryParse(value)!;
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel',
                        style: TextStyle(
                          color: color.AppColor.gradientRed,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Save',
                        style: TextStyle(
                          color: color.AppColor.gradientTurquoise,
                        ),
                      ),
                      onPressed: () {
                        // Perform validation and save the weight and height data
                        if (weightInput != 0.0 && heightInput != 0.0) {
                          updateWeightHeight(context, weightInput.toString(), heightInput.toString());
                        }else{
                          Fluttertoast.showToast(
                            msg: "Please insert the value!",
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
          backgroundColor: color.AppColor.gradientTurquoise,
          elevation: 8,
          child: Icon(
            Icons.add_outlined,
            color: color.AppColor.iconWhite,
            size: 24,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 48, 24, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: color.AppColor.iconWhite,
                      size: 30,
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
                  Text(
                    'Fitness Tracking',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: color.AppColor.homePageBackground,
                      fontSize: 24,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.more_vert_rounded,
                        size: 30,
                        color: color.AppColor.iconWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(48, 48, 48, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.iconWhite,
                          fontSize: 12,
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalAllCal.toString(),
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              color: color.AppColor.iconWhite,
                              fontSize: 36,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 0, 0, 6),
                            child: Text(
                              'cals',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                color: color.AppColor.iconWhite,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    alignment: const AlignmentDirectional(0, 0),
                    children: [
                      CircularPercentIndicator(
                        percent: percent,
                        radius: 30,
                        lineWidth: 4,
                        animation: true,
                        progressColor: color.AppColor.iconWhite,
                        backgroundColor: const Color(0x4D000000),
                      ),
                      Image.asset(
                        'assets/images/kcal.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TARGET',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.iconWhite,
                          fontSize: 12,
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalBMRCal.toString(),
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              color: color.AppColor.iconWhite,
                              fontSize: 36,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                2, 0, 0, 6),
                            child: Text(
                              'cals',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                color: color.AppColor.iconWhite,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: color.AppColor.homePageBackground,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 24, 24, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Progress',
                                style: TextStyle(
                                  color: color.AppColor.textBlack,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Rubik',
                                  fontSize: 16,
                                ),
                              ),
                              DropdownButton<String>(
                                value: selectedType, // Set the initial selected value
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedType = newValue;
                                    if (selectedType == 'Monthly'){
                                      getDataGraph(selectedType!);
                                    }
                                    else if (selectedType == 'Yearly'){
                                      getDGYear(selectedType!);
                                    }
                                    else{
                                      fetchDataGraph();
                                    }
                                  });
                                },
                                dropdownColor: color.AppColor.gradientTurquoise,
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: color.AppColor.textBlack,
                                  size: 24,
                                ),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  color: color.AppColor.textBlack,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'All',
                                    child: Text('All'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Monthly',
                                    child: Text('Monthly'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Yearly',
                                    child: Text('Yearly'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                                  child: SizedBox(
                                    width: 400,
                                    height: 200,
                                    child: datesGraph.isEmpty || caloriesBurnGraph.isEmpty
                                        ? const Center(
                                          child: Text('No data available'),
                                        )
                                        : BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.spaceEvenly,
                                        maxY: caloriesBurnGraph.reduce((a, b) => a > b ? a : b),
                                        barGroups: List.generate(
                                          datesGraph.length,
                                              (index) => BarChartGroupData(
                                            x: datesGraph[index].millisecondsSinceEpoch.toInt(),
                                            barRods: [
                                              BarChartRodData(
                                                toY: caloriesBurnGraph[index],
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                        ),
                                        titlesData: MyCustomTitlesData(),
                                        gridData: FlGridData(
                                          show: true,
                                          checkToShowHorizontalLine: (value) => value % 10 == 0,
                                          getDrawingHorizontalLine: (value) => FlLine(
                                            color: Colors.black12,
                                            strokeWidth: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 36, 24, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Timeline',
                                style: TextStyle(
                                  color: color.AppColor.textBlack,
                                  fontFamily: 'Rubik',
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_control_outlined,
                                color: color.AppColor.iconWhite,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 48),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // Add code to generate timeline based on data
                                        for (int i = 0; i < listFitnessDetails.length; i++)
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: color.AppColor.gradientTurquoise,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              if (i != listFitnessDetails.length - 1)
                                                ClipRRect(
                                                  child: Container(
                                                    width: 2,
                                                    height: 96,
                                                    decoration: BoxDecoration(
                                                      color: color.AppColor.textBlack,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                            child: listFitnessDetails.isEmpty
                                                ? const Center(
                                              child: Text('No activity yet.'),
                                            )
                                                : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              primary: false,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: listFitnessDetails.length,
                                              itemBuilder: (context, index) {
                                                final listFD = listFitnessDetails[index];
                                                return WidgetLFD(
                                                  lFitDtl: listFD,
                                                );
                                              },
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetLFD extends StatelessWidget {
  final ListFitnessDetails lFitDtl;

  const WidgetLFD({
    super.key,
    required this.lFitDtl,
  });

  @override
  Widget build(BuildContext context) {
    String img = lFitDtl.imageExercise;
    Uint8List imageBytes = Uint8List.fromList(base64.decode(img));
    ImageProvider<Object> imageProvider = MemoryImage(imageBytes);

    return Container(
      width: 286.6,
      height: 100,
      decoration: BoxDecoration(
        color: color.AppColor.home2PageBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Calories Burn: ${lFitDtl.caloriesBurn}',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        color: color.AppColor.gradientTurquoise,
                        fontSize: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 2),
                      child: Text(
                        'cals',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          color: color.AppColor.gradientTurquoise,
                          fontSize: 12,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  lFitDtl.dateExercise,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: color.AppColor.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  lFitDtl.exerciseName,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: color.AppColor.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  'Time Taken: ${lFitDtl.timeTaken}',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    color: color.AppColor.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomTitles extends AxisTitles {
  TextStyle getTextStyles(double value) {
    return const TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
  }
}

class MyCustomTitlesData extends FlTitlesData {
  @override
  AxisTitles get bottomTitles => MyCustomTitles();

  @override
  AxisTitles get leftTitles => MyCustomTitles();
}