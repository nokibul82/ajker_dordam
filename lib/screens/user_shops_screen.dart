import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shops.dart';
import '../widgets/shop_item.dart';
import './edit_shop_screen.dart';
import '../widgets/app_drawer.dart';

class UserShopsScreen extends StatelessWidget {
  static const routeName = "/userShopScreen";

  Future<void> _refreshShops(BuildContext context) async {
    await Provider.of<Shops>(context, listen: false).fetchAndSetShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "দোকান যোগ / হালনাগাদ",
          style: TextStyle(
              fontFamily: 'Mina Regular', color: Colors.black, fontSize: 22),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditShopScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refreshShops(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshShops(context),
                      child: Consumer<Shops>(
                          builder: (context, shopData, _) => Padding(
                                padding: EdgeInsets.all(8),
                                child: ListView.builder(
                                    itemCount: shopData.items.length,
                                    itemBuilder: (ctx, i) => Column(
                                          children: [
                                            ShopItem(
                                                shopData.items[i].id,
                                                shopData.items[i].name,
                                                shopData.items[i].address,
                                                shopData.items[i].imageUrl,
                                                shopData.items[i].created_at
                                            ),
                                            Divider()
                                          ],
                                        )),
                              )))),
    );
  }
}
