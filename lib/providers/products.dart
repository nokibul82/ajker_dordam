import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final String unit;
  final double price;
  final String imageUrl;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.unit,
    @required this.imageUrl
});


}

class Products with ChangeNotifier{

  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'ডিম',
      unit: '১ হালি',
      price: 50,
      description: 'ডিম হলো ভিটামিন যুক্ত খাবার',
      imageUrl: 'https://drive.google.com/uc?export=view&id=1IFqYOtepT2EXrT8Af1eb1wS_P0gu5_Ts'
    ),
    Product(
        id: 'p2',
        title: 'ডাল',
        unit: '১ কেজি',
        price: 120,
        description: 'ডাল হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1q-Kk4AmCHHozUrJaxHhDkmxDymq3rmKJ'
    ),
    Product(
        id: 'p3',
        title: 'আলু',
        unit: '১ কেজি',
        price: 25,
        description: 'আলু হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=19mfWL0etkesQGfV9b7GpxqFILXujm4-g'
    ),
    Product(
        id: 'p4',
        title: 'টমেটো',
        unit: '১ কেজি',
        price: 70,
        description: 'টমেটো হলো পুষ্টিকর সবজি',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1B7PJnXWRSmR1tyAPGt5Jo0Q7V_jyR6cZ'
    ),
    Product(
        id: 'p5',
        title: 'চাল',
        unit: '১ কেজি',
        price: 55,
        description: 'চাল হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1AzHpDUdZIc57-m5mXku5ymZ-5hDxaKd1'
    ),
    Product(
        id: 'p6',
        title: 'ডাল',
        unit: '১ কেজি',
        price: 120,
        description: 'ডাল হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1CCKnv5s1vqZb2Ny1E7JCuWFRWskn-T1x'
    ),
    Product(
        id: 'p7',
        title: 'ডিম',
        unit: '১ হালি',
        price: 50,
        description: 'ডিম হলো ভিটামিন যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1IFqYOtepT2EXrT8Af1eb1wS_P0gu5_Ts'
    ),
    Product(
        id: 'p8',
        title: 'ডাল',
        unit: '১ কেজি',
        price: 120,
        description: 'ডাল হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1q-Kk4AmCHHozUrJaxHhDkmxDymq3rmKJ'
    ),
    Product(
        id: 'p9',
        title: 'আলু',
        unit: '১ কেজি',
        price: 25,
        description: 'আলু হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=19mfWL0etkesQGfV9b7GpxqFILXujm4-g'
    ),
    Product(
        id: 'p10',
        title: 'টমেটো',
        unit: '১ কেজি',
        price: 70,
        description: 'টমেটো হলো পুষ্টিকর সবজি',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1B7PJnXWRSmR1tyAPGt5Jo0Q7V_jyR6cZ'
    ),
    Product(
        id: 'p11',
        title: 'চাল',
        unit: '১ কেজি',
        price: 55,
        description: 'চাল হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1AzHpDUdZIc57-m5mXku5ymZ-5hDxaKd1'
    ),
    Product(
        id: 'p12',
        title: 'ডাল',
        unit: '১ কেজি',
        price: 130,
        description: 'ডাল হলো আমিষ যুক্ত খাবার',
        imageUrl: 'https://drive.google.com/uc?export=view&id=1CCKnv5s1vqZb2Ny1E7JCuWFRWskn-T1x'
    ),
  ];


  List<Product> get items {
    return [..._items];
  }



}