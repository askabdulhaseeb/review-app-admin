class NestedCategoryModel {

  String mainCategoryId;
  String mainCategoryImage;
  String mainCategoryName;

  List<SubCategoryData> subCategoriesList = [];

  NestedCategoryModel({this.mainCategoryId, this.mainCategoryImage, this.mainCategoryName});

}

class SubCategoryData {

  String subCategoryId;
  String icon;
  String subCategoryName;

  SubCategoryData({this.subCategoryId, this.icon, this.subCategoryName});

}
