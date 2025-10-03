import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import './/main.dart';
import './scanner_screen.dart';
import './complain_confirm_screen.dart';
import '../providers/complains.dart';

class ImagePickerScreen extends StatefulWidget {
  static const routeName = "/imagePickerScreen";
  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? image; // Remove 'late', just make it nullable
  String imageName = ""; // Change from File to String for the name

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;

      final tempPath = File(pickedImage.path);
      setState(() {
        image = tempPath;
        imageName = pickedImage.name; // Store the name as String
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _submitComplaint() {
    if (image != null) {
      final complains = Provider.of<Complains>(context, listen: false);
      complains.setImage(image!);
      complains.setName(File(imageName)); // Convert to File if needed, or adjust your provider
      Navigator.of(context).pushReplacementNamed(ComplainConfirmScreen.routeName);
    } else {
      // Show error if no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image first'),
          duration: Duration(seconds: 2),
        ),
      );
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
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.86,
                  height: MediaQuery.of(context).size.width * 0.86,
                  alignment: Alignment.center,
                  child: image == null
                      ? Center(
                    child: Text(
                      "রশিদ এর ছবি দিন",
                      style: TextStyle(
                          fontFamily: 'Mina Regular',
                          color: Colors.black,
                          fontSize: 18),
                    ),
                  )
                      : Image.file(
                    image!, // Use ! since we checked for null
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
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
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                              side: BorderSide(width: 2, color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "গ্যালারি থেকে",
                                  style: TextStyle(
                                      fontFamily: 'Mina Regular',
                                      color: Colors.black,
                                      fontSize: 24),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
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
                      onPressed: image != null ? _submitComplaint : null, // Disable if no image
                      style: ElevatedButton.styleFrom(
                          backgroundColor: image != null
                              ? MyApp.backColor
                              : Colors.grey, // Visual feedback
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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