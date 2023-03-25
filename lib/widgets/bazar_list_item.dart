import 'package:ajker_dordam/providers/bazar_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bazar_list.dart';

class BazarListItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String unit;
  final String title;

  BazarListItem(this.id, this.productId, this.price, this.quantity, this.unit,
      this.title);

  @override
  Widget build(BuildContext context) {
    final bazarList = Provider.of<BazarList>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure ?"),
                  content: Text("Want to remove the cart item ?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text("No")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text("Yes"))
                  ],
                ));
      },
      onDismissed: (direction) {
        bazarList.removeItem(productId);
      },
      background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4)),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Padding(
                  padding: EdgeInsets.all(2),
                  child: FittedBox(
                      child: Text(
                    "৳ ${price}",
                    style: TextStyle(color: Colors.white),
                  ))),
            ),
            title: Text(title),
            subtitle: Text('Total ৳ ${(price * quantity)}'),
            trailing: SizedBox(
              width: 150,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        bazarList.addItem(productId, title, price);
                      },
                      icon: Icon(Icons.add_circle_outline)),
                  Text('$quantity X'),
                  IconButton(
                      onPressed: () {
                        bazarList.removeSingleItemCard(productId);
                      },
                      icon: Icon(Icons.remove_circle_outline))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
