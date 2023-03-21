import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../providers/shops.dart';

class QrGenerateScreen extends StatefulWidget {
  static const routeName = "/qrGeneratorScreen";

  @override
  State<QrGenerateScreen> createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen> {
  final widgetsToImageController = WidgetsToImageController();

  var lastshop = Shop(id: "", name: "", address: "", imageUrl: "");

  @override
  void initState(){
    try {
      Provider.of<Shops>(context, listen: false).fetchAndSetShops();
      final shops = Provider.of<Shops>(context, listen: false).items;
      lastshop = shops[shops.length - 1];
    } catch (error) {
      print(error);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "QR overview",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              WidgetsToImage(
                controller: widgetsToImageController,
                child: Column(
                  children: [
                    Text(
                      lastshop.name,
                      style: TextStyle(
                          fontFamily: 'Mina Regular',
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5),
                    QrImage(data: lastshop.id, version: QrVersions.auto, size: MediaQuery.of(context).size.width-5, backgroundColor: Colors.white,)
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  var status = await Permission.storage.request();
                  if (status.isGranted) {
                    var image = await widgetsToImageController.capture();
                    if (image != null) {
                      Directory directory = await getExternalStorageDirectory();
                      print(directory);
                      var file = await File(
                              "${directory.path}/${lastshop.name}${DateTime.now()}.png")
                          .create(recursive: true)
                          .whenComplete(() {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("QR image saved at $directory")));
                      }).catchError((error) {
                        print(error);
                      });
                      await file.writeAsBytes(image);
                    }
                  }
                },
                child: Text(
                  "কিউ আর সংরক্ষণ করুন",
                  style: TextStyle(
                      fontFamily: 'Mina Regular',
                      color: Colors.black,
                      fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    primary: Theme.of(context).primaryColor),
              )
            ],
          )),
    );
  }
}
