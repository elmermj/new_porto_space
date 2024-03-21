class UserAccountModel {
  String? username;
  String? fullName;
  String? birthdate;
  String? email;
  String? location;
  String? bio;
  int? followers;
  String? profilePicture;
  String? interests;
  String? lastLogin;

  UserAccountModel(
      {this.username,
      this.fullName,
      this.birthdate,
      this.email,
      this.location,
      this.bio,
      this.followers,
      this.profilePicture,
      this.interests,
      this.lastLogin});

  UserAccountModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    fullName = json['full_name'];
    birthdate = json['birthdate'];
    email = json['email'];
    location = json['location'];
    bio = json['bio'];
    followers = json['followers'];
    profilePicture = json['profile_picture'];
    interests = json['interests'];
    lastLogin = json['last_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    data['birthdate'] = this.birthdate;
    data['email'] = this.email;
    data['location'] = this.location;
    data['bio'] = this.bio;
    data['followers'] = this.followers;
    data['profile_picture'] = this.profilePicture;
    data['interests'] = this.interests;
    data['last_login'] = this.lastLogin;
    return data;
  }
}
