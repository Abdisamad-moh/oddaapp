import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:odda/app/model/wishlist_data.dart';

import '../repository/cart_repository.dart';

class WishlistController extends GetxController{


  final isLoading = false.obs;
  late CartRepository cartRepository;
  final wishList = <WishlistDatum>[].obs;

  WishlistController(){
    cartRepository = CartRepository();
  }

  @override
  void onInit(){
    super.onInit();
    getWishListItems();
  }


  void getWishListItems() async {
    try {
      isLoading.value = true;
      WishlistData wishlistData = await cartRepository.getWishListItems();
      wishList.assignAll(wishlistData.data);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        print('Upper ===  ' + e.response!.data);
      } else {
        Get.snackbar('', e.toString());
        print('Lower ===  $e');
      }
    }
  }

}