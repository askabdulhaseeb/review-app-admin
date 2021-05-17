import 'package:admin_review/category_functions/category_functions_screen.dart';
import 'package:admin_review/notifications/notifications_screen.dart';
import 'package:admin_review/product/view_products_screen.dart';
import 'package:admin_review/components/custom_button_2.dart';
import 'package:admin_review/app_users/app_users_screen.dart';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Home Screen'),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                //category
                CustomButton2('Category', () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => CategoryFunctionsScreen()));
                }),

                SizedBox(height: 10),

                //users
                CustomButton2('Users', () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AppUsersScreen()));
                }),

                SizedBox(height: 10),

                //view products
                CustomButton2('View Products', () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => ViewProductsScreen()));
                }),

                SizedBox(height: 10),

                //push notifications
                CustomButton2('Push Notifications', () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
                  print('push');
                }),

                SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }
}
