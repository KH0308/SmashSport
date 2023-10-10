import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:SmashSport/colors.dart' as color;
import 'dart:convert';
import '../connection_class.dart';
import 'categories_product.dart';
import 'chart_x_checkout.dart';
import 'product_details.dart';

class Product {
  final String id;
  final String imageUrl;
  final String name;
  final String category;
  final String price;
  final String rating;

  Product({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
  });
}

class ProductListWidget extends StatefulWidget {
  final String cgyFwd, userID;
  const ProductListWidget({Key? key, required this.cgyFwd, required this.userID}) : super(key: key);

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  //late ProductListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late TextEditingController searchBarController = TextEditingController();
  List<Product> productList = [];
  //String? Function(BuildContext, String?)? searchBarControllerValidator;

  Future<void> fetchProductsByCategory(String category) async {
    // Make an HTTP request to your API endpoint
    // Pass the category as a parameter to retrieve products based on the category
    category = widget.cgyFwd;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getProduct.php?category=$category';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Product> products = [];

      for (var productData in jsonData) {
        final product = Product(
          id: productData['id'],
          imageUrl: productData['imageUrl'],
          name: productData['name'],
          category: productData['category'],
          price: productData['price'],
          rating: productData['rating'],
        );
        products.add(product);
      }

      setState(() {
        productList = products;
      });
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> fetchProductBasedSearch(BuildContext cont) async {
    String pName = searchBarController.text;
    var baseUrl = ConnectionClass.ipUrl;
    final url = '${baseUrl}getProductSearch.php?sProduct=$pName';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<Product> products = [];

      for (var productData in jsonData) {
        final product = Product(
          id: productData['id'],
          imageUrl: productData['imageUrl'],
          name: productData['name'],
          category: productData['category'],
          price: productData['price'],
          rating: productData['rating'],
        );
        products.add(product);
      }

      setState(() {
        productList = products;
      });
    } else {
      // Handle API error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory(widget.cgyFwd); // Replace with your desired category
  }

  @override
  void dispose() {
    //_model.dispose();

    searchBarController.dispose();
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
        appBar: AppBar(
          backgroundColor: color.AppColor.gradientTurquoise,
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
                    builder: (context) => CategoriesProductsWidget(userID: email)),
              );
            },
          ),
          title: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Text(
              widget.cgyFwd,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: color.AppColor.textBlack,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: color.AppColor.iconBlack,
                size: 24,
              ),
              onPressed: () async {
                String email = widget.userID;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutItemWidget(userID: email)),
                );
              },
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 8, 0),
                child: TextFormField(
                  controller: searchBarController,
                  textCapitalization: TextCapitalization.words,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Search for your shoes...',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: color.AppColor.textBlack,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: color.AppColor.textBlack,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: color.AppColor.iconBlack,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: color.AppColor.iconBlack,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: color.AppColor.gradientRed,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: color.AppColor.gradientRed,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: color.AppColor.homePageBackground,
                    contentPadding:
                    const EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                    prefixIcon: Icon(
                      Icons.search,
                      color: color.AppColor.iconBlack,
                      size: 16,
                    ),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: color.AppColor.textBlack,
                  ),
                  //validator: searchBarControllerValidator.asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 12, 0),
                child: IconButton(
                  icon: Icon(
                    Icons.search_sharp,
                    color: color.AppColor.iconBlack,
                    size: 30,
                  ),
                  onPressed: () {
                    fetchProductBasedSearch(context);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: productList.isEmpty
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      final product = productList[index];
                      return GestureDetector(
                        onTap: () async {
                          String email = widget.userID;
                          String category = widget.cgyFwd;
                          // Navigate to the next page and pass the selected product's name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsWidget(userID: email, cgyFwd: category, prdID: product.id),
                            ),
                          );
                        },
                        child: ProductWidget(
                          product: product,
                        ),
                      );
                    },
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

class ProductWidget extends StatelessWidget {
  final Product product;

  const ProductWidget({super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Customize the appearance of the product item
      child: Column(
        children: [
          Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            height: 150,
          ),
          Text(product.name),
          Text(product.category),
          Text(product.price),
          Text('Rating: ${product.rating.toString()}'),
        ],
      ),
    );
  }
}