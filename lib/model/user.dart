class User {
  String? name;
  String? email;
  String? role;
  String? phone;
  String? profilePict;
  String? createdAt;

  User(
      {this.name,
        this.email,
        this.role,
        this.phone,
        this.profilePict,
        this.createdAt});


  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    role = json['role'];
    phone = json['phone'];
    profilePict = json['profile_pict'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['profile_pict'] = this.profilePict;
    data['created_at'] = this.createdAt;
    return data;
  }
}