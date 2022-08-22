
class LogoutResponse{
  bool? status;
  String? message;

  LogoutResponse.fromJson(json){
    status = true;
    message = json as String;
  }
  LogoutResponse.withError(msg){
    status = false;
    message = msg;
  }

}