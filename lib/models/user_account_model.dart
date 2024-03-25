class UserAccountModel {
  String? username;
  String? fullName;
  String? dob;
  String? email;
  String? city;
  String? profileDesc;
  int? followers;
  String? profilePicture;
  List<String>? interests;
  String? lastLogin;
  String? currentCompany;
  String? currentOccupation;
  String? photoUrl;
  Map<String, dynamic>? userSettings;

  UserAccountModel({
    this.username,
    this.fullName,
    this.dob,
    this.email,
    this.city,
    this.profileDesc,
    this.followers,
    this.profilePicture,
    this.interests,
    this.lastLogin,
    this.currentCompany,
    this.currentOccupation,
    this.photoUrl,
    this.userSettings,
  });

  UserAccountModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    fullName = json['full_name'];
    dob = json['birthdate'];
    email = json['email'];
    city = json['location'];
    profileDesc = json['profileDesc'];
    followers = json['followers'];
    profilePicture = json['profile_picture'];
    interests = json['interests'];
    lastLogin = json['last_login'];
    currentCompany = json['currentCompany'];
    currentOccupation = json['currentOccupation'];
    photoUrl = json['photoUrl'];
    userSettings = json['userSettings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['full_name'] = fullName;
    data['birthdate'] = dob;
    data['email'] = email;
    data['location'] = city;
    data['bio'] = profileDesc;
    data['followers'] = followers;
    data['profile_picture'] = profilePicture;
    data['interests'] = interests;
    data['last_login'] = lastLogin;
    data['currentCompany'] = currentCompany;
    data['currentOccupation'] = currentOccupation;
    data['photoUrl'] = photoUrl;
    data['userSettings'] = userSettings;
    return data;
  }
}
