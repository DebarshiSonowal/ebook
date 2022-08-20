
class Add_Review{
  int? subscriber_id;
  String? content;
  double? rating;

  Add_Review(this.subscriber_id, this.content, this.rating);

// Add_Review.fromJson(json){
  //   subscriber_id = json['subscriber_id']??0;
  //   content = json['content']??"";
  //   rating = json['rating']==null?0:double.parse(json['rating'].toString());
  // }

}