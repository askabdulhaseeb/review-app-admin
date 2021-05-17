import 'package:admin_review/category_functions/sub_category/edit_sub_category_screen.dart';
import 'package:admin_review/model/sub_category_model.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllSubCategoriesScreen extends StatefulWidget {
  @override
  _AllSubCategoriesScreenState createState() => _AllSubCategoriesScreenState();
}

class _AllSubCategoriesScreenState extends State<AllSubCategoriesScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  List<SubCategoryModel> subCategoriesList = [];

  Dialog deleteConfirmationDialog;

  bool isLoading = true;

  @override
  void initState() {
    _getAllSubCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Sub Categories'),
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
                          itemCount: subCategoriesList.length,
                          shrinkWrap: true,
                          primary: false,
                          padding: EdgeInsets.all(16.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: subCategoriesList[index].icon == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 120,
                                            height: 120,
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.grey[800],
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  subCategoriesList[index].icon,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  CupertinoActivityIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subCategoriesList[index]
                                              .subCategoryName
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 20,
                                            color: ColorConstants.blackColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.green),
                                                onPressed: () {
                                                  //navigate to edit sub-category screen
                                                  Navigator.of(context).push(
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditSubCategoryScreen(
                                                                  subCategoryObj:
                                                                      subCategoriesList[
                                                                          index])));
                                                },
                                                child: new Text("Edit",
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .whiteColor)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: ColorConstants
                                                        .redColor),
                                                onPressed: () {
                                                  deleteConfirmationDialog =
                                                      Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12.0)), //this right here
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              2.5,
                                                      //margin: EdgeInsets.all(16),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'Delete Confirmation',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Quicksand',
                                                                    fontSize:
                                                                        26,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16.0,
                                                                      vertical:
                                                                          56.0),
                                                              child: Text(
                                                                'Are you sure want to delete this sub-category ?',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Quicksand',
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              Colors.blue),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);

                                                                    //delete record from fire store database
                                                                    _deleteCategory(
                                                                        cxt,
                                                                        subCategoriesList[index]
                                                                            .categoryId,
                                                                        subCategoriesList[index]
                                                                            .subCategoryId);
                                                                  },
                                                                  child: new Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                          color:
                                                                              ColorConstants.whiteColor)),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              ColorConstants.redColor),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: new Text(
                                                                      "No",
                                                                      style: TextStyle(
                                                                          color:
                                                                              ColorConstants.whiteColor)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );

                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          deleteConfirmationDialog);
                                                },
                                                child: new Text("Delete",
                                                    style: TextStyle(
                                                        color: ColorConstants
                                                            .whiteColor)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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

  void _getAllSubCategories() {
    SubCategoryModel subCategoryModel;

    /*fireStoreInstance.collection("categories").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());

        categoryModel = CategoryModel.fromJson(result.data());
        categoriesList.add(categoryModel);
      });

      setState(() {
        isLoading = false;
      });

    });*/

    fireStoreInstance.collection("categories").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        fireStoreInstance
            .collection("categories")
            .doc(result.id)
            .collection("sub_categories")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            print(result.data());

            subCategoryModel = SubCategoryModel.fromJson(result.data());
            subCategoriesList.add(subCategoryModel);
          });

          setState(() {
            isLoading = false;
          });
        });
      });
    });
  }

  void _deleteCategory(
      BuildContext cxt, String categoryId, String subCategoryId) {
    setState(() {
      isLoading = true;
    });

    fireStoreInstance
        .collection("categories")
        .doc(categoryId)
        .collection("sub_categories")
        .doc(subCategoryId)
        .delete()
        .then((_) {
      deleteCategoryItemFromList(subCategoryId);
      Utils.displaySnackBar(cxt, 'Sub-Category deleted !', 2);
      print("success!");
    });
  }

  deleteCategoryItemFromList(String id) {
    int keyIndex = -1;
    for (int i = 0; i < subCategoriesList.length; i++) {
      if (subCategoriesList[i].subCategoryId == id) {
        keyIndex = i;
      }
    }

    if (keyIndex != -1) subCategoriesList.removeAt(keyIndex);

    setState(() {
      isLoading = false;
    });
  }
}
