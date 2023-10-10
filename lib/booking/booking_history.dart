import 'package:flutter/material.dart';
import 'package:SmashSport/colors.dart' as color;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../home_page_new.dart';
import '../connection_class.dart';
import 'booking_history_details.dart';

class ListBooking {
  final String payID;
  final String idUser;
  final String payDate;
  final String payTime;
  final String payOption;
  final String payStatus;
  final double totalPay;
  final String receipt;

  ListBooking({
    required this.payID,
    required this.idUser,
    required this.payDate,
    required this.payTime,
    required this.payOption,
    required this.payStatus,
    required this.totalPay,
    required this.receipt,
  });
}

class ListBookingWidget extends StatefulWidget {
  final String userID;
  const ListBookingWidget({Key? key, required this.userID}) : super(key: key);

  @override
  State<ListBookingWidget> createState() => _ListBookingWidgetState();
}

class _ListBookingWidgetState extends State<ListBookingWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<ListBooking> listBooking = [];

  @override
  void initState() {
    super.initState();
    fetchListPurchase(); // Fetch cart items when the page loads
  }

  Future<void> fetchListPurchase() async {
    String id = widget.userID;
    String functionName = 'retrieve';
    String typeData = 'Booking';
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}insertXretrieveBuyBook.php?function=$functionName&userID=$id&payType=$typeData';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final cartData = json.decode(response.body);
      final List<ListBooking> items = [];

      // Convert cartData into CartItem objects
      for (var itemData in cartData) {
        ListBooking item = ListBooking(
          payID: itemData['payID'],
          idUser: itemData['userID'],
          payDate: itemData['payDate'],
          payTime: itemData['payTime'],
          payOption: itemData['payOpt'],
          payStatus: itemData['stsPay'],
          totalPay: double.parse(itemData['totalPay']),
          receipt: itemData['receiptFile'],
        );
        items.add(item);
      }

      setState(() {
        listBooking = items;
      });
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
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
          title: Text(
              'Booking Transaction',
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
                        'Below are the list transaction for your booking',
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
                      child: listBooking.isEmpty
                          ? const Center(
                        child: Text('Purchase is empty.'),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listBooking.length,
                        itemBuilder: (context, index) {
                          final listBook = listBooking[index];
                          return WidgetLB(
                            lBook: listBook,
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

class WidgetLB extends StatelessWidget {
  final ListBooking lBook;

  const WidgetLB({
    super.key,
    required this.lBook,
  });

  @override
  Widget build(BuildContext context) {
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
                        lBook.payDate,
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
                        lBook.payID,
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
                        'Time: ${lBook.payTime}',
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
                        'Pay Option: ${lBook.payOption}',
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
                        'Pay Status: ${lBook.payStatus}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Text(
                        'Total Pay: ${lBook.totalPay.toStringAsFixed(2)}',
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
                String email = lBook.idUser;
                String paymentID = lBook.payID;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListBookingDetailsWidget(
                        userID: email, payID: paymentID),
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