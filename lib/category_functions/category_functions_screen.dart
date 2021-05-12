import 'package:admin_review/category_functions/main_category/add_main_category_screen.dart';
import 'package:admin_review/category_functions/main_category/all_main_categories_screen.dart';
import 'package:admin_review/category_functions/nested_categories/all_nested_categories_screen.dart';
//.........................................
//import 'file:///C:/Users/raheel/AndroidStudioProjects/admin_review/lib/category_functions/second_sub_category/all_second_sub_categories_screen.dart';
import 'package:admin_review/category_functions/second_sub_category/add_second_sub_category_screen.dart';
import 'package:admin_review/category_functions/sub_category/add_sub_category_screen.dart';
import 'package:admin_review/category_functions/sub_category/all_sub_categories_screen.dart';
import 'package:admin_review/components/custom_app_bar.dart';
import 'package:admin_review/components/custom_button_2.dart';
import 'package:admin_review/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CategoryFunctionsScreen extends StatefulWidget {
  @override
  _CategoryFunctionsScreenState createState() =>
      _CategoryFunctionsScreenState();
}

class _CategoryFunctionsScreenState extends State<CategoryFunctionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Category'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Main Category',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                      color: ColorConstants.blackColor,
                    )),

                SizedBox(
                  height: 16,
                ),

                //add category
                CustomButton2('Add Main Category', () {
                  //navigate to add main category screen
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AddMainCategoryScreen()));
                }),

                SizedBox(
                  height: 10,
                ),

                //view all categories
                CustomButton2('View All Main Categories', () {
                  //navigate to view all main category screen
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AllMainCategoriesScreen()));
                }),

                SizedBox(
                  height: 20,
                ),

                Text('Sub-Category',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                      color: ColorConstants.blackColor,
                    )),

                SizedBox(
                  height: 16,
                ),

                //add category
                CustomButton2('Add Sub-Category', () {
                  //navigate to add sub-category screen
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AddSubCategoryScreen()));
                }),

                SizedBox(
                  height: 10,
                ),

                //view all categories
                CustomButton2('View All Sub-Categories', () {
                  //navigate to add view all sub-category screen
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AllSubCategoriesScreen()));
                }),

                SizedBox(
                  height: 20,
                ),

                Text('Second Sub-Category',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                      color: ColorConstants.blackColor,
                    )),

                SizedBox(
                  height: 16,
                ),

                //add category
                CustomButton2('Add Second Sub-Category', () {
                  //navigate to add add second sub-category screen
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AddSecondSubCategoryScreen()));
                }),

                SizedBox(
                  height: 10,
                ),

                //view all categories
                CustomButton2('View All Second Sub-Categories', () {
//.........................................
                  //navigate to all second sub-category screen
                  // Navigator.of(context)
                  //     .push(new MaterialPageRoute(builder: (context) => AllSecondSubCategoriesScreen()));
                }),

                SizedBox(
                  height: 16,
                ),

                Text('View All Nested Categories',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                      color: ColorConstants.blackColor,
                    )),

                SizedBox(
                  height: 16,
                ),

                //view all nested categories
                CustomButton2('View All Nested Categories', () {
                  //navigate to view all nested category screen
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => AllNestedCategoriesScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
