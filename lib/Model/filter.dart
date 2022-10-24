import 'dart:convert';

class Filter {
  bool? success;
  String? message;
  Map<String, String>? categories, authors, awards;
  Filter.fromJson(json){
    success = json['success']??false;
    message = json['message']??"Something went wrong";
    categories = Map<String, String>.from(json['result']['categories']);
    authors = Map<String, String>.from(json['result']['authors']);
    awards = Map<String, String>.from(json['result']['awards']);
  }
  Filter.withError(msg){
    success = false;
    message = msg ?? "Something went wrong";
  }
}
