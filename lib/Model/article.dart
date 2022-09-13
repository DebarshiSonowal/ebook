class Article {
  int? id, sequence;
  String? title, slug, short_note, profile_pic;

  Article.fromJson(json) {
    id = json['id'] ?? 0;
    sequence = json['sequence'] ?? 0;

    //string
    title = json['title'] ?? "";
    slug = json['slug'] ?? "";
    short_note = json['short_note'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
  }
}
// class ArticleResponse{
//   bool? status;
//   String? message;
//
//   ArticleResponse.fromJson(json){
//     status = json['success']??false;
//     message = json['message']??"Something went wrong";
//   }
//
//   ArticleResponse.withError(msg){
//     status = false;
//     message = msg??"Something went wrong";
//   }
// }
