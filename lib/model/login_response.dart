class LoginResponse {
  String password;
  String username;

  LoginResponse({this.password, this.username});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['username'] = this.username;
    return data;
  }
}
