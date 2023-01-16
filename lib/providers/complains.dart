import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Complain with ChangeNotifier {
  final String id;
  final String shopId;
  final String shopName;
  final String shopImageUrl;
  String receiptImageUrl;
  String description;

  Complain(
      {@required this.id,
      @required this.shopId,
      @required this.shopName,
      @required this.shopImageUrl,
      @required this.description,
      @required this.receiptImageUrl});
}

class Complains with ChangeNotifier {
  UploadTask _uploadTask;
  Complain _temporaryComplain;

  Complain get temporaryComplain {
    return _temporaryComplain;
  }

  void setTemporaryComplain(Complain value) {
    _temporaryComplain = value;
    notifyListeners();
  }

  List<Complain> _items = [
    Complain(
        id: "C1",
        shopId: "S1",
        shopName: "Bismillah Store",
        shopImageUrl: "",
        description: "This is a vagetable shop.It has a good quality products",
        receiptImageUrl: ""),
    Complain(
        id: "C2",
        shopId: "S2",
        shopName: "Kumilla Store",
        shopImageUrl: "",
        description: "This is a chocolate shop.It has a good quality products",
        receiptImageUrl: ""),
  ];

  List<Complain> get items {
    return [..._items];
  }

  String get getLink {
    return _temporaryComplain.receiptImageUrl;
  }

  void addComplain(Complain complain) {
    final newComplain = Complain(
        id: complain.id,
        shopId: complain.shopId,
        shopName: complain.shopName,
        shopImageUrl: complain.shopImageUrl,
        receiptImageUrl: complain.receiptImageUrl,
        description: complain.description);
    _items.add(newComplain);
  }

  Future<void> uploadImage(File name, image, Complain complain) async {
    final path = 'images/${name}';
    final file = image;

    final ref = FirebaseStorage.instance.ref().child(path);
    _uploadTask = ref.putFile(file);

    final snapshot = await _uploadTask.whenComplete(() {});

    final imageUrl = await snapshot.ref.getDownloadURL();

    _temporaryComplain.receiptImageUrl = imageUrl;
    notifyListeners();
  }
}
