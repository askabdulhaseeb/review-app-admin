import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/model/app_user_model.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUsersScreen extends StatefulWidget {
  @override
  _AppUsersScreenState createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  List<AppUserModel> appUsersList = [];

  Dialog deleteConfirmationDialog;

  bool isLoading = true;

  @override
  void initState() {
    getAppUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'App Users'),
      body: SafeArea(
        child: Builder(
          builder: (cxt) => Center(
            child: Container(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: appUsersList.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: appUsersList[index]
                                                    .profileImage !=
                                                null
                                            ? CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: appUsersList[index]
                                                    .profileImage,
                                                progressIndicatorBuilder: (context,
                                                        url,
                                                        downloadProgress) =>
                                                    CupertinoActivityIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${appUsersList[index].firstName} ${appUsersList[index].lastName}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: ColorConstants.blackColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Email: ${appUsersList[index].email}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: ColorConstants.blackColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Contact No: ${appUsersList[index].phoneNo}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: ColorConstants.blackColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Address:\n${appUsersList[index].address}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              color: ColorConstants.blackColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'DOB: ${appUsersList[index].dob}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              color: ColorConstants.blackColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Profession: ${appUsersList[index].profession}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: 'Quicksand',
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                              color: ColorConstants.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          deleteConfirmationDialog = Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.0)), //this right here
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2.5,
                                              //margin: EdgeInsets.all(16),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'Delete Confirmation',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Quicksand',
                                                            fontSize: 26,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 56.0),
                                                      child: Text(
                                                        'Are you sure want to delete this user ?',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Quicksand',
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
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
                                                                  primary: Colors
                                                                      .blue),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);

                                                            //delete record from fire store database
                                                            _deleteUser(
                                                                cxt,
                                                                appUsersList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          child: new Text("Yes",
                                                              style: TextStyle(
                                                                  color: ColorConstants
                                                                      .whiteColor)),
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      ColorConstants
                                                                          .redColor),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: new Text("No",
                                                              style: TextStyle(
                                                                  color: ColorConstants
                                                                      .whiteColor)),
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
                                              builder: (BuildContext context) =>
                                                  deleteConfirmationDialog);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.red[500],
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          child: Center(
                                              child: Text('Delete',
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .redColor))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

  getAppUsers() {
    AppUserModel appUserModel;

    fireStoreInstance.collection("app_users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());

        appUserModel = AppUserModel.fromJson(result.data());
        appUsersList.add(appUserModel);
      });

      setState(() {
        isLoading = false;
      });
    });
  }

  void _deleteUser(BuildContext cxt, String id) {
    setState(() {
      isLoading = true;
    });

    fireStoreInstance.collection("app_users").doc(id).delete().then((_) {
      deleteUserFromList(id);
      Utils.displaySnackBar(cxt, 'User deleted !', 2);
      print("success!");
    });
  }

  deleteUserFromList(String id) {
    int keyIndex = -1;
    for (int i = 0; i < appUsersList.length; i++) {
      if (appUsersList[i].id == id) {
        keyIndex = i;
      }
    }

    if (keyIndex != -1) appUsersList.removeAt(keyIndex);

    setState(() {
      isLoading = false;
    });
  }
}
