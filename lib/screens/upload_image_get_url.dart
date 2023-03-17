import 'package:ajker_dordam/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../widgets/app_drawer.dart';

class UploadImageGetUrl extends StatefulWidget {
  static const routeName = "/uploadImage";
  @override
  State<UploadImageGetUrl> createState() => _UploadImageGetUrlState();
}

class _UploadImageGetUrlState extends State<UploadImageGetUrl> {
  File image;
  File name;
  String imageUrl;
  UploadTask _uploadTask;
  bool isLoading = false;

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final tempPath = File(image.path);
      final tempName = File(image.name);
      setState(() {
        this.image = tempPath;
        this.name = tempName;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> uploadImage() async {
    final path = 'images/${name}';
    final file = image;

    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      _uploadTask = ref.putFile(file);

      final snapshot = await _uploadTask.whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });

      imageUrl = await snapshot.ref.getDownloadURL();
    } catch (error) {
      print(error + "\nError from upload Image method ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "ছবি আপলোড",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (image == null || name == null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "ছবি বাছুন",
                    style: TextStyle(
                        fontFamily: 'Mina Regular',
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  duration: Duration(seconds: 3),
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                ));
                return;
              }
              setState(() {
                isLoading = true;
              });
              await uploadImage();
              showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "ছবি আপলোড হয়েছে ✅",
                                style: TextStyle(
                                    fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
                              ),
                              SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: () async{
                                    await Clipboard.setData(ClipboardData(text: imageUrl));
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: MyApp.backColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20.0)),
                                    shadowColor: Colors.grey
                                  ),
                                  child: Text(
                                    "লিঙ্ক ক্লিপবোর্ডে কপি করুন",
                                      style: TextStyle(
                                          fontFamily: 'Mina Regular', color: Colors.black, fontSize: 16)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )));
            },
            icon: isLoading
                ? CircularProgressIndicator()
                : Icon(
                    Icons.file_upload_outlined,
                  ),
          )
        ],
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                              "ছবি",
                              style: TextStyle(
                                  fontFamily: 'Mina Regular',
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                          )
                        : FadeInImage(
                            fadeInCurve: Curves.bounceIn,
                            placeholder:
                                AssetImage('assets/images/placeholder.png'),
                            image: FileImage(image),
                            fit: BoxFit.cover,
                          )),
              ),
              SizedBox(height: 5),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.86,
                  child: OutlinedButton(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 2, color: Colors.black),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "গ্যালারি থেকে",
                            style: TextStyle(
                                fontFamily: 'Mina Regular',
                                color: Colors.black,
                                fontSize: 24),
                          ),
                          SizedBox(
                            width: 10,
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
              SizedBox(height: 5),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.86,
                  child: ElevatedButton(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ছবি তুলুন",
                            style: TextStyle(
                                fontFamily: 'Mina Regular',
                                color: Colors.white,
                                fontSize: 24),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 32,
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
