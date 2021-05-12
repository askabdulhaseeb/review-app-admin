class SubCategoryModel {
  String categoryId;
  String subCategoryId;
  String icon;
  String subCategoryName;

  SubCategoryModel(
      {this.categoryId, this.subCategoryId, this.icon, this.subCategoryName});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    icon = json['icon'];
    subCategoryName = json['sub_category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['icon'] = this.icon;
    data['sub_category_name'] = this.subCategoryName;
    return data;
  }
}
