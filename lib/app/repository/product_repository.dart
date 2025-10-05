import 'package:get/get.dart';

import '../model/detail_review_data.dart';
import '../model/normal_response.dart';
import '../model/product_detail_data.dart';
import '../model/product_list_data.dart';
import '../provider/api_provider.dart';

class ProductRepository {
  late ApiProvider _apiProvider;

  ProductRepository() {
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<ProductListData> getSellerProducts(String sellerId) async {
    return _apiProvider.getSellerProducts(sellerId);
  }

  Future<ProductListData> getProductList(
      String categoryId, String itemType, int currentPage) async {
    return _apiProvider.getProductList(categoryId, itemType, currentPage);
  }

  Future<ProductListData> getBannerList(
      String bannerId,bool value) async {
    return _apiProvider.getBannerList(bannerId,value);
  }

  Future<ProductListData> getFilteredItems(String categoryId, String itemType,
      String sortBy, String priceRange, String location) async {
    return _apiProvider.getFilteredItems(
        categoryId, itemType, sortBy, priceRange, location);
  }

  Future<ProductDetailData> getProductDetails(String productId) async {
    return _apiProvider.getProductDetails(productId);
  }

  Future<NormalResponse> addToWishlist(String productId) async {
    return _apiProvider.addToWishlist(productId);
  }

  Future<NormalResponse> addToCart(String productId,String quantity) async {
    return _apiProvider.addToCart(productId,quantity);
  }

  Future<NormalResponse> addReview(String productID,String rating,String review,bool isVendor) async {
    return _apiProvider.addReview(productID, rating, review, isVendor);
  }

  Future<DetailReviewData> getDetailReview(String type,String itemId) async {
    return _apiProvider.getDetailReview(type, itemId);
  }

}
