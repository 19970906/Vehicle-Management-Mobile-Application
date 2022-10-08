class UserModel {
  String id;
  String userName;
  String garageName;
  String garageId;
  String userType;
  String token;
  String loginStatus;

  UserModel({
    required this.id,
    required this.userName,
    required this.garageName,
    required this.garageId,
    required this.userType,
    required this.token,
    required this.loginStatus,
  });

  UserModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        userName = map['username'],
        garageName = map['garageName'],
        garageId = map['garageId'],
        userType = map['usertype'],
        token = map['token'],
        loginStatus = map['loginstatus'];
}
