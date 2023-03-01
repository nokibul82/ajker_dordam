import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String unit;
  final double price;
  final String imageUrl;

  const ProductItem(this.id, this.title, this.unit, this.price, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return GestureDetector(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        title: Text(title,style: TextStyle(
            fontFamily: 'Mina Regular', color: Colors.black, fontSize: 16),),
        subtitle: Text(unit, style: TextStyle(
            fontFamily: 'Mina Regular', color: Colors.black, fontSize: 16),),
        trailing: Container(
          width: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(price.toStringAsFixed(2),style: TextStyle(
                  fontFamily: 'Mina Regular', color: Colors.black, fontSize: 16),),
              IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                icon: Icon(Icons.edit),
                color: Colors.black,
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    scaffold
                        .showSnackBar(SnackBar(content: Text("Deleting Failed")));
                  }
                },
                icon: Icon(Icons.delete),
                color: Colors.redAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
