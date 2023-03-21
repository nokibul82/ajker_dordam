import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import '../widgets/qrscanneroverlay.dart';
import './complain_screen.dart';
import './image_picker_screen.dart';

import '../providers/shops.dart';
import '../providers/complains.dart';

class ScannerScreen extends StatefulWidget {
  static const routeName = "/scannerScreen";
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {

  MobileScannerController cameraController = MobileScannerController();
  var _complain = Complain(id: DateTime.now().toString(), shopId: "", shopName: "", shopImageUrl: "",shopAddress: "", description: "", receiptImageUrl: "");

  void findShop(String code, BuildContext context){
    final Shop shop = Provider.of<Shops>(context, listen: false).findShop(code);
    if (shop != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text(
              "দোকান নিশ্চিত করুন",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Mina Regular',
                  color: Colors.black,
                  fontSize: 24),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shop.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mina Regular',
                      color: Colors.black,
                      fontSize: 24,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:FadeInImage(
                    fadeInCurve: Curves.bounceIn,
                    placeholder:
                    AssetImage('assets/images/placeholder.png'),
                    image: NetworkImage(shop.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                  onPressed: () {
                    _complain = Complain(id: "", shopId: shop.id, shopName: shop.name, shopImageUrl: shop.imageUrl, shopAddress: shop.address,description: "", receiptImageUrl: "");
                    Provider.of<Complains>(context,listen: false).setTemporaryComplain(_complain);
                    Navigator.of(context).pushReplacementNamed(ImagePickerScreen.routeName);
                  },
                  child: Text(
                    "হ্যাঁ নিশ্চিত",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Mina Regular',
                        color: Colors.green,
                        fontSize: 24),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "না আবার চেষ্টা করুন",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Mina Regular',
                        color: Colors.redAccent,
                        fontSize: 24),
                  )),
            ],
          ));
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text(
              "আবার QR স্ক্যান করুন",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Mina Regular',
                  color: Colors.black,
                  fontSize: 24),
            ),
            backgroundColor: Colors.white,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "অভিযোগ",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(ComplainScreen.routeName);
          },
          icon: Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 30.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            onPressed: () {
              cameraController.switchCamera();
            },
            icon: Icon(
              Icons.cameraswitch_rounded,
              color: Colors.black,
            ),
            iconSize: 30.0,
          )
        ],
      ),
      body: Stack(children: [
        MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) async {
              final String code = barcode.rawValue.toString();
              print("================= ${code} =================");
              findShop(code,context);
            }),
        QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))
      ]),
      backgroundColor: Colors.black,
    );
  }
}
