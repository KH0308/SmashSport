import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:SmashSport/colors.dart' as color;
import 'package:fluttertoast/fluttertoast.dart';
import 'complete_book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../connection_class.dart';
import 'checkout_booking.dart';

class QrPaymentWidget extends StatefulWidget {
  final String userID, crtFwd, rckFwd;
  final String? sTime, eTime;
  final DateTime dateFwd;
  final double tPayFwd;
  final int tCourt;
  const QrPaymentWidget(
      {Key? key,
      required this.userID,
      required this.crtFwd,
      this.sTime,
      this.eTime,
      required this.dateFwd,
      required this.rckFwd,
      required this.tPayFwd,
      required this.tCourt})
      : super(key: key);

  @override
  State<QrPaymentWidget> createState() => _QrPaymentWidgetState();
}

class _QrPaymentWidgetState extends State<QrPaymentWidget> {
  //late QrPaymentModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String? selectedPaymentType;
  final String cashPaymentNote =
      "*Note that cash payments must be made within 24 hours of the booking date.";
  DateTime datePay = DateTime.now();
  DateTime timePay = DateTime.now();
  late String timePayFormat;
  late String datePayFormat;
  var id = "";
  XFile? _pickedImage;
  String _base64Image = '';

  @override
  void initState() {
    super.initState();
    timePayFormat = DateFormat.Hms().format(timePay);
    datePayFormat = DateFormat('yyyy/MM/dd').format(datePay);
    id = generateRandomId();
  }

  String generateRandomId() {
    final random = Random.secure();
    final values = List<int>.generate(8, (_) => random.nextInt(256));
    final id = base64Url.encode(values);
    return id.substring(0, 8);
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
    }
  }

  Future<void> insertPayXBook(BuildContext cont, String statusPay) async {
    String baseUrl = ConnectionClass.ipUrl;
    String functionName = 'booking';
    String url = '${baseUrl}insertXretrieveBuyBook.php?function=$functionName';
    // payment attribute in database
    String payID = id;
    String userID = widget.userID;
    String payDate = datePayFormat;
    String payTime = timePayFormat;
    String? payOpt = selectedPaymentType;
    String payType = 'Booking';
    String totalPay = widget.tPayFwd.toString();
    String stsPay = statusPay;
    String receiptFile = _base64Image;
    // booking attribute in database
    String dateBook = widget.dateFwd.toString();
    String? startTime = widget.sTime;
    String? endTime = widget.eTime;
    String courtNo = widget.crtFwd;
    String rentRacket = widget.rckFwd;
    String status = 'active';

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'payID': payID,
        'userID': userID,
        'payDate': payDate,
        'payTime': payTime,
        'payOpt': payOpt,
        'payType': payType,
        'totalPay': totalPay,
        'stsPay': stsPay,
        'receiptFile': receiptFile,
        'dateBook': dateBook,
        'startTime': startTime,
        'endTime': endTime,
        'courtNo': courtNo,
        'rentRacket': rentRacket,
        'status': status,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      String email = widget.userID;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SuccessBookPageWidget(userID: email)),
      );
      Fluttertoast.showToast(
        msg: "Payment Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    } else {
      // Registration failed
      Fluttertoast.showToast(
        msg: "Payment failed!",
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
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Text(
                    'Dear Customer\nScan QR on the bellow to proceed \nyour payment and upload your receipt in image.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Rubik',
                      color: color.AppColor.textBlack,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: color.AppColor.home2PageBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/6/6c/Sample_EPC_QR_code.png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Preview Receipt',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Rubik',
                      color: color.AppColor.textBlack,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _pickedImage != null
                      ? Container(
                          height: 200, // Set the desired height
                          width: 200, // Set the desired width
                          child: Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.contain,
                          ),
                        )
                      : const Text('No Image Selected'),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Select Payment Type',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Rubik',
                          color: color.AppColor.textBlack,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio<String>(
                            value: 'QR Payment',
                            groupValue: selectedPaymentType,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentType = value!;
                              });
                            },
                          ),
                          const Text('QR Payment'),
                          const SizedBox(width: 10),
                          Radio<String>(
                            value: 'Cash',
                            groupValue: selectedPaymentType,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentType = value!;
                              });
                            },
                          ),
                          const Text('Cash'),
                        ],
                      ),
                      if (selectedPaymentType == 'Cash')
                        Text(
                          cashPaymentNote,
                          style: TextStyle(
                            color: color.AppColor.gradientRed,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        selectImage();
                      },
                      icon: Icon(
                        Icons.cloud_upload_outlined,
                        color: color.AppColor.textBlack,
                        size: 24,
                      ),
                      label: Text(
                        'UPLOAD HERE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Rubik',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.AppColor.gradientTurquoise,
                        elevation: 3,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if(selectedPaymentType == null){
                          Fluttertoast.showToast(
                            msg: "!Please select the payment type first!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            fontSize: 16.0,
                          );
                        }
                        else if(selectedPaymentType == 'QR Payment' && _base64Image == ''){
                          Fluttertoast.showToast(
                            msg: "Please upload your receipt in image format first to continue.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            fontSize: 16.0,
                          );
                        }
                        else if(selectedPaymentType == 'QR Payment' && _base64Image != ''){
                          insertPayXBook(context, 'Valid');
                        }
                        else{
                          insertPayXBook(context, 'Pending');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.AppColor.gradientTurquoise,
                        elevation: 3,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.normal,
                          color: color.AppColor.textBlack,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String email = widget.userID;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CheckoutBookingWidget(userID: email,
                                      dateFwd: widget.dateFwd, sTime: widget.sTime,
                                      eTime: widget.eTime, crtFwd: widget.crtFwd,
                                      tCourt: widget.tCourt)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.AppColor.gradientTurquoise,
                        elevation: 3,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.normal,
                          color: color.AppColor.textBlack,
                          fontSize: 16,
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
