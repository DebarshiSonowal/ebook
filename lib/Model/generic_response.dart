
class GenericResponse{
  bool? status;
  String? message;

  GenericResponse.fromJson(json){
    status = json['success']??false;
    message = json['message']??"Something went wrong";
  }

  GenericResponse.withError(msg){
    status = false;
    message = msg??"Something went wrong";
  }

}