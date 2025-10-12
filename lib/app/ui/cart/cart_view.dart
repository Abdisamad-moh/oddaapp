
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/common/bottom_navigation.dart';

import 'package:odda/common/color_constants.dart';
import 'package:odda/common/header.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/preferences.dart';
import '../../controller/cart_controller.dart';

class CartView extends GetView<CartController>{
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            Obx(() => controller.cartList.isEmpty
                ? const SizedBox.shrink()
                : controller.isFetching.value
                    ? getLoader()
                    : GestureDetector(
                        onTap: () {
                          if (!controller.isFetching.value) {
                            showConfirmationPopup(context);
                          }
                        },
                        child: getSolidButton(90.w, 'Place order'),
                      )),
            const SizedBox(height: 10),
            const AppBottomNavigation(),
          ],
        ),
      ),
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppHeader(title: 'Cart'),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(height: 2.h,),
            Expanded(child: Obx(() => controller.isLoading.value ? buildLoader() :
            controller.cartList.isEmpty ? Center(
              child: addText('Nothing in your cart', getNormalTextFontSIze(), colorConstants.black, FontWeight.w600))
              : ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.cartList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {

                    },
                    child:Container(
                        margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                        decoration: BoxDecoration(
                            color: colorConstants.white,
                            borderRadius: getCurvedBorderRadius(),
                            boxShadow: [getDeepBoxShadow()]
                        ), child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 10.h,height: 10.h,
                            child: ClipRRect(
                              borderRadius: getCurvedBorderRadius(),
                              child: Image.network(controller.cartList[index].product.productImages[0].name.toString(),fit: BoxFit.cover,),
                            ),),
                          const SizedBox(width: 20,),
                          SizedBox(width: 45.w,child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addText(controller.cartList[index].product.name.toString(), getNormalTextFontSIze(), colorConstants.black, FontWeight.bold),
                              SizedBox(height: 0.5.h,),
                              getValue(SharedPref.currency).length == 1 ?
                              Row(
                                children: [
                                  addText((double.parse(controller.cartList[index].product.price.toString())*double.parse(controller.cartList[index].quantity.toString())).toString(), getSubheadingTextFontSIze(), colorConstants.primaryColor2, FontWeight.bold),
                                  addText(getValue(SharedPref.currency), getSubheadingTextFontSIze(), colorConstants.primaryColor2, FontWeight.bold),
                                ],
                              )
                              : Row(
                                children: [
                                  addText((double.parse(controller.cartList[index].product.price.toString())*double.parse(controller.cartList[index].quantity.toString())).toString(), getSubheadingTextFontSIze(), colorConstants.primaryColor2, FontWeight.bold),
                                  addText(getValue(SharedPref.currency), getSubheadingTextFontSIze(), colorConstants.primaryColor2, FontWeight.bold),
                                ],
                              ),
                              SizedBox(height: 0.5.h,),
                              addText('Quantity : ${controller.cartList[index].quantity.toString()}', getSmallTextFontSIze(), colorConstants.black, FontWeight.normal),
                            ],
                          ),),
                          Expanded(child: Container()),
                          Row(
                            children: [
                              SizedBox(height: 8.h,child: verticalDivider(),),
                              const SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  controller.deleteCartItem(controller.cartList[index].id.toString(), index);
                                },
                                child: SvgPicture.asset('assets/images/ic_del.svg'),
                              ),
                              const SizedBox(width: 10,),
                            ],
                          )
                        ],
                      ),
                    )
                    )
                );
              },
            )
            ))

          ],
        ),
      ),
    );
  }

  void showConfirmationPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctxt) => AlertDialog(
          title: Container(),
          content: SizedBox(
              height: 20.h,
              width: 90.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  addAlignedText(
                      "Are you sure you want place this order?",
                      getHeadingTextFontSIze(),
                      colorConstants.black,
                      FontWeight.bold),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          controller.placeOrder(context);
                        },
                        child: getSolidButton(30.w, "Continue"),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();

                        },
                        child: getBorderButton(30.w, 'Cancel'))
                    ],
                  )
                ],
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ));
  }

}