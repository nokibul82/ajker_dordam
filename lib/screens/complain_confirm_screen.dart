import 'package:ajker_dordam/main.dart';
import 'package:ajker_dordam/screens/complain_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import './image_picker_screen.dart';
import '../providers/complains.dart';

class ComplainConfirmScreen extends StatefulWidget {
  static const routeName = "/complainConfirmScreen";

  @override
  State<ComplainConfirmScreen> createState() => _ComplainConfirmScreenState();
}

class _ComplainConfirmScreenState extends State<ComplainConfirmScreen> {
  late String shopImage;
  late File receiptImage;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final complains = Provider.of<Complains>(context,listen: false);
    Complain complain = complains.temporaryComplain;
    print(complain);
    shopImage = complain.shopImageUrl;
    receiptImage = complains.getImage;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "অভিযোগ মন্তব্য",
            style: TextStyle(
                fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _textController.text.isEmpty
                      ? showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            title: Icon(Icons.warning_amber,size: 32),
                            content: Text(
                              "কোনো মন্তব্য নেই। অনুগ্রহ করে মন্তব্য লিখুন।",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Mina Regular',
                                  color: Colors.black,
                                  fontSize: 24),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },style: ElevatedButton.styleFrom(
                                  backgroundColor: MyApp.backColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )
                              ),
                                  child: Text(
                                    "ঠিক আছে",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Mina Regular',
                                        color: Colors.white,
                                        fontSize: 24),
                                  ))
                            ],
                          ),
                      )
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("আপনি নিশ্চিত ?",
                                    style: TextStyle(
                                        fontFamily: 'Mina Regular',
                                        color: Colors.black,
                                        fontSize: 24)),
                                actions: [
                                  TextButton(
                                      onPressed: () async{
                                        complain.description = _textController.text;
                                        complains.setTemporaryComplain(complain);
                                        await complains.uploadImage();
                                        await complains.addComplain();
                                        Navigator.pushReplacementNamed(context, ComplainSuccessScreen.routeName);
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
                },
                child: Text("জমা দিন",
                    style: TextStyle(
                        fontFamily: 'Mina Regular',
                        color: Colors.black,
                        fontSize: 24)))
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(ImagePickerScreen.routeName);
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
        body: ListView(
          padding: EdgeInsets.all(5.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                      height: MediaQuery.of(context).size.width * 0.46,
                      width: MediaQuery.of(context).size.width * 0.46,
                      alignment: Alignment.center,
                      child: receiptImage == null
                          ? Center(
                              child: Text(
                                "রশিদ এর ছবি",
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
                              image: FileImage(receiptImage),
                              fit: BoxFit.fill,
                            )),
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                      height: MediaQuery.of(context).size.width * 0.46,
                      width: MediaQuery.of(context).size.width * 0.46,
                      alignment: Alignment.center,
                      child: receiptImage == null
                          ? Center(
                              child: Text(
                                "দোকান এর ছবি",
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
                              image: NetworkImage(shopImage),
                              fit: BoxFit.cover,
                            )),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Container(
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                  alignment: Alignment.center,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          complain.shopName,
                          style: TextStyle(
                              fontFamily: 'Mina Regular',
                              color: Colors.black,
                              fontSize: 18),
                        ),
                        Text(
                          complain.shopAddress,
                          style: TextStyle(
                              fontFamily: 'Mina Regular',
                              color: Colors.black,
                              fontSize: 18),
                        )
                      ],
                    ),
                  )),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.08),
            TextFormField(
              controller: _textController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  labelText: "বিস্তারিত মন্তব্য",
                  icon: Icon(Icons.wrap_text_outlined),
                  border: OutlineInputBorder()),
            ),
          ],
        ));
  }
}
