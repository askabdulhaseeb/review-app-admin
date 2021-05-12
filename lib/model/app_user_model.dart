class AppUserModel {

  String id;
  String firstName;
  String lastName;
  String gender;
  String email;
  String phoneNo;
  String dob;
  String profession;
  String profileImage;
  String address;

  AppUserModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.gender,
        this.email,
        this.phoneNo,
        this.dob,
        this.profession,
        this.profileImage,
        this.address});

  AppUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    email = json['email'];
    phoneNo = json['phone_no'];
    dob = json['dob'];
    profession = json['profession'];
    profileImage = json['profile_image'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['phone_no'] = this.phoneNo;
    data['dob'] = this.dob;
    data['profession'] = this.profession;
    data['profile_image'] = this.profileImage;
    data['address'] = this.address;
    return data;
  }
}
