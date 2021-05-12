import 'dart:io';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/components/custom_text_field.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMainCategoryScreen extends StatefulWidget {
  @override
  _AddMainCategoryScreenState createState() => _AddMainCategoryScreenState();
}

class _AddMainCategoryScreenState extends State<AddMainCategoryScreen> {

  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _categoryTitleController = TextEditingController();
  File _image;

  bool formValidation = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add Main Category'),
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
                        //category title field
                        CustomTextField(_categoryTitleController, 'Category Title',
                            'Category Title', TextInputType.text, validateCategoryTitle),

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
                                'Pick Category Image',
                              ),

                              Visibility(
                                visible: formValidation ? _image == null ? true : false : false,
                                child: Text(
                                  'Please select category image',
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

                        //add category button
                        CustomButton(
                          'Add Category',
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
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void validateAndSave(BuildContext cxt) async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      uploadCategoryPic(cxt, _image);

    }
  }

  void _addCategory(BuildContext cxt, String name, String image) {

    /*String docId = fireStoreInstance
        .collection('categories')
        .doc()
        .id;*/

    fireStoreInstance.collection("categories").add(
        {
          "category_name" : name,
          "image": image
        }).then((value){


      print(value.id);
      fireStoreInstance.collection("categories").doc(value.id).set(
          {
            "id" : value.id,
          },SetOptions(merge: true)).then((_){

            print("success!");

            Utils.displaySnackBar(cxt, 'Category added !', 2);

            setState(() {
              isLoading = false;
            });
      });



    });
  }

  Future<String> uploadCategoryPic(BuildContext cxt, File _image) async {

    var url;
    Reference ref = _storage.ref().child("categoryImages/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.whenComplete(() {
      url = ref.getDownloadURL().then((value) => {

        _addCategory(cxt, _categoryTitleController.text, value.toString()),

        print('url: ${value.toString()}'),
      });


    }).catchError((onError) {
      print(onError);
    });
    return url.toString();
  }


  @override
  void dispose() {
    _categoryTitleController.dispose();
    super.dispose();
  }
}
