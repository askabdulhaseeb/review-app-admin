class SecondSubCategoryModel {

  String categoryId;
  String subCategoryId;
  String secondSubCategoryId;
  String icon;
  String secondSubCategoryName;

  String categoryName;
  String subCategoryName;

  SecondSubCategoryModel(
      {this.categoryId, this.subCategoryId, this.secondSubCategoryId, this.icon, this.secondSubCategoryName});

  SecondSubCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    secondSubCategoryId = json['second_sub_category_id'];
    icon = json['icon'];
    secondSubCategoryName = json['sub_category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['second_sub_category_id'] = this.secondSubCategoryId;
    data['icon'] = this.icon;
    data['sub_category_name'] = this.secondSubCategoryName;
    return data;
  }

  void setSubCategoryName(String subCategoryName) {
    this.subCategoryName = subCategoryName;
  }

  void setCategoryName(String categoryName) {
    this.categoryName = categoryName;
  }

}
