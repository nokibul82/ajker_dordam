import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class ComplainItem extends StatelessWidget {
  final String shopName;
  final DateTime dateTime;
  final String shopImageUrl;
  final String shopAddress;
  const ComplainItem(this.shopName, this.shopImageUrl,this.shopAddress, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(backgroundImage: NetworkImage(shopImageUrl)),
        title: Text(shopName,style: TextStyle(
            fontFamily: 'Mina Regular', color: Colors.black, fontSize: 16)),
        subtitle: Text(DateFormat.yMd()
            .add_jm()
            .format(dateTime)
            .toString(),style: TextStyle(
            fontFamily: 'Mina Regular', color: Colors.black, fontSize: 10)),
        trailing: Text(shopAddress,style: TextStyle(
            fontFamily: 'Mina Regular', color: Colors.black, fontSize: 10)),
      ),
    );
  }
}
