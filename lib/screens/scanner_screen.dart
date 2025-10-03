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
  // Move controller outside build method and make it late final
  late final MobileScannerController cameraController;
  var _complain = Complain(
      id: DateTime.now().toString(),
      shopId: "",
      shopName: "",
      shopImageUrl: "",
      shopAddress: "",
      description: "",
      receiptImageUrl: "",
      dateTime: DateTime.now());
  bool _isShowingSnackbar = false;
  bool _isShowedDialog = false;

  @override
  void initState() {
    _isShowedDialog = false;
    super.initState();
    // Initialize controller once when widget is created
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    // Properly dispose the controller when widget is destroyed
    cameraController.dispose();
    super.dispose();
  }

  void findShop(String code, BuildContext context) {
    final Shop? shop =
    Provider.of<Shops>(context, listen: false).findShop(code);
    print("found shop: ${shop?.name}");
    if (shop != null) {
      if(!_isShowedDialog){
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
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage(
                          fadeInCurve: Curves.bounceIn,
                          placeholder:
                              AssetImage('assets/images/placeholder.png'),
                          image: NetworkImage(shop.imageUrl),
                          fit: BoxFit.cover,
                          width: 200,
                          height: 150,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  actions: [
                    TextButton(
                        onPressed: () {
                          _complain = Complain(
                              id: "",
                              shopId: shop.id,
                              shopName: shop.name,
                              shopImageUrl: shop.imageUrl,
                              shopAddress: shop.address,
                              description: "",
                              receiptImageUrl: "",
                              dateTime: DateTime.now());
                          Provider.of<Complains>(context, listen: false)
                              .setTemporaryComplain(_complain);
                          Navigator.of(context).pushReplacementNamed(
                              ImagePickerScreen.routeName);
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
        this.dispose();
        _isShowedDialog = true;
      }
    } else {
      if (!_isShowingSnackbar) {
        _isShowingSnackbar = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to find the shop. try again."),
            duration: Duration(seconds: 2),
          ),
        ).closed.then((_) {
          _isShowingSnackbar = false; // Reset flag when Snackbar is closed
        });
      }
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
              valueListenable: cameraController,
              builder: (context, state, child) {
                final torchState = (state as MobileScannerState).torchState;
                switch (torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.auto:
                    return const Icon(Icons.flash_auto, color: Colors.yellow);
                  case TorchState.unavailable:
                    return const Icon(Icons.not_interested,
                        color: Colors.yellow);
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
          controller: cameraController,
          onDetect: (barcodes) {
            // Fixed barcode detection
            if (barcodes.barcodes.isNotEmpty) {
              final barcode = barcodes.barcodes.first;
              if (barcode.rawValue != null) {
                final String code = barcode.rawValue!;
                print("================= barcode: ${code} =================");
                findShop(code, context);
              }
            }
          },
        ),
        QRScannerOverlay(Key("QRScannerOverlay"),
            overlayColour: Colors.black.withOpacity(0.5))
      ]),
      backgroundColor: Colors.black,
    );
  }
}