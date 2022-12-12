import 'package:ajker_dordam/screens/complain_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import './/main.dart';
import './scanner_screen.dart';

import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  static const routeName = "/imagePickerScreen";

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File image;

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final temp = File(image.path);
      setState(() {
        this.image = temp;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "রশিদ সংগ্রহ",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 24),
        ),
        actions: [],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(ScannerScreen.routeName);
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
      ),
      body: Container(
        margin: EdgeInsets.only(left: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 6,
              child: Container(
                  width: 280,
                  height: 300,
                  color: Colors.grey.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: image == null
                      ? Text(
                          "ক্রয় রশিদ এর ছবি দিন",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Mina Regular',
                              color: Colors.black,
                              fontSize: 32),
                        )
                      : Image.file(
                          image,
                          fit: BoxFit.cover,
                        )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.6,
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
                              primary: MyApp.backColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                          child:
                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            Text(
                              "ছবি তুলুন",
                              style: TextStyle(
                                  fontFamily: 'Mina Regular',
                                  color: Colors.black,
                                  fontSize: 24),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.black,
                              size: 32,
                            ),
                          ]),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.6,
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
                              side: BorderSide(width: 2, color: Colors.black),
                              primary: MyApp.backColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                          child:
                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            Text(
                              "গ্যালারি থেকে",
                              style: TextStyle(
                                  fontFamily: 'Mina Regular',
                                  color: Colors.black,
                                  fontSize: 24),
                            ),
                            SizedBox(width: 5,),
                            Icon(
                              Icons.image_rounded,
                              color: Colors.black,
                              size: 32,
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.height * 0.01),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(ComplainConfirmScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: MyApp.backColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                      child:
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        // Text(
                        //   "ছবি তুলুন",
                        //   style: TextStyle(
                        //       fontFamily: 'Mina Regular',
                        //       color: Colors.black,
                        //       fontSize: 30),
                        // ),
                        // SizedBox(width: 5),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black,
                          size: MediaQuery.of(context).size.width * 0.15,
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
