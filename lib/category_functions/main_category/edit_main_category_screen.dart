import 'dart:io';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/components/custom_text_field.dart';
import 'package:admin_review/model/category_model.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditMainCategoryScreen extends StatefulWidget {
  final CategoryModel categoryObj;
  EditMainCategoryScreen({this.categoryObj});

  @override
  _EditMainCategoryScreenState createState() => _EditMainCategoryScreenState();
}

class _EditMainCategoryScreenState extends State<EditMainCategoryScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _categoryTitleController = TextEditingController();
  File _image;

  bool formValidation = false;
  bool isLoading = false;

  @override
  void initState() {
    _categoryTitleController =
        TextEditingController(text: widget.categoryObj.categoryName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Main Category'),
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
                                _categoryTitleController,
                                'Category Title',
                                'Category Title',
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
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: 120,
                                            height: 120,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  widget.categoryObj.image,
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
                                    'Pick Category Image',
                                  ),

                                  /*
                                  Visibility(
                                    visible: formValidation ? _image == null ? true : false : false,
                                    child: Text(
                                      'Please select category image',
                                      style: TextStyle(
                                        color: ColorConstants.redColor,
                                      ),
                                    ),
                                  ),
                                  */
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 60,
                            ),

                            CustomButton(
                              'Update Category',
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
      return "Category title empty";
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
        _updateCategory(cxt);
      } else {
        print('in else: image got from image picker');
        uploadCategoryPic(cxt, _image);
      }
    }
  }

  void _updateCategory(BuildContext cxt) {
    fireStoreInstance
        .collection("categories")
        .doc(widget.categoryObj.id)
        .update({
      "id": widget.categoryObj.id,
      "category_name": _categoryTitleController.text,
      "image": widget.categoryObj.image
    }).then((_) {
      setState(() {
        isLoading = false;
      });

      //show update success snack bar
      Utils.displaySnackBar(cxt, 'Category updated !', 2);
    });
  }

  void _addCategory(BuildContext cxt, String name, String image) {
    /*fireStoreInstance.collection("categories").add({
      "category_name" : name,
      "image": image
    });*/

    fireStoreInstance
        .collection("categories")
        .doc(widget.categoryObj.id)
        .update({
      "id": widget.categoryObj.id,
      "category_name": name,
      "image": image
    }).then((_) {
      //show update success snack bar
      Utils.displaySnackBar(cxt, 'Category updated !', 2);
    });
  }

  uploadCategoryPic(BuildContext cxt, File _image) async {
    Reference ref =
        _storage.ref().child("categoryImages/" + DateTime.now().toString());

    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      ref.getDownloadURL().then((value) => {
            _addCategory(cxt, _categoryTitleController.text, value.toString()),
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
    _categoryTitleController.dispose();
    super.dispose();
  }
}
