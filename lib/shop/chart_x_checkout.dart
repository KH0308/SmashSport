import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:SmashSport/colors.dart' as color;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../connection_class.dart';
import 'product_details.dart';
import 'categories_product.dart';
import 'pay_item.dart';

class CartItem {
  final String idCart;
  final String idUser;
  final String productID;
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;
  final String color;
  final String size;
  final double totalPrice;
  final String category;

  CartItem({
    required this.idCart,
    required this.idUser,
    required this.productID,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.color,
    required this.size,
    required this.totalPrice,
    required this.category,
  });
}

typedef FetchListPurchaseItemCallback = Future<void> Function();

class CheckoutItemWidget extends StatefulWidget {
  final String userID;
  const CheckoutItemWidget({Key? key, required this.userID}) : super(key: key);

  @override
  State<CheckoutItemWidget> createState() => _CheckoutItemWidgetState();
}

class _CheckoutItemWidgetState extends State<CheckoutItemWidget> {
  //late CheckoutItemModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List<CartItem> cartItemList = []; // List to hold cart items
  double totalCartPriceState = 0.0;
  double taxes = 0.06;
  double totalAll = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems(); // Fetch cart items when the page loads
  }

  Future<void> fetchCartItems() async {
    String id = widget.userID;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getItmCart.php?userID=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final cartData = json.decode(response.body);
      final List<CartItem> items = [];
      double totalCartPrice = 0;

      // Convert cartData into CartItem objects
      for (var itemData in cartData) {
        CartItem item = CartItem(
          idCart: itemData['id'],
          idUser: itemData['userID'],
          productID: itemData['prdID'],
          name: itemData['prdName'],
          imageUrl: itemData['prdImage'],
          quantity: int.parse(itemData['prdQty']),
          price: double.parse(itemData['prdPrc']),
          color: itemData['prdClr'],
          size: itemData['prdSize'],
          totalPrice: double.parse(itemData['totalPrcItm']),
          category: itemData['category'],
        );
        items.add(item);

        // Add the item's total price to the totalCartPrice
        totalCartPrice += double.parse(itemData['totalPrcItm']);
      }

      setState(() {
        cartItemList = items;
        // Assign the totalCartPrice to a variable in your state
        totalCartPriceState = totalCartPrice;
      });
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Timer(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        return const SimpleDialog(
          title: Text('Information'),
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Total value after includes taxes'),
            ),
          ],
        );
      },
    );
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
    totalAll = ((totalCartPriceState * taxes) + totalCartPriceState);

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
                  builder: (context) => CategoriesProductsWidget(userID: email),
                ),
              );
            },
          ),
          title: Align(
            alignment: const AlignmentDirectional(-0.2, 0),
            child: Text(
              'My Cart',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                fontFamily: 'Rubik',
                color: color.AppColor.textBlack,
              ),
            ),
          ),
          actions: const [],
          centerTitle: false,
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
                        'Below are the items in your cart.',
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
                      child: cartItemList.isEmpty
                          ? const Center(
                              child: Text('Cart is empty.'),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: cartItemList.length,
                              itemBuilder: (context, index) {
                                final cart = cartItemList[index];
                                return CartWidget(
                                  cartItem: cart,
                                  fetchListPurchaseItem: fetchCartItems,
                                );
                              },
                            ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 16, 24, 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Price Breakdown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 8, 24, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Base Price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                                Text(
                                  '$totalCartPriceState',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 8, 24, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Taxes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                                Text(
                                  '6%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: color.AppColor.textBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 4, 24, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: color.AppColor.textBlack,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.info_outlined,
                                        color: color.AppColor.iconBlack,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        showInfoDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  '$totalAll',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    fontFamily: 'Rubik',
                                    color: color.AppColor.textBlack,
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
            GestureDetector(
              onTap: () async {
                String email = widget.userID;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PayItemWidget(userID: email, tPayFwd: totalAll)),
                );
              },
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: color.AppColor.gradientTurquoise,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x320E151B),
                      offset: Offset(0, -2),
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                alignment: const AlignmentDirectional(0, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                  child: Text(
                    'Checkout ($totalAll)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: 'Rubik',
                      color: color.AppColor.textBlack,
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

class CartWidget extends StatelessWidget {
  final CartItem cartItem;
  final FetchListPurchaseItemCallback fetchListPurchaseItem;

  const CartWidget({
    super.key,
    required this.cartItem,
    required this.fetchListPurchaseItem,
  });

  Future<void> delItmCart(BuildContext context) async {
    String id = cartItem.idCart;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}delCart.php?cartID=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Successful response
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["success"] == true) {
        // Record deleted successfully
        Fluttertoast.showToast(
          msg: "Item has been delete",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        ).then((value) {
          // Fetch the updated list after the toast is shown
          fetchListPurchaseItem();
        });
      } else {
        // Error deleting record
        Fluttertoast.showToast(
          msg: "Error deleting record: ${jsonResponse["message"]}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
    } else {
      // Error accessing the API
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    //String qty = cartItem.quantity.toString();
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
              child: Image.network(
                cartItem.imageUrl,
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
                        cartItem.name,
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
                        'Price: ${cartItem.price}',
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
                        'Quantity: ${cartItem.quantity}',
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
                        'Color: ${cartItem.color}',
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
                        'Size: ${cartItem.size}',
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
            IconButton(
              icon: Icon(
                Icons.edit_outlined,
                color: color.AppColor.textGray,
                size: 20,
              ),
              onPressed: () async {
                String email = cartItem.idUser;
                String cgy = cartItem.category;
                String idPrd = cartItem.productID;
                // Navigate to the next page and pass the selected product's name
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsWidget(
                        userID: email, cgyFwd: cgy, prdID: idPrd),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: color.AppColor.gradientRed,
                size: 20,
              ),
              onPressed: () {
                delItmCart(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
