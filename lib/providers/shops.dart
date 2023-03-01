import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Shop with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final String imageURL;
  final DateTime created_at;

  Shop(
      {@required this.id,
      @required this.name,
      @required this.address,
      @required this.imageURL,
      this.created_at});
}

class Shops with ChangeNotifier {
  List<Shop> _items = [
    Shop(
        id: "shop1",
        name: "বিসমিল্লাহ্ স্টোর‌",
        address: "ঢাকা,বাংলাদেশ",
        imageURL:
            "https://drive.google.com/uc?export=view&id=1okdfZAMpo7SqgvtRECT02hyg27Vy8Bps"),
    Shop(
        id: "shop2",
        name: "ফোরকান স্টোর",
        address: "যাত্রাবাড়ী,ঢাকা",
        imageURL:
            "https://drive.google.com/uc?export=view&id=1muKQHh9JORmrYqTu4Dx0lMDbx5NM2OM7")
  ];

  List<Shop> get items {
    return [..._items];
  }

  Shop findShop(String id) {
    final shopIndex = _items.indexWhere((element) => element.id == id);
    return _items[shopIndex];
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
            name: shopData.name,
            address: shopData.address,
            imageURL: shopData.imageURL));
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
            'imageUrl': newShop.imageURL,
            'created_at': createdAt.toIso8601String()
          }));
      print('==================== SHOP POST DONE=================');
      final uploadedShop = Shop(id: json.decode(response.body)['name'],
    name: newShop.name, address: newShop.address, imageURL: newShop.imageURL,created_at: createdAt);
    _items.add(uploadedShop);
    notifyListeners();
    } catch (error) {
      print(
          "=================== ${error} ==============\n =============== Error from \'addShop\' Method");
    }
  }

  Future<void> updateShop(String shopId, Shop shop) async{
    final shopIndex = _items.indexWhere((shop) => shop.id == shopId);
    if(shopIndex>=0){

      try{
        final url = Uri.parse(
            'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/shops/$shopId.json');
      }catch (error) {
        print(
            "=================== ${error} ==============\n =============== Error from \'updateShop\' Method");
      }

    }else{
      print("=====================  No ID FOUND in updateShop METHOD =================================");
    }
  }
}
