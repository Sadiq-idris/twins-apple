import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.stockNo,
    required this.createAt,
  });
  final String name;
  final String description;
  final double price;
  final List<dynamic> images;
  final int stockNo;
  final Timestamp createAt;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "images": images,
      "stockNo": stockNo,
      "createAt": createAt,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json["name"],
      description: json["description"],
      price: json["price"],
      images: json["images"],
      stockNo: json["stockNo"],
      createAt: json["createAt"],
    );
  }
}
