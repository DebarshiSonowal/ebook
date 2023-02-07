class LoginResponse{
  bool? status;
  String? access_token,message;

  LoginResponse.fromJson(json){
    status = true;
    access_token = json['access_token']??"";
    message=json['message']??"Something went wrong";
  }

  LoginResponse.withError(msg){
    status = false;
    message=msg??"Something went wrong";
  }

}