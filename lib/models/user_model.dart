import 'package:hive/hive.dart';

import 'user_notification.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject{
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? password;
  @HiveField(3)
  String? photoURL;
  @HiveField(4)
  String? uid;
  @HiveField(5)
  String? deviceToken;
  @HiveField(6)
  String? isLogin;
  @HiveField(7)
  List<UserNotification>? userNotificationList;
  // @HiveField(7)
  // String? deviceType;
  // @HiveField(8)
  // String? deviceName;
  // @HiveField(9)
  // String? deviceModel;
  // @HiveField(10)
  // String? deviceOS;
  // @HiveField(11)
  // String? deviceVersion;
  // @HiveField(12)
  // String? deviceManufacturer;
  // @HiveField(13)
  // String? deviceID;
  // @HiveField(14)
  // String? deviceLocale;
  // @HiveField(15)
  // String? deviceCountry;
  // @HiveField(16)
  // String? deviceLocality;
  // @HiveField(17)
  // String? devicePostalCode;
  // @HiveField(18)
  // String? deviceSubLocality;
  // @HiveField(19)
  // String? deviceTimeZone;

  UserModel({
    this.name,
    this.email,
    this.password,
    this.photoURL,
    this.uid,
    this.deviceToken,
    this.isLogin,
    this.userNotificationList
    // this.deviceType,
    // this.deviceName,
    // this.deviceModel,
    // this.deviceOS,
    // this.deviceVersion,
    // this.deviceManufacturer,
    // this.deviceID,
    // this.deviceLocale,
    // this.deviceCountry,
    // this.deviceLocality,
    // this.devicePostalCode,
    // this.deviceSubLocality,
    // this.deviceTimeZone,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    photoURL = json['photoURL'];
    uid = json['uid'];
    deviceToken = json['deviceToken'];
    isLogin = json['isLogin'];
    userNotificationList = json['userNotificationList']!= null? List<UserNotification>
                            .from(
                              json['userNotificationList'].map(
                                (x) {
                                  return UserNotification.fromJson(x);
                                }))
                            :
                            null;
    // deviceType = json['deviceType'];
    // deviceName = json['deviceName'];
    // deviceModel = json['deviceModel'];
    // deviceOS = json['deviceOS'];
    // deviceVersion = json['deviceVersion'];
    // deviceManufacturer = json['deviceManufacturer'];
    // deviceID = json['deviceID'];
    // deviceLocale = json['deviceLocale'];
    // deviceCountry = json['deviceCountry'];
    // deviceLocality = json['deviceLocality'];
    // devicePostalCode = json['devicePostalCode'];
    // deviceSubLocality = json['deviceSubLocality'];
    // deviceTimeZone = json['deviceTimeZone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['photoURL'] = photoURL;
    data['uid'] = uid;
    data['deviceToken'] = deviceToken;
    data['isLogin'] = isLogin;
    data['userNotificationList'] = userNotificationList;
    // data['deviceType'] = deviceType;
    // data['deviceName'] = deviceName;
    // data['deviceModel'] = deviceModel;
    // data['deviceOS'] = deviceOS;
    // data['deviceVersion'] = deviceVersion;
    // data['deviceManufacturer'] = deviceManufacturer;
    // data['deviceID'] = deviceID;
    // data['deviceLocale'] = deviceLocale;
    // data['deviceCountry'] = deviceCountry;
    // data['deviceLocality'] = deviceLocality;
    // data['devicePostalCode'] = devicePostalCode;
    // data['deviceSubLocality'] = deviceSubLocality;
    // data['deviceTimeZone'] = deviceTimeZone;
    return data;
  }
}

class UsersAdapter extends TypeAdapter<UserModel>{

  @override
  final typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      name: reader.read(),
      email: reader.read(),
      password: reader.read(),
      photoURL: reader.read(),
      uid: reader.read(),
      deviceToken: reader.read(),
      isLogin: reader.read(),
      userNotificationList: reader.read(),
      // deviceType: reader.read(),
      // deviceName: reader.read(),
      // deviceModel: reader.read(),
      // deviceOS: reader.read(),
      // deviceVersion: reader.read(),
      // deviceManufacturer: reader.read(),
      // deviceID: reader.read(),
      // deviceLocale: reader.read(),
      // deviceCountry: reader.read(),
      // deviceLocality: reader.read(),
      // devicePostalCode: reader.read(),
      // deviceSubLocality: reader.read(),
      // deviceTimeZone: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
     ..write(obj.name)
     ..write(obj.email)
     ..write(obj.password)
     ..write(obj.photoURL)
     ..write(obj.uid)
     ..write(obj.deviceToken)
     ..write(obj.isLogin)
     ..write(obj.userNotificationList);
    //  ..write(obj.deviceType)
    //  ..write(obj.deviceName)
    //  ..write(obj.deviceModel)
    //  ..write(obj.deviceOS)
    //  ..write(obj.deviceVersion)
    //  ..write(obj.deviceManufacturer)
    //  ..write(obj.deviceID)
    //  ..write(obj.deviceLocale)
    //  ..write(obj.deviceCountry)
    //  ..write(obj.deviceLocality)
    //  ..write(obj.devicePostalCode)
    //  ..write(obj.deviceSubLocality)
    //  ..write(obj.deviceTimeZone)
  }
}