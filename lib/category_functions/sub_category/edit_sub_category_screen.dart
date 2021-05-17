import 'dart:io';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/components/custom_text_field.dart';
import 'package:admin_review/model/sub_category_model.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditSubCategoryScreen extends StatefulWidget {
  final SubCategoryModel subCategoryObj;
  EditSubCategoryScreen({this.subCategoryObj});

  @override
  _EditSubCategoryScreenState createState() => _EditSubCategoryScreenState();
}

class _EditSubCategoryScreenState extends State<EditSubCategoryScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _subCategoryTitleController = TextEditingController();
  File _image;

  bool formValidation = false;
  bool isLoading = false;

  @override
  void initState() {
    _subCategoryTitleController =
        TextEditingController(text: widget.subCategoryObj.subCategoryName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Sub Category'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Builder(
            builder: (cxt) => Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //category title field
                            CustomTextField(
                                _subCategoryTitleController,
                                'Sub Category Title',
                                'Sub Category Title',
                                TextInputType.text,
                                validateCategoryTitle),

                            SizedBox(
                              height: 10,
                            ),

                            //select image for category
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
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 120,
                                            height: 120,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  widget.subCategoryObj.icon,
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
                                    height: 10,
                                  ),
                                  Text(
                                    'Pick Sub-Category Image',
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 60,
                            ),

                            //update sub-category button
                            CustomButton(
                              'Update Sub-Category',
                              () {
                                setState(() {
                                  formValidation = true;
                                  isLoading = true;
                                });

                                validateAndSave(cxt);
                              },
                            ),
                          ],
                        ),
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
      ),
    );
  }

  Function(String) validateCategoryTitle = (String value) {
    if (value.isEmpty) {
      return "Sub-Category title empty";
    } else
      return null;
  };

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
    ImagePicker _imagePicked = ImagePicker();
    PickedFile image = await _imagePicked.getImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    ImagePicker _imagePicked = ImagePicker();
    PickedFile image = await _imagePicked.getImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  void validateAndSave(BuildContext cxt) async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      if (_image == null) {
        _updateSubCategory(cxt);
      } else {
        print('in else: sub-category icon got from image picker');
        uploadSubCategoryPic(cxt, _image);
      }
    }
  }

  void _updateSubCategory(BuildContext cxt) {
    /*fireStoreInstance
        .collection("categories")
        .doc(widget.subCategoryObj.id)
        .update({
          "id": widget.subCategoryObj.id,
          "category_name" : _subCategoryTitleController.text,
          "image": widget.subCategoryObj.image
        }).then((_) {

          setState(() {
            isLoading = false;
          });

          //show update success snack bar
          Utils.displaySnackBar(cxt, 'Category updated !', 2);
    });*/

    fireStoreInstance
        .collection("categories")
        .doc(widget.subCategoryObj.categoryId)
        .collection("sub_categories")
        .doc(widget.subCategoryObj.subCategoryId)
        .update({
      "category_id": widget.subCategoryObj.categoryId,
      "sub_category_id": widget.subCategoryObj.subCategoryId,
      "sub_category_name": _subCategoryTitleController.text,
      "icon": widget.subCategoryObj.icon
    }).then((_) {
      setState(() {
        isLoading = false;
      });

      //show update success snack bar
      Utils.displaySnackBar(cxt, 'Sub-Category updated !', 2);
    });
  }

  void _addSubCategory(BuildContext cxt, String name, String image) {
    fireStoreInstance
        .collection("categories")
        .doc(widget.subCategoryObj.categoryId)
        .collection("sub_categories")
        .doc(widget.subCategoryObj.subCategoryId)
        .update({
      "category_id": widget.subCategoryObj.categoryId,
      "sub_category_id": widget.subCategoryObj.subCategoryId,
      "sub_category_name": _subCategoryTitleController.text,
      "icon": image
    }).then((_) {
      //show update success snack bar
      Utils.displaySnackBar(cxt, 'Sub-Category updated !', 2);
    });
  }

  uploadSubCategoryPic(BuildContext cxt, File _image) async {
    Reference ref =
        _storage.ref().child("subCategoryIcons/" + DateTime.now().toString());

    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      ref.getDownloadURL().then((value) => {
            _addSubCategory(
                cxt, _subCategoryTitleController.text, value.toString()),
            print('url: ${value.toString()}'),
            setState(() {
              isLoading = false;
            }),
          });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void dispose() {
    _subCategoryTitleController.dispose();
    super.dispose();
  }
}
