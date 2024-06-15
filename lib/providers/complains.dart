import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Complain with ChangeNotifier {
  final String id;
  final String shopId;
  final String shopName;
  final String shopImageUrl;
  final String shopAddress;
  String receiptImageUrl;
  String description;
  DateTime dateTime;

  Complain(
      {required this.id,
      required this.shopId,
      required this.shopName,
      required this.shopImageUrl,
      required this.shopAddress,
      required this.description,
      required this.receiptImageUrl,
      required this.dateTime});
}

class Complains with ChangeNotifier {
  late UploadTask _uploadTask;
  late Complain _temporaryComplain;
  late File _name;
  late File _image;

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

  List<Complain> _items = [];

  List<Complain> get items {
    return [..._items];
  }

  Future<void> fetchAndSetComplains() async {
    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/complains.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Complain> loadedComplains = [];
      extractedData.forEach((comId, complainData) {
        loadedComplains.add(Complain(
            id: comId,
            shopId: complainData['shopId'],
            shopName: complainData['shopName'],
            shopAddress: (complainData['shopAddress']),
            shopImageUrl: complainData['shopImageUrl'],
            receiptImageUrl: complainData['receiptImageUrl'],
            description: complainData['description'],
            dateTime: DateTime.parse(complainData['dateTime'])));
      });

      _items = loadedComplains;
      notifyListeners();
    } catch (error) {
      print(" ${error} \nError from fetch and set complain method");
    }
  }

  Future<void> addComplain() async {
    DateTime dateTime = DateTime.now();

    final url = Uri.parse(
        'https://ajker-dordam-default-rtdb.asia-southeast1.firebasedatabase.app/complains.json');

    try {
      final response = await http.post(url,
          body: json.encode({
            'shopId': _temporaryComplain.shopId,
            'shopName': _temporaryComplain.shopName,
            'shopImageUrl': _temporaryComplain.shopImageUrl,
            'shopAddress': _temporaryComplain.shopAddress,
            'receiptImageUrl': _temporaryComplain.receiptImageUrl,
            'description': _temporaryComplain.description,
            'dateTime': dateTime
          }));
      print("data post done");
      final newComplain = Complain(
          id: json.decode(response.body)['name'],
          shopId: _temporaryComplain.shopId,
          shopName: _temporaryComplain.shopName,
          shopImageUrl: _temporaryComplain.shopImageUrl,
          shopAddress: _temporaryComplain.shopAddress,
          receiptImageUrl: _temporaryComplain.receiptImageUrl,
          description: _temporaryComplain.description,
          dateTime: dateTime);
      _items.add(newComplain);
      notifyListeners();
    } catch (error) {
      print("${error} \nError from add complain method");
    }
  }

  Future<void> uploadImage() async {
    final path = 'images/${_name}';
    final file = _image;

    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      _uploadTask = ref.putFile(file);

      final snapshot = await _uploadTask.whenComplete(() {});

      final imageUrl = await snapshot.ref.getDownloadURL();

      _temporaryComplain.receiptImageUrl = imageUrl;
      notifyListeners();
    } catch (error) {
      print("$error \nError from upload Image method ");
    }
  }
}
