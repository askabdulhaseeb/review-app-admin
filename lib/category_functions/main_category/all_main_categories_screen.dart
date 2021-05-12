import 'package:admin_review/category_functions/main_category/edit_main_category_screen.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/model/category_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';


class AllMainCategoriesScreen extends StatefulWidget {
  @override
  _AllMainCategoriesScreenState createState() =>
      _AllMainCategoriesScreenState();
}

class _AllMainCategoriesScreenState extends State<AllMainCategoriesScreen> {

  final fireStoreInstance = FirebaseFirestore.instance;
  List<CategoryModel> categoriesList = [];

  Dialog deleteConfirmationDialog;

  bool isLoading = true;

  @override
  void initState() {
    _getAllCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Main Categories'),
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
                          itemCount: categoriesList.length,
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
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          categoriesList[index]
                                              .categoryName
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
                                            RaisedButton(
                                              color: Colors.green,
                                              onPressed: () {

                                                //navigate to edit category screen
                                                Navigator.of(context)
                                                    .push(new MaterialPageRoute(builder: (context) =>
                                                      EditMainCategoryScreen(categoryObj: categoriesList[index])));

                                              },
                                              child: new Text("Edit",
                                                  style: TextStyle(
                                                      color: ColorConstants.whiteColor)),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            RaisedButton(
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
                                                            child: Text('Are you sure want to delete this category ?',
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
                                                                  _deleteCategory(cxt, categoriesList[index].id);

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

  void _getAllCategories() {

    CategoryModel categoryModel;

    fireStoreInstance.collection("categories").get().then((querySnapshot) {
      print("ejaz");
      print(querySnapshot.docs.length);
      querySnapshot.docs.forEach((result) {


        categoryModel = CategoryModel.fromJson(result.data());
        categoriesList.add(categoryModel);
      });

      setState(() {
        isLoading = false;
      });

    });
  }

  void _deleteCategory(BuildContext cxt, String id) {

    setState(() {
      isLoading = true;
    });

    fireStoreInstance.collection("categories").doc(id).delete().then((_) {

      deleteCategoryItemFromList(id);
      Utils.displaySnackBar(cxt, 'Category deleted !', 2);
      print("success!");

    });

  }

  deleteCategoryItemFromList(String id) {
    int keyIndex = -1;
    for(int i=0; i<categoriesList.length; i++) {

      if(categoriesList[i].id == id) {
        keyIndex = i;
      }
    }

    if(keyIndex != -1)
      categoriesList.removeAt(keyIndex);

    setState(() {
      isLoading = false;
    });

  }

}
