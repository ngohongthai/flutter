import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final Auth auth;
  Products(this.auth, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProduct() async {
    final authenToken = auth.token;
    final userId = auth.userId;
    if (authenToken == null || userId == null) {
      return;
    }
    final uri = Uri.https('flutter-shop-app-77ea0-default-rtdb.firebaseio.com',
        '/products.json', {'auth': authenToken});
    try {
      final response = await http.get(uri);
      print(jsonDecode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final favoriteUri = Uri.https(
          'flutter-shop-app-77ea0-default-rtdb.firebaseio.com',
          '/userFavorites/$userId.json',
          {'auth': authenToken});

      final favoriteResponse = await http.get(favoriteUri);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProduct = [];
      extractedData.forEach((productId, productData) {
        loadedProduct.add(Product.fromMap(
            productData, productId, favoriteData[productId] ?? false));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> addProduct(Product product) async {
    final authenToken = auth.token;
    if (authenToken == null) {
      return;
    }
    final uri = Uri.https('flutter-shop-app-77ea0-default-rtdb.firebaseio.com',
        '/products.json', {'auth': authenToken});
    try {
      final response = await http.post(uri, body: product.toJson());
      final newProduct =
          product.copyWith(id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final authenToken = auth.token;
    if (authenToken == null) {
      return;
    }
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final uri = Uri.https(
          'flutter-shop-app-77ea0-default-rtdb.firebaseio.com',
          '/products/$id.json',
          {'auth': authenToken});
      try {
        await http.patch(uri, body: newProduct.toJson());
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final authenToken = auth.token;
    if (authenToken == null) {
      return;
    }
    final uri = Uri.https('flutter-shop-app-77ea0-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': authenToken});
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(uri);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
  }
}
