import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String unit;
  final double price;
  final String imageUrl;
  final DateTime created_at;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.unit,
    @required this.imageUrl,
    this.created_at,
  });
}

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'ডিম',
    //     unit: '১ হালি',
    //     price: 50,
    //     description: 'ডিম হলো ভিটামিন যুক্ত খাবার',
    //     imageUrl:
    //         'https://drive.google.com/uc?export=view&id=1IFqYOtepT2EXrT8Af1eb1wS_P0gu5_Ts'),
    // Product(
    //     id: 'p2',
    //     title: 'ডাল',
    //     unit: '১ কেজি',
    //     price: 120,
    //     description: 'ডাল হলো আমিষ যুক্ত খাবার',
    //     imageUrl:
    //         'https://drive.google.com/uc?export=view&id=1q-Kk4AmCHHozUrJaxHhDkmxDymq3rmKJ'),
    // Product(
    //     id: 'p3',
    //     title: 'আলু',
    //     unit: '১ কেজি',
    //     price: 25,
    //     description: 'আলু হলো আমিষ যুক্ত খাবার',
    //     imageUrl:
    //         'https://drive.google.com/uc?export=view&id=19mfWL0etkesQGfV9b7GpxqFILXujm4-g'),
    // Product(
    //     id: 'p4',
    //     title: 'টমেটো',
    //     unit: '১ কেজি',
    //     price: 50,
    //     description: 'টমেটো হলো পুষ্টিকর সবজি',
    //     imageUrl:
    //         'https://drive.google.com/uc?export=view&id=1B7PJnXWRSmR1tyAPGt5Jo0Q7V_jyR6cZ'),
    // Product(
    //     id: 'p5',
    //     title: 'চাল',
    //     unit: '১ কেজি',
    //     price: 55,
    //     description: 'চাল হলো আমিষ যুক্ত খাবার',
    //     imageUrl:
    //         'https://drive.google.com/uc?export=view&id=1AzHpDUdZIc57-m5mXku5ymZ-5hDxaKd1'),
    // Product(
    //     id: 'p6',
    //     title: 'রুই মাছ',
    //     unit: '১ কেজি',
    //     price: 120,
    //     description: 'মাছ হলো আমিষ যুক্ত খাবার',
    //     imageUrl:
    //         'https://drive.google.com/uc?export=view&id=1CCKnv5s1vqZb2Ny1E7JCuWFRWskn-T1x'),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            unit: productData['unit'],
            imageUrl: productData['imageUrl'],
            created_at: DateTime.parse(productData['created_at'])));
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(
          "=================== ${error} ==============\n =============== Error from fetchAndSetProducts Method");
    }
  }

  Future<void> addProduct(Product newProduct) async {
    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    final DateTime createdAt = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': newProduct.title,
            'unit': newProduct.unit,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'created_at': createdAt.toIso8601String()
          }));
      print('==================== PRODUCT POST DONE=================');
      final uploadedProduct = Product(
          id: json.decode(response.body)['name'],
          title: newProduct.title,
          unit: newProduct.unit,
          price: newProduct.price,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          created_at: createdAt);
      _items.add(uploadedProduct);
      notifyListeners();
    } catch (error) {
      print(
          "=================== ${error} ==============\n =============== Error from addProduct Method");
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == productId);
    if (prodIndex >= 0) {
      try{
        final url = Uri.parse(
            'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json');
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'unit': product.unit,
              'price': product.price.toDouble(),
              'description': product.description,
              'imageUrl': product.imageUrl
            }));
      }catch (error) {
        print(
            "=================== ${error} ==============\n =============== Error from \'updateProduct\' Method");
      }
      _items[prodIndex] = product;
      notifyListeners();
    } else {
      print("no id");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);
    _items.removeAt(existingProductIndex);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException(
          "Could not delete product in deleteProduct function.");
    }
    existingProduct = null;
  }
}
