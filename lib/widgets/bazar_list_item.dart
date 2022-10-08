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

  BazarListItem(this.id, this.productId, this.price, this.quantity, this.unit, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
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
            )
        );
      },
      onDismissed: (direction) {
        Provider.of<BazarList>(context, listen: false).removeItem(productId);
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
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text("\$${price}"))),
            ),
            title: Text(title),
            subtitle: Text('Total \$${(price * quantity)}'),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
