import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/wishlist_controller.dart';
import 'package:odda/app/routes/app_routes.dart';

import '../../common/utils.dart';
import '../model/normal_response.dart';
import '../model/product_detail_data.dart';
import '../repository/product_repository.dart';

class ProductDetailController extends GetxController {
  final isFavourite = false.obs;
  final isAddedToCart = false.obs;
  final showCaseImageUrl = 'https://loremflickr.com/640/360'.obs;
  var description =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

  late TextEditingController reviewtextController;
  late TextEditingController productCountController;
  final productCount = 1.obs;

  late ProductDetailData productDetailData;
  final isLoading = true.obs;
  final isAdding = false.obs;
  final isAddingtoCart = false.obs;
  late ProductRepository productRepository;
  var title, productId = '';
  var vendorRating = '5';
  
  // FIXED: Using CarouselSliderController instead of CarouselController
  late CarouselSliderController buttonCarouselController;

  ProductDetailController() {
    productRepository = ProductRepository();
    reviewtextController = TextEditingController();
    productCountController = TextEditingController(text: productCount.value.toString());
    buttonCarouselController = CarouselSliderController(); // FIXED: Correct constructor
  }

  @override
  void onInit() {
    super.onInit();
    title = Get.arguments['title'] as String;
    productId = Get.arguments['productId'] as String;
    print('Product Id = $productId');
    getProductDetails(productId);
  }

  void getProductDetails(String productId) async {
    isLoading.value = true;
    try {
      ProductDetailData productDetailData2 =
          await productRepository.getProductDetails(productId);
      productDetailData = productDetailData2;
      showCaseImageUrl.value = productDetailData2.data.productImages[0].name;
      isFavourite.value = productDetailData.data.isWishlisted;
      isAddedToCart.value = productDetailData.data.inCart;
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ' + e.response!.data);
        }
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

  // FIXED: Added proper parameters to match CarouselSlider's onPageChanged callback
  void onPageChanged(int index, CarouselPageChangedReason reason) {
    // You can add any logic here when the page changes
    // For example, update a current page indicator
    if (kDebugMode) {
      print('Carousel page changed to index: $index, reason: $reason');
    }
  }

  void addToWishList(BuildContext context, String productID) async {
    try {
      isAdding.value = true;
      NormalResponse normalResponse = await productRepository.addToWishlist(productId);
      isFavourite.value = !isFavourite.value;
      if (Get.previousRoute == Routes.Wishlist) {
        Get.find<WishlistController>().getWishListItems();
      }
      isAdding.value = false;
    } catch (e) {
      isAdding.value = false;
      if (e is DioException) {
        showSnackbar(context, e.response!.data.toString());
      } else {
        showSnackbar(context, e.toString());
      }
    }
  }

  void addToCart(BuildContext context, String productID) async {
    try {
      isAddingtoCart.value = true;
      NormalResponse normalResponse = await productRepository.addToCart(productId, productCount.value.toString());
      isAddedToCart.value = !isAddedToCart.value;
      isAddingtoCart.value = false;
    } catch (e) {
      isAddingtoCart.value = false;
      if (e is DioException) {
        showSnackbar(context, e.response!.data['msg']);
      } else {
        showSnackbar(context, e.toString());
      }
    }
  }

  void addReview(String productID, String rating, String review, bool isVendor,
      BuildContext context) async {
    try {
      NormalResponse normalResponse = await productRepository.addReview(
          productID, rating, review, isVendor);
      showSnackbar(context, normalResponse.msg);
      Get.back();
      getProductDetails(productId);
    } catch (e) {
      if (e is DioException) {
        showSnackbar(context, e.response!.data['msg']);
      } else {
        showSnackbar(context, e.toString());
      }
    }
  }
}