import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Shop with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final DateTime created_at;

  Shop({
      required this.id,
      required this.name,
      required this.address,
      required this.imageUrl,
      required this.created_at
  });
}

class Shops with ChangeNotifier {
  List<Shop> _items = [
    // Shop(
    //     id: "shop1",
    //     name: "বিসমিল্লাহ্ স্টোর‌",
    //     address: "ঢাকা,বাংলাদেশ",
    //     imageUrl:
    //         "https://drive.google.com/uc?export=view&id=1okdfZAMpo7SqgvtRECT02hyg27Vy8Bps",
    //     created_at: DateTime.now()),
    // Shop(
    //     id: "shop2",
    //     name: "ফোরকান স্টোর",
    //     address: "যাত্রাবাড়ী,ঢাকা",
    //     imageUrl:
    //         "https://drive.google.com/uc?export=view&id=1muKQHh9JORmrYqTu4Dx0lMDbx5NM2OM7",
    //     created_at: DateTime.now()),
  //  Shop(
  //     id: "shop2",
  //     name: "কুমিল্লা স্টোর",
  //     address: "কুমিল্লা",
  //     imageUrl:
  //         "https://drive.google.com/uc?export=view&id=1muKQHh9JORmrYqTu4Dx0lMDbx5NM2OM7",
  //     created_at: DateTime.now()),
  ];

  List<Shop> get items {
    return [..._items];
  }

  late String _imageUrl;

  Shop? findShop(String id){
    try{
      return _items.firstWhere((element) => element.id == id);
    }catch (error) {
      print(
          "=================== ${error} ==============\n =========== Error from findShop Method=============");
      return null;
    }
  }

  Future<void> fetchAndSetShops() async {
    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/shops.json');

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Shop> loadedShops = [];
      extractedData.forEach((shopId, shopData) {
        loadedShops.add(Shop(
            id: shopId,
            name: shopData['name'],
            address: shopData['address'],
            imageUrl: shopData['imageUrl'],
            created_at: DateTime.parse(shopData['created_at'])
        ));
      });

      _items = loadedShops;
      notifyListeners();
    } catch (error) {
      print(
          "=================== ${error} ==============\n =============== Error from fetchAndSetShops Method");
    }
  }


  Future<void> addShop(Shop newShop) async {
    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/shops.json');
    final DateTime createdAt = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'name': newShop.name,
            'address': newShop.address,
            'imageUrl': _imageUrl,
            'created_at': createdAt.toIso8601String()
          }));
      print('==================== SHOP POST DONE=================');
      final uploadedShop = Shop(
          id: json.decode(response.body)['name'],
          name: newShop.name,
          address: newShop.address,
          imageUrl: _imageUrl,
          created_at: createdAt);
      _items.add(uploadedShop);
      _imageUrl = "";
      notifyListeners();
    } catch (error) {
      print(
          "=================== ${error} ==============\n =============== Error from \'addShop\' Method");
    }
  }

  Future<void> updateShop(String shopId, Shop shop) async {
    final shopIndex = _items.indexWhere((shop) => shop.id == shopId);
    if (shopIndex >= 0) {
      try {
        final url = Uri.parse(
            'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/shops/$shopId.json');
        await http.patch(url,
        body: json.encode({
          'name': shop.name,
          'address': shop.address,
          'imageUrl':_imageUrl.isEmpty ? shop.imageUrl : _imageUrl
        })
        );
      } catch (error) {
        print(
            "=================== ${error} ==============\n =============== Error from \'updateShop\' Method");
      }
      _items[shopIndex] = shop;
      notifyListeners();
    } else {
      print(
          "=====================  No ID FOUND in updateShop METHOD =================================");
    }
  }

  Future<void> deleteShop(String shopId) async {
    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/shops/$shopId.json');
    var existingShopIndex = _items.indexWhere((element) => element.id == shopId);
    Shop? existingShop = _items[existingShopIndex];
    final response = await http.delete(url);
    _items.removeAt(existingShopIndex);
    notifyListeners();
    if( response.statusCode >= 400){
      _items.insert(existingShopIndex, existingShop);
      notifyListeners();
      throw HttpException("Could not delete Shop in deleteShop function.");
    } else FirebaseStorage.instance.refFromURL(existingShop.imageUrl);
    existingShop = null;
  }


  Future<void> uploadImage(File image,File name) async {
    final path = 'images/${name}';
    final file = image;

    try {
      final ref = FirebaseStorage.instance.ref().child(path);

      UploadTask uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});

      _imageUrl = await snapshot.ref.getDownloadURL();

      notifyListeners();
    } catch (error) {
      print("$error \nError from product upload Image method ");
    }
  }
}
