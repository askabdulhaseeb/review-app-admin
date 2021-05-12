import 'package:admin_review/category_functions/main_category/edit_main_category_screen.dart';
import 'package:admin_review/category_functions/second_sub_category/edit_second_sub_category_screen.dart';
import 'package:admin_review/category_functions/sub_category/edit_sub_category_screen.dart';
import 'package:admin_review/model/second_sub_category_model.dart';
import 'package:admin_review/model/sub_category_model.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/model/category_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';


class AllSecondSubCategoriesScreen extends StatefulWidget {
  @override
  _AllSecondSubCategoriesScreenState createState() =>
      _AllSecondSubCategoriesScreenState();
}

class _AllSecondSubCategoriesScreenState extends State<AllSecondSubCategoriesScreen> {

  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<SecondSubCategoryModel> secondSubCategoriesList = [];

  Dialog deleteConfirmationDialog;

  bool isLoading = true;

  @override
  void initState() {
    _getAllSecondSubCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Second Sub Categories'),
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
                          itemCount: secondSubCategoriesList.length,
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
                                    child: secondSubCategoriesList[index].icon == null ? Container(
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
                                    ) : ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: secondSubCategoriesList[index].icon,
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CupertinoActivityIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          secondSubCategoriesList[index]
                                              .secondSubCategoryName
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 20,
                                            color: ColorConstants.blackColor,
                                          ),
                                        ),

                                        /*
                                        SizedBox(
                                          height: 4,
                                        ),

                                        Text(
                                          secondSubCategoriesList[index]
                                              .categoryName
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 14,
                                            color: ColorConstants.blackColor,
                                          ),
                                        ),


                                        SizedBox(
                                          height: 4,
                                        ),

                                        Text(
                                          secondSubCategoriesList[index]
                                              .subCategoryName
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: 14,
                                            color: ColorConstants.blackColor,
                                          ),
                                        ),*/

                                        SizedBox(
                                          height: 10,
                                        ),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: RaisedButton(
                                                color: Colors.green,
                                                onPressed: () {

                                                  //navigate to edit second sub-category screen
                                                  Navigator.of(context)
                                                      .push(new MaterialPageRoute(builder: (context) =>
                                                        EditSecondSubCategoryScreen(secondSubCategoryObj: secondSubCategoriesList[index])));

                                                },
                                                child: new Text("Edit",
                                                    style: TextStyle(
                                                        color: ColorConstants.whiteColor)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: RaisedButton(
                                                color: ColorConstants.redColor,
                                                onPressed: () {

                                                  deleteConfirmationDialog = Dialog(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width,
                                                      height: MediaQuery.of(context).size.height / 2.5,
                                                      //margin: EdgeInsets.all(16),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          children: <Widget>[

                                                            SizedBox(
                                                              height: 16,
                                                            ),

                                                            Padding(
                                                              padding:  EdgeInsets.all(8.0),
                                                              child: Text('Delete Confirmation', style: TextStyle(fontFamily: 'Quicksand', fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 56.0),
                                                              child: Text('Are you sure want to delete second sub-category ?',
                                                                style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'Quicksand',), textAlign: TextAlign.center, ),
                                                            ),

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                RaisedButton(
                                                                  color: Colors.blue,
                                                                  onPressed: () {

                                                                    Navigator.pop(context);

                                                                    //delete record from fire store database
                                                                    _deleteCategory(cxt, secondSubCategoriesList[index]);

                                                                  },
                                                                  child: new Text("Yes",
                                                                      style: TextStyle(
                                                                          color: ColorConstants.whiteColor)),
                                                                ),
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                RaisedButton(
                                                                  color: ColorConstants.redColor,
                                                                  onPressed: () {

                                                                    Navigator.pop(context);

                                                                  },
                                                                  child: new Text("No",
                                                                      style: TextStyle(
                                                                          color: ColorConstants.whiteColor)),
                                                                ),
                                                              ],
                                                            ),



                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );

                                                  showDialog(context: context, builder: (BuildContext context) => deleteConfirmationDialog);


                                                },
                                                child: new Text("Delete",
                                                    style: TextStyle(
                                                        color: ColorConstants.whiteColor)),
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

  void _getAllSecondSubCategories() {

    CategoryModel categoryModel;
    SubCategoryModel subCategoryModel;
    SecondSubCategoryModel secondSubCategoryModel;

    fireStoreInstance.collection("categories").get().then((querySnapshot) {

      querySnapshot.docs.forEach((result) {

        print('result 1 id: ${result.id}');
        categoryModel = CategoryModel.fromJson(result.data());

        fireStoreInstance
            .collection("categories")
            .doc(result.id)
            .collection("sub_categories")
            .get()
            .then((querySnapshot) {

              querySnapshot.docs.forEach((result2) {

                //print('result2: ${result.data()}');

                print('result 2 id: ${result2.id}');
                subCategoryModel = SubCategoryModel.fromJson(result2.data());


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

                        setState(() {
                          isLoading = false;
                        });

                });



              });


        });




      });



    });




  }

  void _deleteCategory(BuildContext cxt, SecondSubCategoryModel secondSubCategoryModel) {

    setState(() {
      isLoading = true;
    });

    fireStoreInstance.collection("categories")
        .doc(secondSubCategoryModel.categoryId)
        .collection("sub_categories")
        .doc(secondSubCategoryModel.subCategoryId)
        .collection("second_sub_categories")
        .doc(secondSubCategoryModel.secondSubCategoryId)
        .delete().then((_) {

          deleteCategoryItemFromList(secondSubCategoryModel.secondSubCategoryId);
          Utils.displaySnackBar(cxt, 'Second Sub-Category deleted !', 2);
          print("success!");


    });




  }

  _deleteImageFromFirebaseStorage(String imageURL) async {

    //delete image from firebase storage
    if (imageURL != null) {



    }

  }


  deleteCategoryItemFromList(String id) {
    int keyIndex = -1;
    for(int i=0; i<secondSubCategoriesList.length; i++) {

      if(secondSubCategoriesList[i].subCategoryId == id) {
        keyIndex = i;
      }
    }

    if(keyIndex != -1)
      secondSubCategoriesList.removeAt(keyIndex);

    setState(() {
      isLoading = false;
    });

  }

}
