import 'package:flutter/foundation.dart';

class BazarListModel {
  final String id;
  final String title;
  final int quantity;
  final String unit;
  final double price;

  BazarListModel(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.unit,
      required this.price});
}

class BazarList with ChangeNotifier {
  Map<String, BazarListModel> _items = {};

  Map<String, BazarListModel> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, bazarlistitem) {
      total += bazarlistitem.price * bazarlistitem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (oldItem) => BazarListModel(
              id: oldItem.id,
              title: oldItem.title,
              quantity: oldItem.quantity + 1,
              unit: oldItem.unit,
              price: oldItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => BazarListModel(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              unit: "1",
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItemCard(String productId) {
    if (!_items.containsKey(productId)) {}
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingListItem) => BazarListModel(
              id: existingListItem.id,
              title: existingListItem.title,
              quantity: existingListItem.quantity - 1,
              unit: existingListItem.unit,
              price: existingListItem.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
