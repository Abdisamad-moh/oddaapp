import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/model/cart_data.dart';
import 'package:odda/app/model/normal_response.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:odda/common/color_constants.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../model/admin_account_data.dart';
import '../repository/cart_repository.dart';

class CartController extends GetxController {
  final isLoading = false.obs;
  final isFetching = false.obs;
  late CartRepository cartRepository;
  final cartList = <CartDatum>[].obs;
  late CarouselController buttonCarouselController;

  CartController() {
    cartRepository = CartRepository();
    buttonCarouselController = CarouselController();
  }

  @override
  void onInit() {
    super.onInit();
    getCartItems();
  }

  void getCartItems() async {
    try {
      isLoading.value = true;
      CartData cartData = await cartRepository.getCartItems();
      cartList.assignAll(cartData.data);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ${ e.response!.data}');
        }
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

  void deleteCartItem(String cartId, int index) async {
    try {
      isLoading.value = true;
      NormalResponse normalResponse =
      await cartRepository.deleteCartItem(cartId);
      cartList.removeAt(index);
      cartList.refresh();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ${e.response!.data}');
        }
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

  void getAccountDetails(BuildContext context) async {
    try {
      isFetching.value = true;
      AdminAccountData cartData = await cartRepository.getAdminAccount();
      showAccountDialog(context, cartData.data);
      isFetching.value = false;
    } catch (e) {
      isFetching.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print('Upper ===  ${ e.response!.data}');
        }
        // FIXED: Get OverlayState from context
        final overlayState = Overlay.of(context);
        if (overlayState != null) {
          showTopSnackBar(
            overlayState,
            CustomSnackBar.info(
              backgroundColor: colorConstants.primaryColor2,
              icon: Container(),
              message: e.toString(),
              textStyle: TextStyle(
                  color: colorConstants.white,
                  fontSize: getNormalTextFontSIze(),
                  fontWeight: FontWeight.w600),
            ),
          );
        }
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

  void placeOrder(BuildContext context) async {
    try {
      isFetching.value = true;
      NormalResponse normalResponse = await cartRepository.placeOrder();
      showSnackbar(context, normalResponse.msg);
      Get.back();
      Get.back();
      Get.toNamed(Routes.MyOrders);
      isFetching.value = false;
    } catch (e) {
      isFetching.value = false;
      if (e is DioException) {
        if (kDebugMode) {
          print("createOrderDioError:${e.response?.data.toString()}");
        }
        if (e.response?.statusCode == 422) {
          var message = e.response!.data['msg'];
          if (message.contains("Exception:")) {
            message = message.replaceAll("Exception:", "");
          }
          if (message == 'No address found!') {
            Get.toNamed(Routes.AddAddress);
            showSnackbar(context, 'Please add address to Continue');
          } else {
            showSnackbar(context, message);
          }
        }
      } else {
        Get.snackbar('', e.toString());
        if (kDebugMode) {
          print('Lower ===  $e');
        }
      }
    }
  }

  void showAccountDialog(BuildContext context, AdminAccountDatum datum) {
    showDialog(
        context: context,
        builder: (ctxt) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Container(),
          content: SizedBox(
              height: 30.h,
              width: 90.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.close,
                          color: colorConstants.lightGrey,
                          size: getLargeTextFontSIze() * 1.2,
                        ),
                      )),
                  addAlignedText(
                      "Bank Account Details",
                      getHeadingTextFontSIze(),
                      colorConstants.black,
                      FontWeight.bold),
                  const SizedBox(
                    height: 20,
                  ),
                  addAlignedText(
                      "Account No : ${datum.accountNo.toString()}",
                      getNormalTextFontSIze(),
                      colorConstants.black,
                      FontWeight.w500),
                  const Divider(),
                  addAlignedText(
                      "Bank Name : ${datum.bankName.toString()}",
                      getNormalTextFontSIze(),
                      colorConstants.black,
                      FontWeight.w500),
                  const Divider(),
                  addAlignedText(
                      "Swift Code : ${datum.swiftCode.toString()}",
                      getNormalTextFontSIze(),
                      colorConstants.black,
                      FontWeight.w500),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      placeOrder(context);
                    },
                    child: getSolidButton(80.w, "Submit"),
                  ),
                ],
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ));
  }
}