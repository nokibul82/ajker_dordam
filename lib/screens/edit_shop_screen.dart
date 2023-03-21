import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shops.dart';
import './qr_generate_screen.dart';

class EditShopScreen extends StatefulWidget {
  static const routeName = "/editShopScreen";
  @override
  State<EditShopScreen> createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  final _addressFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _from = GlobalKey<FormState>();
  var _editedShop = Shop(id: null, name: "", address: "", imageUrl: "");
  var _isInit = true;
  var initValues = {'id': '', 'name': '', 'address': '', 'imageUrl': ''};
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedShop =
            Provider.of<Shops>(context, listen: false).findShop(productId);
        initValues = {
          'name': _editedShop.name,
          'address': _editedShop.address,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedShop.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageURL);
    _addressFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith("http") &&
          !_imageUrlController.text.startsWith("https")) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final validator = _from.currentState.validate();
    if (!validator) return;
    _from.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedShop.id != null) {
      await Provider.of<Shops>(context, listen: false)
          .updateShop(_editedShop.id, _editedShop);
    } else {
      try {
        await Provider.of<Shops>(context, listen: false).addShop(_editedShop,context);
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
                  ]);
            });
      }
      await Navigator.of(context).pushNamed(QrGenerateScreen.routeName);
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
                          initialValue: initValues['name'],
                          decoration: InputDecoration(labelText: "Name"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_addressFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please give some proper value";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedShop = Shop(
                                id: _editedShop.id,
                                name: value,
                                address: _editedShop.address,
                                imageUrl: _editedShop.imageUrl);
                          },
                        ),
                        TextFormField(
                          initialValue: initValues['address'],
                          decoration: InputDecoration(labelText: "Address"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_imageUrlFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please give some proper value";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedShop = Shop(
                                id: _editedShop.id,
                                name: _editedShop.name,
                                address: value,
                                imageUrl: _editedShop.imageUrl);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.only(top: 80, right: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? Text("No URL Given")
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please give some proper value";
                                  }
                                  if (!value.startsWith("http") ||
                                      !value.startsWith("https")) {
                                    return "Please enter a valid URL";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedShop = Shop(
                                      id: _editedShop.id,
                                      name: _editedShop.name,
                                      address: _editedShop.address,
                                      imageUrl: value);
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ));
  }
}
