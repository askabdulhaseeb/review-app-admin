import 'dart:io';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/components/custom_text_field.dart';
import 'package:admin_review/model/category_model.dart';
import 'package:admin_review/model/sub_category_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddSecondSubCategoryScreen extends StatefulWidget {
  @override
  _AddSecondSubCategoryScreenState createState() =>
      _AddSecondSubCategoryScreenState();
}

class _AddSecondSubCategoryScreenState
    extends State<AddSecondSubCategoryScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  List<CategoryModel> categoriesList = [];
  List<SubCategoryModel> subCategoriesList = [];

  List<DropdownMenuItem<CategoryModel>> _categoriesDropdownMenuItems;
  CategoryModel _selectedItem;

  List<DropdownMenuItem<SubCategoryModel>> _subCategoriesDropdownMenuItems;
  SubCategoryModel _selectedSubCategoryItem;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _subCategoryTitleController = TextEditingController();
  bool isLoading = true;

  //sub-category icon
  File _image;
  bool formValidation = false;

  @override
  void initState() {
    _getAllCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add Second Sub-Category'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Builder(
            builder: (cxt) => Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categories',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 20,
                            )),

                        SizedBox(
                          height: 10,
                        ),

                        //category drop down
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 56.0,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: Colors.blueGrey)),
                          child: DropdownButton<CategoryModel>(
                            isExpanded: true,
                            underline: SizedBox(),
                            hint: Text("Select Category"),
                            value: _selectedItem,
                            items: _categoriesDropdownMenuItems,
                            onChanged: (value) {
                              print('selected value id: ${value.id}');
                              print('selected value id: ${value.categoryName}');

                              setState(() {
                                _selectedItem = value;
                                isLoading = true;
                              });

                              _getAllSubCategories();
                            },
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Text('Sub-Categories',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 20,
                            )),

                        SizedBox(
                          height: 10,
                        ),

                        //sub-category drop down
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 56.0,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: Colors.blueGrey)),
                          child: DropdownButton<SubCategoryModel>(
                            isExpanded: true,
                            underline: SizedBox(),
                            hint: Text("Select Sub-Category"),
                            value: _selectedSubCategoryItem,
                            items: _subCategoriesDropdownMenuItems,
                            onChanged: (value) {
                              print(
                                  'selected value id: ${value.subCategoryId}');
                              print(
                                  'selected value id: ${value.subCategoryName}');

                              setState(() {
                                _selectedSubCategoryItem = value;
                              });
                            },
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        //second sub-category title field
                        CustomTextField(
                            _subCategoryTitleController,
                            'Second Sub-Category Title',
                            'Second Sub-Category Title',
                            TextInputType.text,
                            validateSubCategoryTitle),

                        SizedBox(
                          height: 10,
                        ),

                        //select icon for sub-category
                        InkWell(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: _image != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: 120,
                                        height: 120,
                                        child: Image.file(
                                          _image,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                    : Container(
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
                                      ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Pick Second\nSub-Category Icon',
                              ),
                              Visibility(
                                visible: formValidation
                                    ? _image == null
                                        ? true
                                        : false
                                    : false,
                                child: Text(
                                  'Please select\nsecond sub-category icon',
                                  style: TextStyle(
                                    color: ColorConstants.redColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 60,
                        ),

                        CustomButton(
                          'Add Sub Category',
                          () {
                            setState(() {
                              formValidation = true;
                            });

                            validateAndSave(
                                cxt, _selectedItem, _selectedSubCategoryItem);
                          },
                        ),
                      ],
                    ),
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

  Function(String) validateSubCategoryTitle = (String value) {
    if (value.isEmpty) {
      return "Sub-Category title empty";
    } else
      return null;
  };

  void validateAndSave(BuildContext cxt, CategoryModel selectedCategory,
      SubCategoryModel selectedSubCategory) async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      //_addSubCategory(cxt, selectedCategory);
      uploadSecondSubCategoryIcon(
          cxt, _image, selectedCategory, selectedSubCategory);
    }
  }

  void _getAllCategories() {
    CategoryModel categoryModel;

    fireStoreInstance.collection("categories").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());

        categoryModel = CategoryModel.fromJson(result.data());
        categoriesList.add(categoryModel);
      });

      _categoriesDropdownMenuItems = buildDropDownMenuItems(categoriesList);
      _selectedItem = _categoriesDropdownMenuItems[0].value;

      _getAllSubCategories();
    });
  }

  void _getAllSubCategories() {
    subCategoriesList.clear();

    SubCategoryModel subCategoryModel;

    try {
      fireStoreInstance
          .collection("categories")
          .doc(_selectedItem?.id)
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

        _subCategoriesDropdownMenuItems =
            buildSubCategoryDropDownMenuItems(subCategoriesList);
        _selectedSubCategoryItem = _subCategoriesDropdownMenuItems[0]?.value;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  List<DropdownMenuItem<CategoryModel>> buildDropDownMenuItems(
      List<CategoryModel> listItems) {
    List<DropdownMenuItem<CategoryModel>> items = [];
    for (CategoryModel listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.categoryName),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<SubCategoryModel>> buildSubCategoryDropDownMenuItems(
      List<SubCategoryModel> listItems) {
    List<DropdownMenuItem<SubCategoryModel>> items = [];
    for (SubCategoryModel listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.subCategoryName),
          value: listItem,
        ),
      );
    }
    return items;
  }

  void _addSecondSubCategory(BuildContext cxt, CategoryModel selectedCategory,
      SubCategoryModel selectedSubCategory, String iconUrl) {
    fireStoreInstance
        .collection("categories")
        .doc(selectedCategory.id)
        .collection("sub_categories")
        .doc(selectedSubCategory.subCategoryId)
        .collection('second_sub_categories')
        .add({
      "category_id": selectedCategory.id,
      "sub_category_name": _subCategoryTitleController.text,
      "sub_category_id": selectedSubCategory.subCategoryId,
      "icon": iconUrl
    }).then((value) => {
              fireStoreInstance
                  .collection("categories")
                  .doc(selectedCategory.id)
                  .collection("sub_categories")
                  .doc(selectedSubCategory.subCategoryId)
                  .collection('second_sub_categories')
                  .doc(value.id)
                  .set({
                "second_sub_category_id": value.id,
              }, SetOptions(merge: true)).then((_) {
                print("success!");
                Utils.displaySnackBar(cxt, 'Second Sub-Category added !', 2);

                setState(() {
                  isLoading = false;
                });
              }),
            });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    ImagePicker _imagePicker = ImagePicker();
    PickedFile image = await _imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    ImagePicker _imagePicker = ImagePicker();
    PickedFile image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  Future<String> uploadSecondSubCategoryIcon(
      BuildContext cxt,
      File _image,
      CategoryModel selectedCategory,
      SubCategoryModel selectedSubCategory) async {
    setState(() {
      isLoading = true;
    });

    var url;
    Reference ref = _storage
        .ref()
        .child("secondSubCategoryIcons/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      url = ref.getDownloadURL().then((value) => {
            _addSecondSubCategory(
                cxt, selectedCategory, selectedSubCategory, value.toString()),
            print('url: ${value.toString()}'),
          });
    }).catchError((onError) {
      print(onError);
    });

    return url.toString();
  }

  @override
  void dispose() {
    _subCategoryTitleController.dispose();
    super.dispose();
  }
}
