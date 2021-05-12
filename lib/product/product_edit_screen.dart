import 'dart:io';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/product/product_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditScreen extends StatefulWidget {
  final MyProduct object;
  ProductEditScreen(this.object);

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  File _image;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Product Image'),
      body: SafeArea(
        child: Stack(
              alignment: AlignmentDirectional.center,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: 
                    _image==null?
                    CachedNetworkImage(
                      imageUrl: widget.object.image,
                      height: 220,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ):Image.file(_image,height: 220,
                      fit: BoxFit.fill,),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Click on the image to change image',
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 18,
                                color: ColorConstants.blackColor)),
                        SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                          'Update Product Image',
                          () {
                            // method for update image
                            setState(() {
                              isLoading = true;
                            });

                            Reference ref = _storage.ref().child(
                                "categoryImages/" + DateTime.now().toString());

                            UploadTask uploadTask = ref.putFile(_image);
                            uploadTask.whenComplete(() {
                              ref.getDownloadURL().then((value) => {
                                    fireStoreInstance
                                        .collection("products")
                                        .doc(widget.object.id)
                                        .update({"image": value}).then((_) {
                                      print("done");
                                      setState(() {
                                        isLoading = false;
                                      });
                                    })
                                  });
                            }).catchError((onError) {
                              print(onError);
                            });
                          },
                        ),
                      ],
                    ),
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
    );
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
}
