import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/product/product_edit_screen.dart';
import 'package:admin_review/product/product_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewProductsScreen extends StatefulWidget {
  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  List<MyProduct> _productsList = [];

  bool isLoading = true;

  @override
  void initState() {
    _getAllProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Products'),
      body: SafeArea(
        child: Builder(
          builder: (cxt) => Center(
            child: Container(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _productsList.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: _productsList[index].image != null
                                          ? CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  _productsList[index].image,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  CupertinoActivityIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _productsList[index].name ?? '',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstants.blackColor),
                                        ),

                                        SizedBox(
                                          height: 4,
                                        ),

                                        //rating and likes percentage row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(_productsList[index]
                                                .description),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 4,
                                        ),

                                        Row(
                                          children: [
                                            Text(
                                              _productsList[index].likes ?? '',
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.greyColor),
                                            ),
                                            Text(
                                              ' Likes',
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.greyColor),
                                            ),
                                            SizedBox(
                                              width: 24,
                                            ),
                                            Text(
                                              'RS. ',
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.greyColor),
                                            ),
                                            Text(
                                              _productsList[index].price,
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.greyColor),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 8.0),

                                        Row(
                                          children: [
                                            Icon(Icons.favorite,
                                                color: Colors.red),
                                            SizedBox(width: 4),
                                            Text(
                                              _productsList[index].likes ?? '',
                                              style: TextStyle(
                                                  color:
                                                      ColorConstants.greyColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        //navigate to edit product screen
                                        Navigator.of(context)
                                            .push(new MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductEditScreen(
                                                        _productsList[index])))
                                            .then((value) {
                                          _getAllProducts();
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        margin: EdgeInsets.only(right: 8.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.red[500],
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        child: Center(
                                            child: Text('Edit',
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .redColor))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isLoading,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getAllProducts() {
    _productsList = [];
    fireStoreInstance.collection("products").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        MyProduct obj = MyProduct.fromMap(result.data());
        obj.id = result.id;
        _productsList.add(obj);
      });

      setState(() {
        isLoading = false;
      });
    });

    ///.....................................
    // _productsList.add(ProductsModel(
    //     'assets/images/dish1.jpg', 'Food dish', '5.0', '123', '1200', '100%'));
    // _productsList.add(ProductsModel(
    //     'assets/images/dish2.jpg', 'Food dish', '4.0', '120', '1000', '90%'));
    // _productsList.add(ProductsModel(
    //     'assets/images/dish3.jpg', 'Food dish', '4.5', '150', '2600', '99%'));
    // _productsList.add(ProductsModel(
    //     'assets/images/dish1.jpg', 'Food dish', '4.6', '240', '3400', '80%'));
    // _productsList.add(ProductsModel(
    //     'assets/images/dish2.jpg', 'Food dish', '3.0', '26', '1210', '70%'));
    // _productsList.add(ProductsModel(
    //     'assets/images/dish3.jpg', 'Food dish', '4.2', '30', '2250', '85%'));
    // _productsList.add(ProductsModel(
    //     'assets/images/dish1.jpg', 'Food dish', '5.0', '56', '6100', '89%'));
  }
}
