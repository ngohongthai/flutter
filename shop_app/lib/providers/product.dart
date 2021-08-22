import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String? authToken, String? userId) async {
    if (authToken == null || userId == null) {
      return;
    }
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final uri = Uri.https('flutter-shop-app-77ea0-default-rtdb.firebaseio.com',
        '/userFavorites/$userId/$id.json', {'auth': authToken});
    try {
      final response = await http.put(uri, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (e) {
      _setFavoriteValue(oldStatus);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromMap(
      Map<String, dynamic> map, String productId, bool isFavorite) {
    return Product(
        id: productId,
        title: map['title'],
        description: map['description'],
        price: map['price'],
        imageUrl: map['imageUrl'],
        isFavorite: isFavorite);
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Product(id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        imageUrl.hashCode ^
        isFavorite.hashCode;
  }
}
