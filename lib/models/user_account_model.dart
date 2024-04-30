import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserAccountModel extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? dob;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? city;
  @HiveField(4)
  String? profileDesc;
  @HiveField(5)
  int? followers;
  @HiveField(6)
  String? interests;
  @HiveField(7)
  String? currentCompany;
  @HiveField(8)
  String? occupation;
  @HiveField(9)
  String? photoUrl;
  @HiveField(10)
  Map<String, dynamic>? userSettings;
  @HiveField(11)
  Timestamp? lastLoginAt;
  @HiveField(12)
  String? deviceToken;
  @HiveField(13)
  Timestamp? createdAt;

  UserAccountModel({
    this.name,
    this.dob,
    this.email,
    this.city,
    this.profileDesc,
    this.followers,
    this.interests,
    this.currentCompany,
    this.occupation,
    this.photoUrl,
    this.userSettings,
    this.lastLoginAt,
    this.deviceToken,
    this.createdAt,
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
    occupation = json['occupation'] ?? 'N/A';
    photoUrl = json['photoUrl'] ?? 'N/A';
    userSettings = json['userSettings'];
    lastLoginAt = json['lastLoginAt'] ?? Timestamp.now();
    deviceToken = json['deviceToken'] ?? 'N/A';
    createdAt = json['createdAt'] ?? Timestamp.fromDate(DateTime(1970));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name ?? 'N/A';
    data['birthdate'] = dob ?? 'N/A';
    data['email'] = email ?? 'N/A';
    data['location'] = city ?? 'N/A';
    data['bio'] = profileDesc ?? 'N/A';
    data['followers'] = followers ?? 0;
    data['interests'] = interests ?? ['N/A'];
    data['currentCompany'] = currentCompany ?? 'N/A';
    data['occupation'] = occupation ?? 'N/A';
    data['photoUrl'] = photoUrl ?? 'N/A';
    data['userSettings'] = userSettings;
    data['lastLoginAt'] = lastLoginAt ?? Timestamp.now();
    data['deviceToken'] = deviceToken ?? 'N/A';
    data['createdAt'] = createdAt?? Timestamp.fromDate(DateTime(1970));
    return data;
  }

  factory UserAccountModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserAccountModel.fromJson(doc.data() as Map<String, dynamic>);
  }
}