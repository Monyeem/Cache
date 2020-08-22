
import 'package:future_builder_app/pojo/Data.dart';
class Response {
  String category;
  List<Data> data;

  Response({this.category, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}