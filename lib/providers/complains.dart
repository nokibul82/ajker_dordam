import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Complain with ChangeNotifier {
  final String id;
  final String shopId;
  final String shopName;
  final String shopImageUrl;
  final String shopAddress;
  String receiptImageUrl;
  String description;

  Complain(
      {@required this.id,
      @required this.shopId,
      @required this.shopName,
      @required this.shopImageUrl,
      @required this.shopAddress,
      @required this.description,
      @required this.receiptImageUrl});
}

class Complains with ChangeNotifier {
  UploadTask _uploadTask;
  Complain _temporaryComplain;
  File _name;
  File _image;



  void setName(File value) {
    _name = value;
    notifyListeners();
  }


  void setImage(File value) {
    _image = value;
    notifyListeners();
  }

  File get getImage => _image;

  Complain get temporaryComplain => _temporaryComplain;

  void setTemporaryComplain(Complain value) {
    _temporaryComplain = value;
    notifyListeners();
  }

  List<Complain> _items = [
  ];

  List<Complain> get items {
    return [..._items];
  }

  void addComplain(Complain complain) {
    final newComplain = Complain(
        id: complain.id,
        shopId: complain.shopId,
        shopName: complain.shopName,
        shopImageUrl: complain.shopImageUrl,
        shopAddress: complain.shopAddress,
        receiptImageUrl: complain.receiptImageUrl,
        description: complain.description);
    _items.add(newComplain);
  }

  Future<void> uploadImage(Complain complain) async {
    final path = 'images/${_name}';
    final file = _image;

    final ref = FirebaseStorage.instance.ref().child(path);
    _uploadTask = ref.putFile(file);

    final snapshot = await _uploadTask.whenComplete(() {});

    final imageUrl = await snapshot.ref.getDownloadURL();

    _temporaryComplain.receiptImageUrl = imageUrl;
    notifyListeners();
  }
}
