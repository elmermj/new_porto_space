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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['full_name'] = fullName;
    data['birthdate'] = birthdate;
    data['email'] = email;
    data['location'] = location;
    data['bio'] = bio;
    data['followers'] = followers;
    data['profile_picture'] = profilePicture;
    data['interests'] = interests;
    data['last_login'] = lastLogin;
    return data;
  }
}
