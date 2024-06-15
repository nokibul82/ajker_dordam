import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProductScreen";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _unitFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _from = GlobalKey<FormState>();
  late File name;
  late File image;
  var _editedProduct = Product(
      id: "", title: "", unit: "", price: 0, description: "", imageUrl: "", created_at: DateTime.now());

  var initValues = {
    'id': '',
    'title': '',
    'unit': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  var _isInit = true;
  var _isLoading = false;
  var _imageSelected = false;
  late String _dropDownValue;

  @override
  void initState() {
    _imageSelected = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'unit': _editedProduct.unit,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': _editedProduct.imageUrl
        };
        _dropDownValue = _editedProduct.unit;
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
    if (!validator!) return;
    _from.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      if (_imageSelected) {
        await Provider.of<Products>(context, listen: false)
            .uploadImage(image, name);
      }
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        if (_imageSelected) {
          await Provider.of<Products>(context, listen: false)
              .uploadImage(image, name);
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
                            imageUrl: _editedProduct.imageUrl, created_at: DateTime.now());
                      },
                    ),
                    DropdownButton(
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
                            _dropDownValue = value.toString() ?? "";
                          });
                          _editedProduct = Product(
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      unit: value.toString() ?? "",
                                      description: _editedProduct.description,
                                      price: _editedProduct.price,
                                      imageUrl: _editedProduct.imageUrl, created_at: DateTime.now());
                        },

                    ),
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
                          imageUrl: _editedProduct.imageUrl, created_at: DateTime.now(),
                        );
                      },
                    ),
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
                            unit: _editedProduct.unit, created_at: DateTime.now());
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.width*0.4,
                            width: MediaQuery.of(context).size.width*0.4,
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
                                                  : FileImage(image)),
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
                                          Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.black,
                                            size: 20,
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
                                        foregroundColor: MyApp.backColor, side: BorderSide(
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
                                          Icon(
                                            Icons.image_rounded,
                                            color: Colors.black,
                                            size: 20,
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
