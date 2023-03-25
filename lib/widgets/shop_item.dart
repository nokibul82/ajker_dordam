import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/shops.dart';
import '../screens/edit_shop_screen.dart';

class ShopItem extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final DateTime created_at;

  const ShopItem(
      this.id,
      this.name,
      this.address,
      this.imageUrl,
      this.created_at);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return GestureDetector(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(name,style: TextStyle(
            fontFamily: 'Mina Regular', color: Colors.black, fontSize: 16),),
        subtitle: Text(DateFormat.yMd()
            .add_jm()
            .format(created_at)
            .toString(), style: TextStyle(
            fontFamily: 'Mina Regular', color: Colors.black, fontSize: 10),),
        trailing: Container(
          width: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(address,softWrap: true,style: TextStyle(
                    fontFamily: 'Mina Regular', color: Colors.black, fontSize: 10),),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditShopScreen.routeName, arguments: id);
                  },
                  icon: Icon(Icons.edit),
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () async {
                    try {
                      await showDialog(context: context, builder: (ctx) => AlertDialog(
                        title: Text("আপনি কি দোকানটি একেবারে মুছে দিতে চান ?",
                          style: TextStyle(
                              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 18),
                        ),
                        content: Text(""),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("না" ,style: TextStyle(
                                  fontFamily: 'Mina Regular', color: Colors.greenAccent, fontSize: 18))),
                          TextButton(
                              onPressed: () async {
                              await Provider.of<Shops>(context, listen: false)
                                    .deleteShop(id);
                              Navigator.of(ctx).pop();
                              },
                              child: Text("হ্যাঁ",style: TextStyle(
                                  fontFamily: 'Mina Regular', color: Colors.redAccent, fontSize: 18)))
                        ],
                      ));
                    } catch (error) {
                      scaffold
                          .showSnackBar(SnackBar(content: Text("Deleting Failed")));
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.redAccent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
