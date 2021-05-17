class MyProduct {
  String id;
  String image;
  String category;
  String description;
  String name;
  String secondSubCategory;
  String subCategory;
  String price;
  String likes;
  MyProduct({
    this.image,
    this.category,
    this.description,
    this.name,
    this.secondSubCategory,
    this.subCategory,
    this.price,
    this.likes,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'category': category,
      'description': description,
      'prod_name': name,
      'second_sub_category': secondSubCategory,
      'sub_category': subCategory,
      'price': price,
      'likes': likes,
      'id': id,
    };
  }

  factory MyProduct.fromMap(Map<String, dynamic> map) {
    return MyProduct(
      image: map['image'],
      category: map['category'],
      description: map['description'],
      name: map['prod_name'],
      secondSubCategory: map['second_sub_category'],
      subCategory: map['sub_category'],
      price: map['price'] != null ? map['price'].toString() : null,
      likes: map['likes'],
      id: map['id'],
    );
  }
}
