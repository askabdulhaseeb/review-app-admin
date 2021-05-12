class CategoryModel {
  String id;
  String image;
  String categoryName;

  CategoryModel({this.id, this.image, this.categoryName});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['category_name'] = this.categoryName;
    return data;
  }
}
