import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/shops.dart';
import '../services/comparison_service.dart';
import '../widgets/product_card.dart';

class ComparisonScreen extends StatefulWidget {
  final Product selectedProduct;

  const ComparisonScreen({
    Key? key,
    required this.selectedProduct,
  }) : super(key: key);

  @override
  _ComparisonScreenState createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  late List<Product> similarProducts;
  List<Product> allProducts = [];
  List<Shop> allShops = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Load products and shops
      await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
      await Provider.of<Shops>(context, listen: false).fetchAndSetShops();

      // Get the loaded data
      final products = Provider.of<Products>(context, listen: false).items;
      final shops = Provider.of<Shops>(context, listen: false).items;

      setState(() {
        allProducts = products;
        allShops = shops;
        similarProducts = ComparisonService.findSimilarProducts(
          widget.selectedProduct,
          allProducts,
          allShops,
        );
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print('Error loading comparison data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'তুলনা',
            style: TextStyle(
                fontFamily: 'Mina Regular',
                fontSize: 22
            )
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? _buildLoadingScreen()
          : _hasError
          ? _buildErrorScreen()
          : similarProducts.isEmpty
          ? _buildNoSimilarProducts()
          : _buildComparisonList(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'পণ্য তুলনা করা হচ্ছে...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Mina Regular',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'ডেটা লোড করতে সমস্যা হয়েছে',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Mina Regular',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'দয়া করে আবার চেষ্টা করুন',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Mina Regular',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
            ),
            child: Text(
              'আবার চেষ্টা করুন',
              style: TextStyle(
                fontFamily: 'Mina Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSimilarProducts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'এই পণ্যের আনুরুপ পাওয়া যায়নি',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Mina Regular',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'অন্য কোনো পণ্য চেষ্টা করুন',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Mina Regular',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
            ),
            child: Text(
              'ফিরে যান',
              style: TextStyle(
                fontFamily: 'Mina Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonList() {
    return Column(
      children: [
        // Selected Product Header
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'আপনার নির্বাচিত পণ্য:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontFamily: 'Mina Regular',
            ),
          ),
        ),
        _buildProductWithShop(widget.selectedProduct),

        // Similar Products Header
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'অন্যান্য দোকান থেকে একই পণ্য:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontFamily: 'Mina Regular',
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              itemCount: similarProducts.length,
              itemBuilder: (context, index) {
                return _buildProductWithShop(similarProducts[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductWithShop(Product product) {
    final shop = ComparisonService.getShopForProduct(product.shopId, allShops);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Card
            ProductCard(product: product),

            const SizedBox(height: 12),

            // Shop Information
            if (shop != null) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: shop.imageUrl.isNotEmpty
                          ? ClipOval(
                        child: Image.network(
                          shop.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.store,
                              size: 20,
                              color: Colors.grey[600],
                            );
                          },
                        ),
                      )
                          : Icon(
                        Icons.store,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Mina Regular',
                            ),
                          ),
                          Text(
                            shop.address,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Mina Regular',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.store_mall_directory,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'দোকানের তথ্য পাওয়া যায়নি',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontFamily: 'Mina Regular',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}