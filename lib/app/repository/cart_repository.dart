import 'package:get/get.dart';
import 'package:odda/app/model/cart_data.dart';

import '../model/admin_account_data.dart';
import '../model/normal_response.dart';
import '../model/wishlist_data.dart';
import '../provider/api_provider.dart';

class CartRepository{

  late ApiProvider _apiProvider;

  CartRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<CartData> getCartItems() async {
    return _apiProvider.getCartItems();
  }

  Future<NormalResponse> deleteCartItem(String cartId) async {
    return _apiProvider.deleteCartItem(cartId);
  }

  Future<WishlistData> getWishListItems() async {
    return _apiProvider.getWishListItems();
  }


  Future<NormalResponse> placeOrder() async {
    return _apiProvider.placeOrder();
  }

  Future<AdminAccountData> getAdminAccount() async {
    return _apiProvider.getAdminAccount();
  }



}