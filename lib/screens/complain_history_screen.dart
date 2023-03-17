import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/complains.dart';
import '../widgets/complain_item.dart';
import 'complain_screen.dart';

class ComplainHistoryScreen extends StatelessWidget {
  static const routeName = "/complainHistoryScreen";

  Future<void> _refreshComplains(BuildContext context) async {
    await Provider.of<Complains>(context, listen: false).fetchAndSetComplains();
  }

  @override
  Widget build(BuildContext context) {
    List<Complain> complains = Provider.of<Complains>(context).items;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              "অভিযোগ তালিকা",
              style: TextStyle(
                  fontFamily: 'Mina Regular',
                  color: Colors.black,
                  fontSize: 22),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(ComplainScreen.routeName);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            )),
        body: FutureBuilder(
            future: _refreshComplains(context),
            builder: (context, snapshot) =>
              // (snapshot.connectionState == ConnectionState.waiting)
              //   ? Center(
              //     child: CircularProgressIndicator(),
              //   )
              //  :
              RefreshIndicator(
                  onRefresh: () {
                    return _refreshComplains(context);
                  },
                  child: Consumer<Complains>(
                      builder: (context, complainData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: complainData.items.length,
                              itemBuilder: (ctx, i) => Column(
                                children: [
                                      ComplainItem(
                                          complainData.items[i].shopName,
                                          complainData.items[i].shopImageUrl,
                                          complainData.items[i].shopAddress,
                                          complainData.items[i].dateTime.toIso8601String()),
                                  Divider()
                                ],
                              ),
                            ),
                          )),
                )
            ));
  }
}
