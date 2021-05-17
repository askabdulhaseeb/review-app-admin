import 'dart:io';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/components/custom_text_field.dart';
import 'package:admin_review/model/second_sub_category_model.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditSecondSubCategoryScreen extends StatefulWidget {
  final SecondSubCategoryModel secondSubCategoryObj;
  EditSecondSubCategoryScreen({this.secondSubCategoryObj});

  @override
  _EditSecondSubCategoryScreenState createState() =>
      _EditSecondSubCategoryScreenState();
}

class _EditSecondSubCategoryScreenState
    extends State<EditSecondSubCategoryScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _secondSubCategoryTitleController = TextEditingController();
  File _image;

  bool formValidation = false;
  bool isLoading = false;

  @override
  void initState() {
    _secondSubCategoryTitleController = TextEditingController(
        text: widget.secondSubCategoryObj.subCategoryName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Second Sub Category'),
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
                                _secondSubCategoryTitleController,
                                'Second Sub-Category Title',
                                'Second Sub-Category Title',
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
                                              imageUrl: widget
                                                  .secondSubCategoryObj.icon,
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
                                    'Pick Second\nSub-Category Image',
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 60,
                            ),

                            //update sub-category button
                            CustomButton(
                              'Update Second Sub-Category',
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

  void validateAndSave(BuildContext cxt) async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      if (_image == null) {
        _updateSubCategory(cxt);
      } else {
        print('in else: second sub-category icon got from image picker');
        uploadSubCategoryPic(cxt, _image);
      }
    }
  }

  void _updateSubCategory(BuildContext cxt) {
    fireStoreInstance
        .collection("categories")
        .doc(widget.secondSubCategoryObj.categoryId)
        .collection("sub_categories")
        .doc(widget.secondSubCategoryObj.subCategoryId)
        .collection('second_sub_categories')
        .doc(widget.secondSubCategoryObj.secondSubCategoryId)
        .update({
      "category_id": widget.secondSubCategoryObj.categoryId,
      "icon": widget.secondSubCategoryObj.icon,
      "sub_category_id": widget.secondSubCategoryObj.subCategoryId,
      "second_sub_category_id": widget.secondSubCategoryObj.secondSubCategoryId,
      "sub_category_name": _secondSubCategoryTitleController.text
    }).then((_) {
      setState(() {
        isLoading = false;
      });

      //show update success snack bar
      Utils.displaySnackBar(cxt, 'Second Sub-Category updated !', 2);
    });
  }

  void _addSubCategory(BuildContext cxt, String name, String image) {
    fireStoreInstance
        .collection("categories")
        .doc(widget.secondSubCategoryObj.categoryId)
        .collection("sub_categories")
        .doc(widget.secondSubCategoryObj.subCategoryId)
        .collection('second_sub_categories')
        .doc(widget.secondSubCategoryObj.secondSubCategoryId)
        .update({
      "category_id": widget.secondSubCategoryObj.categoryId,
      "icon": image,
      "sub_category_id": widget.secondSubCategoryObj.subCategoryId,
      "second_sub_category_id": widget.secondSubCategoryObj.secondSubCategoryId,
      "sub_category_name": _secondSubCategoryTitleController.text
    }).then((_) {
      //show update success snack bar
      Utils.displaySnackBar(cxt, 'Second Sub-Category updated !', 2);
    });
  }

  uploadSubCategoryPic(BuildContext cxt, File _image) async {
    Reference ref = _storage
        .ref()
        .child("secondSubCategoryIcons/" + DateTime.now().toString());

    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      ref.getDownloadURL().then((value) => {
            _addSubCategory(
                cxt, _secondSubCategoryTitleController.text, value.toString()),
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
    _secondSubCategoryTitleController.dispose();
    super.dispose();
  }
}
