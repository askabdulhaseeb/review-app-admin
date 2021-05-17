import 'dart:io';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/components/custom_text_field.dart';
import 'package:admin_review/model/category_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddSubCategoryScreen extends StatefulWidget {
  @override
  _AddSubCategoryScreenState createState() => _AddSubCategoryScreenState();
}

class _AddSubCategoryScreenState extends State<AddSubCategoryScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  List<CategoryModel> categoriesList = [];

  List<DropdownMenuItem<CategoryModel>> _categoriesDropdownMenuItems;
  CategoryModel _selectedItem;

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
      appBar: CustomAppBar(title: 'Add Sub Category'),
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
                              });
                            },
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        //sub-category title field
                        CustomTextField(
                            _subCategoryTitleController,
                            'Sub-Category Title',
                            'Sub-Category Title',
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
                                'Pick Sub-Category Icon',
                              ),
                              Visibility(
                                visible: formValidation
                                    ? _image == null
                                        ? true
                                        : false
                                    : false,
                                child: Text(
                                  'Please select sub-category icon',
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

                            validateAndSave(cxt, _selectedItem);
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

  void validateAndSave(BuildContext cxt, CategoryModel selectedCategory) async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      //_addSubCategory(cxt, selectedCategory);
      uploadSubCategoryIcon(cxt, _image, selectedCategory);
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

      setState(() {
        isLoading = false;
      });

      _categoriesDropdownMenuItems = buildDropDownMenuItems(categoriesList);
      _selectedItem = _categoriesDropdownMenuItems[0].value;
    });
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

  void _addSubCategory(
      BuildContext cxt, CategoryModel selectedCategory, String iconUrl) {
    fireStoreInstance
        .collection("categories")
        .doc(selectedCategory.id)
        .collection("sub_categories")
        .add({
      "category_id": selectedCategory.id,
      "sub_category_name": _subCategoryTitleController.text,
      "icon": iconUrl
    }).then((value) => {
              fireStoreInstance
                  .collection("categories")
                  .doc(selectedCategory.id)
                  .collection("sub_categories")
                  .doc(value.id)
                  .set({
                "sub_category_id": value.id,
              }, SetOptions(merge: true)).then((_) {
                print("success!");
                Utils.displaySnackBar(cxt, 'Sub-Category added !', 2);

                setState(() {
                  isLoading = false;
                });
              }),
            });

    /*fireStoreInstance.collection("categories").doc(selectedCategory.id).set(
        {
          "id" : selectedCategory.id,
        },SetOptions(merge: true)).then((_){

      print("success!");
      Utils.displaySnackBar(cxt, 'Sub-Category added !', 2);

      setState(() {
        isLoading = false;
      });

    });*/
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

  Future<String> uploadSubCategoryIcon(
      BuildContext cxt, File _image, CategoryModel selectedCategory) async {
    setState(() {
      isLoading = true;
    });

    var url;
    Reference ref =
        _storage.ref().child("subCategoryIcons/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      url = ref.getDownloadURL().then((value) => {
            _addSubCategory(cxt, selectedCategory, value.toString()),
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
