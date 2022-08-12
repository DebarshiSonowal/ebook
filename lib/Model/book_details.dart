class BookDetailsResponse{
  bool? status;
  String? message;
  BookDetails? details;

  BookDetailsResponse.fromJson(json){
    status = json['success']??false;
    message = json['message']??"Something went wrong";
    details = BookDetails.fromJson(json['result']);
  }

}


class BookDetails {
  int? id,
      product_type_id,
      writer_id,
      book_category_id,
      language_id,
      publisher_id,
      user_id,
      status,
      total_chapters;

  String? title, code, book_format, description, profile_pic, rejected_reason;
  double? average_rating,
      total_rating,
      base_price,
      discount,
      commission_percent,
      commission,
      writer_amount,
      selling_price;
  bool? is_free;

  BookDetails.fromJson(json) {
    id = json['id'] ?? 0;
    product_type_id = json['product_type_id'] ?? 0;
    writer_id = json['writer_id'] ?? 0;
    book_category_id = json['book_category_id'] ?? 0;
    language_id = json['language_id'] ?? 0;
    publisher_id = json['publisher_id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    status = json['status'] ?? 0;
    total_chapters = json['total_chapters'] ?? 0;
    title = json['title'] ?? "";
    code = json['code'] ?? "";
    book_format = json['book_format'] ?? "";
    description = json['description'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
    rejected_reason = json['rejected_reason'] ?? "";
    average_rating = json['average_rating'] == null
        ? 0
        : double.parse(json['average_rating']);
    total_rating =
        json['total_rating'] == null ? 0 : double.parse(json['total_rating']);
    base_price =
        json['base_price'] == null ? 0 : double.parse(json['base_price']);
    discount = json['discount'] == null ? 0 : double.parse(json['discount']);
    commission_percent = json['commission_percent'] == null
        ? 0
        : double.parse(json['commission_percent']);
    commission =
        json['commission'] == null ? 0 : double.parse(json['commission']);
    writer_amount =
        json['writer_amount'] == null ? 0 : double.parse(json['writer_amount']);
    selling_price =
        json['selling_price'] == null ? 0 : double.parse(json['selling_price']);
    is_free = json['is_free'] == null
        ? false
        : json['is_free'] == 0
            ? true
            : false;
  }
}
