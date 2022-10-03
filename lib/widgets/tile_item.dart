import '../providers/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TileItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var _isSelected = false;
    final product = Provider.of<Product>(context,listen: false);
    return ListTile(
      onTap: (){},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: CircleAvatar(
          backgroundImage: Image.network(
              product.imageUrl,
              fit: BoxFit.cover)
              .image),
      title: Text(
        product.title,
        style: TextStyle(fontFamily: 'Mina Regular', fontSize: 22),
      ),
      subtitle: Text(product.unit),
      trailing: Container(
        width: 115,
        child: Row(
          children: [
            Expanded(
              child: Text(product.price.toString(),
                  style: TextStyle(
                      fontFamily: 'Mina Regular', fontSize: 22)),
            ),

            Expanded(
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xff57DDDD),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
