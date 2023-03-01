import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shops.dart';

class UserShopsScreen extends StatelessWidget {
  static const routeName = "/userShopsScreen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Shops>(context, listen: false).fetchAndSetShops();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
