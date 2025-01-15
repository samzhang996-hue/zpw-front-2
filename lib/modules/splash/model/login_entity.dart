// To parse this JSON data, do
//
//     final loginEntity = loginEntityFromJson(jsonString);

import 'dart:convert';

LoginEntity loginEntityFromJson(String str) => LoginEntity.fromJson(json.decode(str));

String loginEntityToJson(LoginEntity data) => json.encode(data.toJson());

class LoginEntity {
	String? authToken;
	String? headImg;
	int? id;
	bool? isSignTask;
	dynamic invatecode;
	bool? isMember;
	bool? isGuide;
	bool? isNewUser;
	bool? isWxOauth;
	dynamic memberExpirationTime;
	String? nickName;
	int? sex;
	dynamic userPhone;

	LoginEntity({
		this.authToken,
		this.headImg,
		this.id,
		this.isSignTask,
		this.invatecode,
		this.isMember,
		this.isGuide ,
		this.isNewUser,
		this.isWxOauth,
		this.memberExpirationTime,
		this.nickName,
		this.sex,
		this.userPhone,
	});

	factory LoginEntity.fromJson(Map<String, dynamic> json) => LoginEntity(
		authToken: json["authToken"],
		headImg: json["headImg"],
		id: json["id"],
		isSignTask: json["isSignTask"],
		invatecode: json["invatecode"],
		isMember: json["isMember"],
		isGuide: json["isGuide"],
		isNewUser: json["isNewUser"],
		isWxOauth: json["isWxOauth"],
		memberExpirationTime: json["memberExpirationTime"],
		nickName: json["nickName"],
		sex: json["sex"],
		userPhone: json["userPhone"],
	);

	Map<String, dynamic> toJson() => {
		"authToken": authToken,
		"headImg": headImg,
		"id": id,
		"isSignTask": isSignTask,
		"invatecode": invatecode,
		"isMember": isMember,
		"isGuide": isGuide,
		"isNewUser": isNewUser,
		"isWxOauth": isWxOauth,
		"memberExpirationTime": memberExpirationTime,
		"nickName": nickName,
		"sex": sex,
		"userPhone": userPhone,
	};
}
