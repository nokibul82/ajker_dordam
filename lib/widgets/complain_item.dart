import 'package:flutter/material.dart';



class ComplainItem extends StatelessWidget {
  final String shopName;
  final String dateTime;
  final String shopImageUrl;
  final String shopAddress;
  const ComplainItem(this.shopName, this.shopImageUrl,this.shopAddress, this.dateTime);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: CircleAvatar(backgroundImage: NetworkImage(shopImageUrl)),
        title: Text(shopName),
        subtitle: Text(dateTime),
        trailing: Text(shopAddress),
      ),
    );
  }
}
