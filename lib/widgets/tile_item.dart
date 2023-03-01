import 'package:ajker_dordam/main.dart';

import '../providers/bazar_list.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TileItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _isSelected = false;
    final product = Provider.of<Product>(context, listen: false);
    final bazarList = Provider.of<BazarList>(context, listen: false);
    return ListTile(
      tileColor: MyApp.backColor.withOpacity(0.5),
      onTap: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: CircleAvatar(
          backgroundImage: NetworkImage(
        product.imageUrl,
      )),
      title: Text(
        product.title,
        style: TextStyle(fontFamily: 'Mina Regular', fontSize: 16),
      ),
      subtitle: Text(product.unit, style: TextStyle(fontFamily: 'Mina Regular', fontSize: 14)),
      trailing: Container(
        width: 115,
        child: Row(
          children: [
            Expanded(
              child: Text(product.price.toString(),
                  style: TextStyle(fontFamily: 'Mina Regular', fontSize: 16)),
            ),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    bazarList.addItem(product.id, product.title, product.price);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Added item to cart successfully"),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            bazarList.removeSingleItemCard(product.id);
                          }),
                    ));
                  },
                  icon: Icon(
                    Icons.add_circle_outline_outlined,
                    color: Colors.black,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
