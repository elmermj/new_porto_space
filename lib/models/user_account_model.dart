import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccountModel {
  String? name;
  String? dob;
  String? email;
  String? city;
  String? profileDesc;
  int? followers;
  String? interests;
  String? lastLogin;
  String? currentCompany;
  String? currentOccupation;
  String? photoUrl;
  Map<String, dynamic>? userSettings;
  Timestamp? lastLoginAt;

  UserAccountModel({
    this.name,
    this.dob,
    this.email,
    this.city,
    this.profileDesc,
    this.followers,
    this.interests,
    this.currentCompany,
    this.currentOccupation,
    this.photoUrl,
    this.userSettings,
    this.lastLoginAt,
  });

  UserAccountModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'N/A';
    dob = json['birthdate']  ?? 'N/A';
    email = json['email'] ?? 'N/A';
    city = json['location'] ?? 'N/A';
    profileDesc = json['profileDesc'] ?? 'N/A';
    followers = json['followers'] ?? 0;
    interests = json['interests'] ?? 'N/A';
    currentCompany = json['currentCompany'] ?? 'N/A';
    currentOccupation = json['currentOccupation'] ?? 'N/A';
    photoUrl = json['photoUrl'] ?? 'N/A';
    userSettings = json['userSettings'];
    lastLoginAt = json['lastLoginAt'] ?? Timestamp.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = name ?? 'N/A';
    data['birthdate'] = dob ?? 'N/A';
    data['email'] = email ?? 'N/A';
    data['location'] = city ?? 'N/A';
    data['bio'] = profileDesc ?? 'N/A';
    data['followers'] = followers ?? 0;
    data['interests'] = interests ?? ['N/A'];
    data['currentCompany'] = currentCompany ?? 'N/A';
    data['currentOccupation'] = currentOccupation ?? 'N/A';
    data['photoUrl'] = photoUrl ?? 'N/A';
    data['userSettings'] = userSettings;
    data['lastLoginAt'] = lastLoginAt ?? Timestamp.now();
    return data;
  }
}
