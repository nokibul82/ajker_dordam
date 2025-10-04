import '../providers/products.dart';
import '../providers/shops.dart';

class ComparisonService {
  // Find similar products from different shops based on product name
  static List<Product> findSimilarProducts(
      Product selectedProduct,
      List<Product> allProducts,
      List<Shop> allShops,
      ) {
    final selectedProductName = selectedProduct.title.toLowerCase().trim();

    return allProducts.where((product) {
      // Skip the same product
      if (product.id == selectedProduct.id) {
        print("Same product");
        return false;
      }

      // Skip products from the same shop
      if (product.shopId == selectedProduct.shopId) {
        print("Same shop");
        return false;
      }

      final productName = product.title.toLowerCase().trim();

      // Simple word-by-word matching
      final selectedWords = selectedProductName.split(' ');
      final productWords = productName.split(' ');
      print(selectedWords);
      print(productWords);

      int matchingWords = 0;
      for (var word in selectedWords) {
        if (word.length > 1 && productWords.contains(word)) {
          matchingWords++;
        }
      }

      // Consider products similar if at least 2 words match
      return matchingWords >= 1;
    }).toList();
  }

  // Get shop details for a product
  static Shop? getShopForProduct(String shopId, List<Shop> shops) {
    try {
      return shops.firstWhere((shop) => shop.id == shopId);
    } catch (e) {
      return null;
    }
  }

  // Calculate similarity score between two product names
  static double calculateSimilarity(String name1, String name2) {
    final words1 = name1.toLowerCase().split(' ');
    final words2 = name2.toLowerCase().split(' ');

    int matches = 0;
    for (var word in words1) {
      if (word.length > 2 && words2.contains(word)) {
        matches++;
      }
    }

    return matches / words1.length;
  }
}