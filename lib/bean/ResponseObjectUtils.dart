class Response {
  String message;
  bool success;
  int code;
}

class ResponseObject<T> extends Response {
  T data;
}

class TokenUser<T> {
  T userInfo;
}

class UserEntity {
  String userId;
  String userName;
  String mobilePhone;
  String screenName;
  String realName;
  String idNumber;
  String password;
  String emailAddress;
  String walletId;
  DateTime lastLoginDate;
  String urlHead;
  String weChatId;
  String superUserId;
  String balance;
}
