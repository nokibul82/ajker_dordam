import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/shops.dart';
import './qr_generate_screen.dart';

class EditShopScreen extends StatefulWidget {
  static const routeName = "/editShopScreen";
  @override
  State<EditShopScreen> createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _addressFocusNode = FocusNode();
  final _from = GlobalKey<FormState>();
  var _editedShop = Shop(id: "1", name: "", address: "", imageUrl: "", created_at: DateTime.now());
  var initValues = {'id': '', 'name': '', 'address': '', 'imageUrl': ''};

  late File name;
  late File image;

  var _isInit = true;
  var _isLoading = false;
  var _imageSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;
      _editedShop =
          Provider.of<Shops>(context, listen: false).findShop(productId)!;
      initValues = {
        'name': _editedShop.name,
        'address': _editedShop.address,
        'imageUrl': _editedShop.imageUrl
      };
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
    _addressFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final validator = _from.currentState?.validate();
    if (!validator!) return;
    _from.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_imageSelected) {
      await Provider.of<Shops>(context, listen: false)
          .uploadImage(image, name);
    }
    await Provider.of<Shops>(context, listen: false)
        .updateShop(_editedShop.id, _editedShop);
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
                          initialValue: initValues['name'],
                          decoration: InputDecoration(labelText: "Name"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_addressFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please give some proper value";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedShop = Shop(
                                id: _editedShop.id,
                                name: value ?? "",
                                address: _editedShop.address,
                                imageUrl: _editedShop.imageUrl, created_at: DateTime.now());
                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          initialValue: initValues['address'],
                          decoration: InputDecoration(labelText: "Address"),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please give some proper value";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedShop = Shop(
                                id: _editedShop.id,
                                name: _editedShop.name,
                                address: value!,
                                imageUrl: _editedShop.imageUrl, created_at: DateTime.now());
                          },
                        ),
                        SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                height: MediaQuery.of(context).size.width * 0.4,
                                width: MediaQuery.of(context).size.width * 0.4,
                                margin: EdgeInsets.only(top: 80, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey)),
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
                                              image: _editedShop
                                                      .imageUrl.isNotEmpty && !_imageSelected
                                                  ? Image.network(
                                                      initValues['imageUrl']!).image
                                                  : FileImage(image)),
                                        ),
                                )),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                    )),
              ));
  }
}
