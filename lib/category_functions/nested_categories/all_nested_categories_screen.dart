import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/model/category_model.dart';
import 'package:admin_review/model/nested_category_model.dart';
import 'package:admin_review/model/second_sub_category_model.dart';
import 'package:admin_review/model/sub_category_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllNestedCategoriesScreen extends StatefulWidget {
  @override
  _AllNestedCategoriesScreenState createState() =>
      _AllNestedCategoriesScreenState();
}

class _AllNestedCategoriesScreenState extends State<AllNestedCategoriesScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;

  CategoryModel categoryModel;
  SubCategoryModel subCategoryModel;
  SecondSubCategoryModel secondSubCategoryModel;

  List<CategoryModel> categoriesList = [];
  List<SubCategoryModel> subCategoriesList = [];
  List<SecondSubCategoryModel> secondSubCategoriesList = [];

  List<List<SubCategoryModel>> allSubCategoriesList = [];

  List<NestedCategoryModel> nestedCategoriesList = [];
  bool isLoading = true;

  @override
  void initState() {
    _getAllNestedCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Nested Categories'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        //itemCount: nestedCategoriesList.length,
                        itemCount: categoriesList.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [

                                    SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: categoriesList[index].image,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              CupertinoActivityIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 16.0,
                                    ),

                                    Text(categoriesList[index].categoryName,
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: subCategoriesList.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  itemBuilder: (BuildContext context,
                                      int subCategoryIndex) {
                                    if (subCategoriesList[subCategoryIndex]
                                            .categoryId ==
                                        categoriesList[index].id) {
                                      return Card(
                                          elevation: 4.0,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [

                                                    SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: subCategoriesList[subCategoryIndex].icon == null ? Container() : ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl: subCategoriesList[subCategoryIndex]?.icon,
                                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                              CupertinoActivityIndicator(),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                        ),
                                                      ),
                                                    ),

                                                    SizedBox(
                                                      width: 8,
                                                    ),

                                                    Text(
                                                      subCategoriesList[
                                                              subCategoryIndex]
                                                          .subCategoryName,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 10,
                                                ),

                                                ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: secondSubCategoriesList.length,
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                                  itemBuilder: (BuildContext context,
                                                      int secSubCategoryIndex) {
                                                    if (secondSubCategoriesList[secSubCategoryIndex]
                                                        .subCategoryId ==
                                                        subCategoriesList[subCategoryIndex].subCategoryId) {
                                                      return Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 12.0),
                                                        child: Row(
                                                          children: [

                                                            Icon(Icons.circle, color: ColorConstants.blackColor, size: 8,),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              secondSubCategoriesList[
                                                              secSubCategoryIndex]
                                                                  .secondSubCategoryName,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      return Container();
                                                    }
                                                  },
                                                ),

                                              ],
                                            ),
                                          ));
                                    } else {
                                      return Container();
                                    }
                                  },
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
    );
  }

  void _getAllNestedCategories() {

    fireStoreInstance.collection("categories").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('category response: ${result.data()}');

        categoryModel = CategoryModel.fromJson(result.data());
        categoriesList.add(categoryModel);

        fireStoreInstance
            .collection("categories")
            .doc(result.id)
            .collection("sub_categories")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result2) {

            print('sub-category response ${result2.data()}');

            subCategoryModel = SubCategoryModel.fromJson(result2.data());
            subCategoriesList.add(subCategoryModel);


            fireStoreInstance
                .collection("categories")
                .doc(result.id)
                .collection("sub_categories")
                .doc(result2.id)
                .collection("second_sub_categories")
                .get()
                .then((querySnapshot) {

              querySnapshot.docs.forEach((result3) {

                //print('second sub result: ${result.data()}');
                print('result 3 id: ${result3.id}');

                secondSubCategoryModel = SecondSubCategoryModel.fromJson(result3.data());
                secondSubCategoriesList.add(secondSubCategoryModel);

              });


            });



          });

          allSubCategoriesList.add(subCategoriesList);


        }).then((value) {

          setState(() {
            isLoading = false;
          });

        });
      });
    });

    /*
    NestedCategoryModel nestedCategoryModel;
    SubCategoryModel subCategoryModel;


    fireStoreInstance.collection("categories").get().then((querySnapshot) {

      querySnapshot.docs.forEach((result) async {

        print('category response: ${result.data()}');

        nestedCategoryModel = NestedCategoryModel();
        categoryModel = CategoryModel.fromJson(result.data());

        nestedCategoryModel.mainCategoryId = categoryModel.id;
        nestedCategoryModel.mainCategoryName = categoryModel.categoryName;
        nestedCategoryModel.mainCategoryImage = categoryModel.image;

        await fireStoreInstance
            .collection("categories")
            .doc(result.id)
            .collection("sub_categories")
            .get()
            .then((querySnapshot) {

              querySnapshot.docs.forEach((result) {

                print('sub-category response: ${result.data()}');
                subCategoryModel = SubCategoryModel.fromJson(result.data());

                nestedCategoryModel.subCategoriesList.add(SubCategoryData(subCategoryId: subCategoryModel.subCategoryId,
                subCategoryName: subCategoryModel.subCategoryName, icon: subCategoryModel.icon));


              });

              nestedCategoriesList.add(nestedCategoryModel);

        }).then((value) {

          setState(() {

          });

        });

      });

    });*/
  }
}
