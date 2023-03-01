import 'package:ajker_dordam/providers/bazar_list.dart';
import 'package:ajker_dordam/widgets/bazar_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BazarListScreen extends StatelessWidget {
  static const routeName = "/bazarlist";
  @override
  Widget build(BuildContext context) {
    final bazarList = Provider.of<BazarList>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("বাঁজারের তালিকা",
              style: TextStyle(
                  fontFamily: 'Mina Regular',
                  color: Colors.black,
                  fontSize: 22)),
          iconTheme: IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${bazarList.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: bazarList.items.length,
            itemBuilder: (ctx, i) => BazarListItem(
                bazarList.items.values.toList()[i].id,
                bazarList.items.keys.toList()[i],
                bazarList.items.values.toList()[i].price,
                bazarList.items.values.toList()[i].quantity,
                bazarList.items.values.toList()[i].unit,
                bazarList.items.values.toList()[i].title),
          ))
        ],
      ),
    );
  }
}
