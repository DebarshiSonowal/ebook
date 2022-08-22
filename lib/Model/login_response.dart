class LoginResponse{
  bool? status;
  String? access_token;

  LoginResponse.fromJson(json){
    status = true;
    access_token = json['access_token']??"";
  }

  LoginResponse.withError(){
    status = false;
  }

}