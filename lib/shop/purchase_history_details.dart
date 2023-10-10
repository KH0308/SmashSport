import 'package:flutter/material.dart';
import 'package:SmashSport/colors.dart' as color;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'purchase_history.dart';
import '../connection_class.dart';

class ListPurchaseDetails {
  final String buyID;
  final String idUser;
  final String prdID;
  final String prdClr;
  final String prdSize;
  final String prdQty;
  final String idPay;
  final String prdName;
  final String prdImg;
  final double prdPrc;

  ListPurchaseDetails({
    required this.buyID,
    required this.idUser,
    required this.prdID,
    required this.prdClr,
    required this.prdSize,
    required this.prdQty,
    required this.idPay,
    required this.prdName,
    required this.prdImg,
    required this.prdPrc,
  });
}

class ListPurchaseDetailsWidget extends StatefulWidget {
  final String userID, payID;
  const ListPurchaseDetailsWidget({Key? key, required this.userID, required this.payID}) : super(key: key);

  @override
  State<ListPurchaseDetailsWidget> createState() => _ListPurchaseDetailsWidgetState();
}

class _ListPurchaseDetailsWidgetState extends State<ListPurchaseDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<ListPurchaseDetails> listPurchaseDetails = [];
  //retrieveListPurchaseXBooking.php

  @override
  void initState() {
    super.initState();
    fetchListPurchaseItem(); // Fetch cart items when the page loads
  }

  Future<void> fetchListPurchaseItem() async {
    String id = widget.userID;
    String functionName = 'listPurchase';
    String idPay = widget.payID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}retrieveListPurchaseXBooking.php?function=$functionName&userID=$id&payID=$idPay';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final cartData = json.decode(response.body);
      final List<ListPurchaseDetails> items = [];

      // Convert cartData into CartItem objects
      for (var itemData in cartData) {
        ListPurchaseDetails item = ListPurchaseDetails(
          buyID: itemData['buyID'].toString(),
          idUser: itemData['userID'],
          prdID: itemData['prdID'].toString(),
          prdClr: itemData['prdClr'],
          prdSize: itemData['prdSize'],
          prdQty: itemData['prdQty'].toString(),
          idPay: itemData['payID'],
          prdName: itemData['Name'],
          prdImg: itemData['Image'],
          prdPrc: double.parse(itemData['Price']),
        );
        items.add(item);
      }

      setState(() {
        listPurchaseDetails = items;
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
                  builder: (context) => ListPurchaseWidget(userID: email),
                ),
              );
            },
          ),
          title: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Text(
              'Purchased List Item',
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
                        'Below are the list item for your purchased',
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
                      child: listPurchaseDetails.isEmpty
                          ? const Center(
                        child: Text('Purchase item is empty.'),
                      )
                          : ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listPurchaseDetails.length,
                        itemBuilder: (context, index) {
                          final listPchDtl = listPurchaseDetails[index];
                          return WidgetLPD(
                            lPurchaseDtl: listPchDtl,
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

class WidgetLPD extends StatelessWidget {
  final ListPurchaseDetails lPurchaseDtl;

  const WidgetLPD({
    super.key,
    required this.lPurchaseDtl,
  });

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
              child: Image.network(
                lPurchaseDtl.prdImg,
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
                        lPurchaseDtl.prdName,
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
                        'Product ID: ${lPurchaseDtl.prdID}',
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
                        'Color: ${lPurchaseDtl.prdClr}',
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
                        'Size: ${lPurchaseDtl.prdSize}',
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
                        'Quantity: ${lPurchaseDtl.prdQty}',
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
            Text(
              'RM ${lPurchaseDtl.prdPrc.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'Poppins',
                color: color.AppColor.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}