import 'package:admin_review/components/custom_button.dart';
import 'package:admin_review/components/custom_text_field.dart';
import 'package:admin_review/home/home_screen.dart';
import 'package:admin_review/model/login_response.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:admin_review/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final fireStoreInstance = FirebaseFirestore.instance;
  LoginResponse loginResponse;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _matchFound = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Admin Panel',
          style: TextStyle(
              fontFamily: 'Quicksand', color: ColorConstants.blackColor),
        ),
        centerTitle: true,
      ),
      body: Builder(
        builder: (BuildContext cxt) {
          return SafeArea(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),

                            Image.asset('assets/images/review_logo.png',
                                width: 120, height: 120),

                            SizedBox(
                              height: 10,
                            ),

                            Text('MYREVUE',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),

                            SizedBox(
                              height: 30,
                            ),

                            //username field
                            CustomTextField(
                                _usernameController,
                                'Username',
                                'Username',
                                TextInputType.text,
                                validateUsername),
                            SizedBox(height: 16),
                            //password field
                            CustomTextField(
                              _passwordController,
                              'Password',
                              'Password',
                              TextInputType.text,
                              validatePassword,
                              obscureText: true,
                            ),

                            SizedBox(height: 40),

                            //sign in button
                            CustomButton(
                              'Sign In',
                              () {
                                //sign in logic
                                //validateAndSave(cxt);

                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                          ],
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
        },
      ),
    );
  }

  Function(String) validateUsername = (String username) {
    if (username.isEmpty) {
      return 'Username empty';
    } else if (username.length < 3) {
      return 'Username short';
    }

    return null;
  };

  Function(String) validatePassword = (String value) {
    if (value.isEmpty) {
      return "Password empty";
    } else if (value.length < 6) {
      return "Password should be at least 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  };

  performLogin(BuildContext cxt) {
    setState(() {
      isLoading = true;
    });

    fireStoreInstance.collection("users").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        loginResponse = LoginResponse.fromJson(result.data());

        if (loginResponse.username == _usernameController.text &&
            loginResponse.password == _passwordController.text) {
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => HomeScreen()));

          _matchFound = true;

          setState(() {
            isLoading = false;
          });

          print(result.data());
        }
      });

      if (_matchFound == false) {
        //login failed
        Utils.displaySnackBar(cxt, 'Invalid credentials', 2);
      }
    });
  } //end performLogin()

  void validateAndSave(BuildContext cxt) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      performLogin(cxt);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
