import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/products.dart';
import '../providers/shops.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProductScreen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var shopData = [];
  final _unitFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _from = GlobalKey<FormState>();
  late File name;
  File? image;
  var productId = "";
  var _editedProduct = Product(
      id: "",
      title: "",
      unit: "",
      price: 0,
      description: "",
      imageUrl: "",
      created_at: DateTime.now(),
      shopId: ""
  );

  var initValues = {
    'id': '',
    'title': '',
    'unit': '',
    'price': '',
    'description': '',
    'imageUrl': '',
    'shopId': ''
  };
  var _isInit = true;
  var _isLoading = false;
  var _imageSelected = false;
  String? _dropDownValue;
  String? _selectedShopId;
  List<Map<String, dynamic>> _uniqueShops = [];
  bool _shopsLoaded = false; // Add this flag

  @override
  void initState() {
    _loadShops();
    _imageSelected = false;
    super.initState();
  }

  Future<void> _loadShops() async {
    await Provider.of<Shops>(context, listen: false).fetchAndSetShops();
    final shops = Provider.of<Shops>(context, listen: false).items;

    // Remove duplicate shops based on ID
    final uniqueShopsMap = <String, dynamic>{};
    for (var shop in shops) {
      if (!uniqueShopsMap.containsKey(shop.id)) {
        uniqueShopsMap[shop.id] = shop;
      }
    }

    setState(() {
      shopData = uniqueShopsMap.values.toList();
      _uniqueShops = _getUniqueShops(shopData);
      _shopsLoaded = true; // Set flag when shops are loaded

      // Set initial shop value after shops are loaded
      if (productId.isNotEmpty && _editedProduct.shopId.isNotEmpty) {
        _selectedShopId = _editedProduct.shopId;
      }
    });
  }

  // Helper method to get unique shops
  List<Map<String, dynamic>> _getUniqueShops(List shops) {
    final uniqueShops = <String, Map<String, dynamic>>{};

    for (var shop in shops) {
      final shopId = shop.id.toString();
      if (!uniqueShops.containsKey(shopId)) {
        uniqueShops[shopId] = {
          'id': shopId,
          'name': shop.name.toString(),
          'shop': shop,
        };
      }
    }

    return uniqueShops.values.toList();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      productId = ModalRoute.of(context)!.settings.arguments.toString();
      if (productId != "") {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'unit': _editedProduct.unit,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': _editedProduct.imageUrl,
          'shopId': _editedProduct.shopId
        };
        _dropDownValue = _editedProduct.unit;
        // Don't set _selectedShopId here, wait for shops to load
      } else {
        // For new product, set default values
        _dropDownValue = null;
        _selectedShopId = null;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final tempPath = File(image.path);
      final tempName = File(image.name);
      setState(() {
        this.image = tempPath;
        this.name = tempName;
        _imageSelected = true;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final validator = _from.currentState?.validate();
    if(_dropDownValue == null || _dropDownValue!.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select unit")));
      return;
    }
    // Validate shop selection
    if (_selectedShopId == null || _selectedShopId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a shop")));
      return;
    }
    if (!validator!) return;

    _from.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (productId != "") {
      if (_imageSelected) {
        await Provider.of<Products>(context, listen: false)
            .uploadImage(image!, name);
      }
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        if (_imageSelected) {
          await Provider.of<Products>(context, listen: false)
              .uploadImage(image!, name);
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Please Choose Image")));
          setState(() {
            _isLoading = false;
          });
          return;
        }
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("An error occurred"),
                content: Text("Something went wrong !"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay"))
                ],
              );
            });
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // Safe method to get shop name by ID
  String _getShopName(String shopId) {
    try {
      final shop = _uniqueShops.firstWhere(
            (shop) => shop['id'] == shopId,
        orElse: () => {'name': 'Unknown Shop'},
      );
      return shop['name'];
    } catch (e) {
      return 'Unknown Shop';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          " হালনাগাদ",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _from,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                initialValue: initValues['title'],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_unitFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please give some proper value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value ?? "",
                      unit: _editedProduct.unit,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      created_at: DateTime.now(),
                      shopId: _editedProduct.shopId);
                },
              ),

              const SizedBox(height: 16),

              // Shop Selection Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _shopsLoaded
                    ? DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedShopId,
                  hint: Text(
                    "দোকান নির্বাচন করুন",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  items: [
                    // Unique shop items
                    ..._uniqueShops.map<DropdownMenuItem<String>>((shopMap) {
                      final shopId = shopMap['id'].toString();
                      final shopName = shopMap['name'].toString();

                      return DropdownMenuItem<String>(
                        value: shopId,
                        child: Text(
                          shopName,
                          style: TextStyle(
                            fontFamily: 'Mina Regular',
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedShopId = newValue;
                    });
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      unit: _editedProduct.unit,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      created_at: DateTime.now(),
                      shopId: newValue!,
                    );
                  },
                )
                    : Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text("Loading shops..."),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),


              const SizedBox(height: 16),

              // Unit Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  items: const [
                    DropdownMenuItem(
                      child: Text("১ কেজি"),
                      value: "১ কেজি",
                    ),
                    DropdownMenuItem(
                      child: Text("১ লিটার"),
                      value: "১ লিটার",
                    ),
                    DropdownMenuItem(
                      child: Text("১ ডজন"),
                      value: "১ ডজন",
                    ),
                    DropdownMenuItem(
                      child: Text("১ পিস"),
                      value: "১ পিস",
                    ),
                  ],
                  value: _dropDownValue,
                  onChanged: (value) {
                    setState(() {
                      _dropDownValue = value.toString();
                    });
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        unit: value.toString(),
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        created_at: DateTime.now(),
                        shopId: _editedProduct.shopId);
                  },
                  hint: Text(
                    "একক নির্বাচন করুন",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                initialValue: initValues['price'],
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please enter a price more than zero";
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      unit: _editedProduct.unit,
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl,
                      created_at: DateTime.now(),
                      shopId: _editedProduct.shopId
                  );
                },
              ),

              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                initialValue: initValues['description'],
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter some description";
                  }
                  if (value.length < 10) {
                    return "Please enter more then 10 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      description: value ?? "",
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      unit: _editedProduct.unit,
                      created_at: DateTime.now(),
                      shopId: _editedProduct.shopId);
                },
              ),

              const SizedBox(height: 16),

              // Image Selection Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.width * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.only(top: 80, right: 10),
                      decoration: BoxDecoration(
                          border:
                          Border.all(width: 1, color: Colors.grey)),
                      child: Center(
                        child: image == null &&
                            initValues['imageUrl']!.isEmpty && !_imageSelected
                            ? Text(
                          "Choose an image",
                          textAlign: TextAlign.center,
                        )
                            : FittedBox(
                          child: FadeInImage(
                              placeholder: AssetImage(
                                  'assets/images/placeholder.png'),
                              image:
                              _editedProduct.imageUrl.isNotEmpty && !_imageSelected
                                  ? Image.network(
                                  initValues['imageUrl']!).image
                                  : FileImage(image!)),
                        ),
                      )),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height:
                          MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                pickImage(ImageSource.camera);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyApp.backColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18.0),
                                ),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "ছবি তুলুন",
                                      style: TextStyle(
                                          fontFamily: 'Mina Regular',
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.01),
                        SizedBox(
                          height:
                          MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: OutlinedButton(
                              onPressed: () {
                                pickImage(ImageSource.gallery);
                              },
                              style: OutlinedButton.styleFrom(
                                  foregroundColor: MyApp.backColor,
                                  side: BorderSide(
                                      width: 2, color: Colors.black),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(18.0),
                                  )),
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "গ্যালারি থেকে",
                                      style: TextStyle(
                                          fontFamily: 'Mina Regular',
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Icon(
                                        Icons.image_rounded,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}