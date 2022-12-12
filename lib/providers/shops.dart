import 'package:flutter/foundation.dart';

class Shop with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final String imageURL;

  Shop(
      {@required this.id,
      @required this.name,
      @required this.address,
      @required this.imageURL});
}

class Shops with ChangeNotifier {
  List<Shop> _items = [
    Shop(
        id: "shop1",
        name: "Bismillah Shop",
        address: "Dhaka,Bangladesh",
        imageURL:
            "https://drive.google.com/uc?export=view&id=1okdfZAMpo7SqgvtRECT02hyg27Vy8Bps"),
    Shop(
        id: "shop2",
        name: "Forkan Store",
        address: "Jatrabari,Dhaka",
        imageURL:
            "https://drive.google.com/uc?export=view&id=1muKQHh9JORmrYqTu4Dx0lMDbx5NM2OM7")
  ];

  List<Shop> get items {
    return [..._items];
  }

  Shop findShop(String id){
    final shopIndex =_items.indexWhere((element) => element.id == id);
    return _items[shopIndex];
  }


}
