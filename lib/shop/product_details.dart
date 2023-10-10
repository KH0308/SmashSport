import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:SmashSport/colors.dart' as color;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../connection_class.dart';
import 'chart_x_checkout.dart';
import 'product_list.dart';
import '../home_page_new.dart';

class ProductDetailsWidget extends StatefulWidget {
  final String userID, cgyFwd, prdID;
  const ProductDetailsWidget(
      {Key? key,
      required this.userID,
      required this.prdID,
      required this.cgyFwd})
      : super(key: key);

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  //late ProductDetailsModel _model;
  late int _countValue;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String? dropDownColor, dropDownSize;
  String? selectColor;
  String? selectSize;
  List colorName = [];
  List sizeName = [];
  late String id = '';
  late String name = '';
  late String category = '';
  late String description = '';
  late String price = '';
  late String rating = '';
  late String imageUrl = '';
  bool success = false;
  String idPrd = '';

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
    _countValue = 1;
    // Retrieving data from the database
    retrieveColorOptionsFromDatabase();
    retrieveSizeOptionsFromDatabase();
  }

  Future<void> fetchProductDetail() async {
    // Make an HTTP request to your API endpoint
    // Pass the category as a parameter to retrieve products based on the category
    idPrd = widget.prdID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getPrdDtl.php?idPrd=$idPrd';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      //final List<ProductDetail> products = [];

      if (jsonData.isNotEmpty) {
        setState(() {
          id = jsonData[0]['id'];
          name = jsonData[0]['name'];
          category = jsonData[0]['category'];
          description = jsonData[0]['description'];
          price = jsonData[0]['price'];
          rating = jsonData[0]['rating'];
          imageUrl = jsonData[0]['imageUrl'];
        });
      }
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> retrieveColorOptionsFromDatabase() async {
    idPrd = widget.prdID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getClr.php?idPrd=$idPrd';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ensure data is a list and then assign it to colorName
      if (data is List) {
        setState(() {
          colorName = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // Handle the case where data is not a list
        print('Error: Data is not a list');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> retrieveSizeOptionsFromDatabase() async {
    idPrd = widget.prdID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getSize.php?idPrd=$idPrd';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Ensure data is a list and then assign it to sizeName
      if (data is List) {
        setState(() {
          sizeName = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // Handle the case where data is not a list
        print('Error: Data is not a list');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<bool> _fetchItemToCart() async {
    String baseUrl = ConnectionClass.ipUrl;
    String url = '${baseUrl}cart.php';
    String email = widget.userID;
    String pId = widget.prdID;
    String pName = name;
    String img = imageUrl;
    String qty = _countValue.toString();
    String prc = price;
    String? clr = selectColor;
    String? size = selectSize;
    //final BuildContext context = cont;

    // Send registration data to the server
    var response = await http.post(
      Uri.parse(url),
      body: {
        'userID': email,
        'prdID': pId,
        'prdName': pName,
        'prdImage': img,
        'prdQty': qty,
        'prdPrc': prc,
        'prdClr': clr,
        'prdSize': size,
      },
    );

    // Handle the response from the server
    if (response.statusCode == 200) {
      success = true;
    } else {
      success = false;
    }
    return success;
  }

  /*void _updateCount(int count) {
    setState(() {
      _countValue = count;
    });
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
        backgroundColor: color.AppColor.home2PageBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 500,
                      child: Stack(
                        alignment: const AlignmentDirectional(0, 0),
                        children: [
                          imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : const CircularProgressIndicator(),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 20, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: const AlignmentDirectional(
                                          0.85, -0.4),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 50, 0, 0),
                                        child: IconButton(
                                          onPressed: () async {
                                            String email = widget.userID;
                                            String category = widget.cgyFwd;
                                            // Navigate to the next page and pass the selected product's name
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductListWidget(
                                                        userID: email,
                                                        cgyFwd: category),
                                              ),
                                            );
                                          },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          padding: const EdgeInsets.all(0),
                                          iconSize: 40,
                                          constraints: BoxConstraints.tight(
                                              const Size(40, 40)),
                                          color: color.AppColor.iconBlack,
                                          icon: Icon(
                                            Icons.chevron_left_rounded,
                                            color: color.AppColor.iconBlack,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: const AlignmentDirectional(
                                          0.85, -0.4),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 50, 0, 0),
                                        child: IconButton(
                                          onPressed: () async {
                                            String email = widget.userID;
                                            // Navigate to the next page and pass the selected product's name
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckoutItemWidget(
                                                        userID: email),
                                              ),
                                            );
                                          },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          padding: const EdgeInsets.all(0),
                                          iconSize: 40,
                                          constraints: BoxConstraints.tight(
                                              const Size(40, 40)),
                                          color: color.AppColor.iconBlack,
                                          icon: Icon(
                                            Icons.shopping_cart_outlined,
                                            color: color.AppColor.iconBlack,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 7,
                                    sigmaY: 6,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: const BoxDecoration(
                                      color: Color(0x31000000),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24, 20, 0, 0),
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Rubik',
                                                color: color.AppColor
                                                    .homePageBackground,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(24, 8, 24, 0),
                                            child: Text(
                                              description,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Rubik',
                                                color: color.AppColor.textBlack,
                                              ),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RM$price',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Rubik',
                              color: color.AppColor.textBlack,
                            ),
                          ),
                          Container(
                            width: 156,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color.AppColor.home2PageBackground,
                              borderRadius: BorderRadius.circular(25),
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: color.AppColor.gradientTurquoise,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_countValue > 1) {
                                        _countValue--;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.minus,
                                    color: _countValue > 1
                                        ? color.AppColor.textGray
                                        : const Color(0xFFE0E3E7),
                                    size: 20,
                                  ),
                                ),
                                Text(
                                  _countValue.toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_countValue < 10) {
                                        _countValue++;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.plus,
                                    color: _countValue < 10
                                        ? color.AppColor.textBlack
                                        : const Color(0xFFE0E3E7),
                                    size: 20,
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
                          const EdgeInsetsDirectional.fromSTEB(24, 8, 0, 0),
                      child: Text(
                        'Options',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 5, 0, 0),
                      child: Text(
                        'Please make a selection from the options below.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: color.AppColor.textBlack,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 6, 0),
                              child: colorName.isEmpty
                                  ? Text(
                                'No Stock',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Rubik',
                                  color: color.AppColor.textBlack,
                                ),
                              )
                                  : DropdownButton(
                                value: selectColor,
                                hint: Text(
                                  'Select a Color',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: color.AppColor.textGray,
                                  size: 15,
                                ),
                                iconSize: 24,
                                elevation: 2,
                                underline: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: color.AppColor.gradientTurquoise,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                isDense: true,
                                items: colorName.map((colorsPrd) {
                                  return DropdownMenuItem<String>(
                                    value: colorsPrd['color'],
                                    child: Text(colorsPrd['color']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectColor = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(6, 12, 0, 0),
                              child: sizeName.isEmpty
                                  ? Text(
                                'No Stock',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Rubik',
                                  color: color.AppColor.textBlack,
                                ),
                              )
                                  : DropdownButton(
                                value: selectSize,
                                hint: Text(
                                  'Select a Size',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: color.AppColor.textGray,
                                  size: 15,
                                ),
                                iconSize: 24,
                                elevation: 2,
                                underline: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: color.AppColor.gradientTurquoise,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                isDense: true,
                                items: sizeName.map((sizesPrd) {
                                  return DropdownMenuItem<String>(
                                    value: sizesPrd['size'],
                                    child: Text(sizesPrd['size']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectSize = value!;
                                  });
                                },
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
            GestureDetector(
              onTap: () async {
                final isColorEmpty = selectColor?.isEmpty ?? true;
                final isSizeEmpty = selectSize?.isEmpty ?? true;

                if((isColorEmpty || isSizeEmpty)){
                  Fluttertoast.showToast(
                    msg: "Please select both size and color or the item is out of stock.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    fontSize: 16.0,
                  );
                }
                else{
                  _fetchItemToCart();
                  //bool result = await _fetchItemToCart();
                  if (success = true) {
                    // Task was successful, handle success case
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Item added to cart.'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                String email = widget.userID;
                                Navigator.push(
                                  dialogContext,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CheckoutItemWidget(userID: email),
                                  ),
                                );
                              },
                              child: const Text('View Cart'),
                            ),
                            TextButton(
                              onPressed: () async {
                                String email = widget.userID;
                                Navigator.push(
                                  dialogContext,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomePageWidget(userID: email),
                                  ),
                                );
                              },
                              child: const Text('Go Home'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Task failed, handle failure case
                    Fluttertoast.showToast(
                      msg: "Add to cart failed!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      fontSize: 16.0,
                    );
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: color.AppColor.gradientTurquoise,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color(0x411D2429),
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Add To Bag',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Rubik',
                          color: color.AppColor.textBlack,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          '$_countValue Item',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Rubik',
                            color: color.AppColor.textBlack,
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
    );
  }
}
