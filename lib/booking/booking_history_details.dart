import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:SmashSport/colors.dart' as color;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booking_history.dart';
import '../connection_class.dart';

class ListBookingDetails {
  final String bookID;
  final String idUser;
  final String dateBook;
  final String startTime;
  final String endTime;
  final String courtNo;
  final String rentRacket;
  final String idPay;
  final String status;

  ListBookingDetails({
    required this.bookID,
    required this.idUser,
    required this.dateBook,
    required this.startTime,
    required this.endTime,
    required this.courtNo,
    required this.rentRacket,
    required this.idPay,
    required this.status,
  });
}

typedef FetchListPurchaseItemCallback = Future<void> Function();

class ListBookingDetailsWidget extends StatefulWidget {
  final String userID, payID;
  const ListBookingDetailsWidget(
      {Key? key, required this.userID, required this.payID})
      : super(key: key);

  @override
  State<ListBookingDetailsWidget> createState() =>
      _ListBookingDetailsWidgetState();
}

class _ListBookingDetailsWidgetState extends State<ListBookingDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<ListBookingDetails> listBookingDetails = [];
  //final StreamController<List<ListBookingDetails>> _bookingDetailsController = StreamController<List<ListBookingDetails>>();

  @override
  void initState() {
    super.initState();
    fetchListPurchaseItem(); // Fetch cart items when the page loads
  }

  Future<void> fetchListPurchaseItem() async {
    String id = widget.userID;
    String functionName = 'listBooking';
    String idPay = widget.payID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}retrieveListPurchaseXBooking.php?function=$functionName&userID=$id&payID=$idPay';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final cartData = json.decode(response.body);
      final List<ListBookingDetails> items = [];

      // Convert cartData into CartItem objects
      for (var itemData in cartData) {
        ListBookingDetails item = ListBookingDetails(
          bookID: itemData['bookID'].toString(),
          idUser: itemData['userID'],
          dateBook: itemData['dateBook'],
          startTime: itemData['startTime'],
          endTime: itemData['endTime'],
          courtNo: itemData['courtNo'],
          rentRacket: itemData['rentRacket'],
          idPay: itemData['payID'],
          status: itemData['status'],
        );
        items.add(item);
      }

      setState(() {
        listBookingDetails = items;
        //_bookingDetailsController.add(items);
      });
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    //_model.dispose();
    //_bookingDetailsController.close();
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
                  builder: (context) => ListBookingWidget(userID: email),
                ),
              );
            },
          ),
          title: Text(
            'Booking List',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              fontFamily: 'Rubik',
              color: color.AppColor.textBlack,
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
                        'Below are the details for your booking',
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
                      child: listBookingDetails.isEmpty
                          ? const Center(
                              child: Text('Booking in process cancellation.'),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listBookingDetails.length,
                              itemBuilder: (context, index) {
                                final listBookDtl = listBookingDetails[index];
                                return WidgetLBD(
                                  lBookingDtl: listBookDtl,
                                  fetchListPurchaseItem: fetchListPurchaseItem,
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

class WidgetLBD extends StatelessWidget {
  final ListBookingDetails lBookingDtl;
  final FetchListPurchaseItemCallback fetchListPurchaseItem;

  const WidgetLBD({
    super.key,
    required this.lBookingDtl,
    required this.fetchListPurchaseItem,
  });

  Future<void> delBooking(BuildContext context) async {
    String id = lBookingDtl.bookID;
    String status = 'cancel';
    String function = 'updateBookingStatus';
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}retrieveListPurchaseXBooking.php';

    final response = await http.post(Uri.parse(url), body: {
      'function': function,
      'bookingID': id,
      'status': status,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["message"] != null) {
        Fluttertoast.showToast(
          msg: "Cancellation request has been send",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        ).then((value) {
          // Fetch the updated list after the toast is shown
          fetchListPurchaseItem();
          Navigator.of(context).pop();
        });
      } else {
        Fluttertoast.showToast(
          msg: "Error updating booking status: ${jsonResponse["respond"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
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
              child: Image.asset(
                'assets/images/appointment.png',
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
                        lBookingDtl.dateBook,
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
                        'Start: ${lBookingDtl.startTime}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'End: ${lBookingDtl.endTime}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                      child: Text(
                        'Court: ${lBookingDtl.courtNo}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Text(
                        'Rental Racket: ${lBookingDtl.rentRacket}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Cancellation Booking'),
                      content: const Text(
                          'Are you sure you want to cancel this booking?'),
                      actions: [
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: color.AppColor.gradientRed,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: color.AppColor.gradientTurquoise,
                            ),
                          ),
                          onPressed: () async {
                            // Perform cancellation logic here
                            delBooking(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Image.asset('assets/images/cancel_book.png'),
            ),
          ],
        ),
      ),
    );
  }
}
