import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/bottom_navigation.dart';
import '../../../common/header.dart';
import '../../../common/preferences.dart';
import '../../controller/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      bottomNavigationBar: const AppBottomNavigation(),
      body: RefreshIndicator(
        onRefresh: () async {
          if (controller.categorySelectedPos.value == 0) {
            controller.getOrders('');
          } else if (controller.categorySelectedPos.value == 1) {
            controller.getOrders('4');
          } else if (controller.categorySelectedPos.value == 2) {
            controller.getOrders('5');
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppHeader(title: 'My Orders'),
              ),
              SizedBox(
                height: 4.h,
              ),
              buildCategories(),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Obx(() => controller.isLoading.value
                      ? buildLoader()
                      : controller.orderList.isEmpty
                          ? Center(
                              child: addText(
                                  'No orders found',
                                  getSubheadingTextFontSIze(),
                                  colorConstants.black,
                                  FontWeight.w600))
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: controller.orderList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      if (controller.orderList[index].status !=
                                          5) {
                                        controller.selectedIndex = index;
                                        controller.getOrderDetails(context);
                                        Get.toNamed(Routes.OrderDetailsView);
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: colorConstants.white,
                                          borderRadius: getCurvedBorderRadius(),
                                          boxShadow: [getDeepBoxShadow()]),
                                      child: Stack(
                                        children: [
                                          if (controller.categorySelectedPos
                                                      .value ==
                                                  0 &&
                                              controller.orderList[index].status
                                                      .toString() ==
                                                  '0')
                                            buildStatus(index, Colors.green,
                                                'Confirmed'),

                                          if (controller.categorySelectedPos
                                                      .value ==
                                                  0 &&
                                              controller.orderList[index].status
                                                      .toString() ==
                                                  '1')
                                            buildStatus(index, Colors.purple,
                                                'Ready to ship'),

                                          if (controller.categorySelectedPos
                                                      .value ==
                                                  0 &&
                                              controller.orderList[index].status
                                                      .toString() ==
                                                  '2')
                                            buildStatus(index, Colors.yellow,
                                                'Shipped'),

                                          if (controller.categorySelectedPos
                                                      .value ==
                                                  0 &&
                                              controller.orderList[index].status
                                                      .toString() ==
                                                  '3')
                                            buildStatus(index, Colors.black,
                                                'On the way'),

                                          if (controller
                                              .orderList[index].canCancel)
                                            buildCancel(
                                                index,
                                                const Color(0xFFcf142b),
                                                'Cancel Order',
                                                context),

                                          Positioned(
                                            right: 10,
                                            top: 30,
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed(Routes.ChatView,
                                                    arguments: {
                                                      // 'vendorName' : controller.productDetailData.data.vendor.name.toString(),
                                                      // 'vendorImage' : controller.productDetailData.data.vendor.image.toString(),
                                                      // 'vendorId' : controller.productDetailData.data.vendor.id.toString(),

                                                      'vendorName': controller
                                                          .orderList[index]
                                                          .product
                                                          .vendor['name']
                                                          .toString(),
                                                      'vendorImage': controller
                                                          .orderList[index]
                                                          .product
                                                          .vendor['image']
                                                          .toString(),
                                                      'vendorId': controller
                                                          .orderList[index]
                                                          .product
                                                          .vendor['id']
                                                          .toString(),
                                                    });
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/ic_chat.svg',
                                                color:
                                                    colorConstants.primaryColor,
                                              ),
                                            ),
                                          ),

                                          // if(controller.categorySelectedPos.value == 1)
                                          //   Positioned(
                                          //     right: 0,
                                          //     top: 0,
                                          //     child: GestureDetector(
                                          //       onTap: (){
                                          //         showReviewDialog(context,index);
                                          //       },
                                          //       child: Container(
                                          //         padding: const EdgeInsets.symmetric(
                                          //             horizontal: 20, vertical: 2),
                                          //         decoration: const BoxDecoration(
                                          //           borderRadius: BorderRadius.only(
                                          //               topRight:
                                          //               Radius.circular(20)),
                                          //           color:colorConstants.black,
                                          //         ),
                                          //         child: addText('Add Review',
                                          //             getSmallTextFontSIze(),
                                          //             colorConstants.white,
                                          //             FontWeight.w600),
                                          //       ),
                                          //     ),
                                          //   ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 30),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 8.h,
                                                  height: 10.h,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        getCurvedBorderRadius(),
                                                    child: Image.network(
                                                        controller
                                                            .orderList[index]
                                                            .product
                                                            .productImages[0]
                                                            .name
                                                            .toString()),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    addText(
                                                        DateFormat(
                                                                "d MMMM yyyy")
                                                            .format(controller
                                                                .orderList[
                                                                    index]
                                                                .createdAt),
                                                        getSmallTextFontSIze() -
                                                            1,
                                                        colorConstants
                                                            .greyTextColor,
                                                        FontWeight.w600),
                                                    addText(
                                                        controller
                                                            .orderList[index]
                                                            .product
                                                            .name
                                                            .toString(),
                                                        getSmallTextFontSIze(),
                                                        colorConstants.black,
                                                        FontWeight.w600),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        getValue(SharedPref
                                                                        .currency)
                                                                    .length ==
                                                                1
                                                            ? addText(
                                                                '${getValue(SharedPref.currency)} ${controller.orderList[index].total.toString()}',
                                                                getNormalTextFontSIze(),
                                                                colorConstants
                                                                    .primaryColor2,
                                                                FontWeight.bold)
                                                            : addText(
                                                                '${controller.orderList[index].total.toString()} ${getValue(SharedPref.currency)}',
                                                                getNormalTextFontSIze(),
                                                                colorConstants
                                                                    .primaryColor2,
                                                                FontWeight
                                                                    .bold),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/images/Pin.svg',
                                                          color: colorConstants
                                                              .greyTextColor,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        addText(
                                                            controller
                                                                .orderList[
                                                                    index]
                                                                .order
                                                                .orderAddress
                                                                .city
                                                                .toString(),
                                                            getSmallTextFontSIze(),
                                                            colorConstants
                                                                .greyTextColor,
                                                            FontWeight.w600),
                                                      ],
                                                    ),
                                                    addText(
                                                        'Quantity : ${controller.orderList[index].quantity.toString()}',
                                                        getSmallTextFontSIze(),
                                                        colorConstants
                                                            .greyTextColor,
                                                        FontWeight.w600),
                                                    if (controller
                                                            .categorySelectedPos
                                                            .value ==
                                                        0)
                                                      Container()
                                                      /*addText(
                                                          'Expected Delivery : ${controller.orderList[index].order.deliveryDate}',
                                                          getSmallTextFontSIze(),
                                                          colorConstants.black,
                                                          FontWeight.w600)*/,
                                                    if (controller
                                                            .categorySelectedPos
                                                            .value ==
                                                        1)
                                                      addText(
                                                          'Delivered On : ${controller.orderList[index].order.deliveryDate}',
                                                          getSmallTextFontSIze(),
                                                          colorConstants.black,
                                                          FontWeight.w600),
                                                    if (controller
                                                            .categorySelectedPos
                                                            .value ==
                                                        2)
                                                      addText(
                                                          'Canceled On : ${DateFormat("d MMMM yyyy").format(controller.orderList[index].createdAt)}',
                                                          getSmallTextFontSIze(),
                                                          colorConstants.black,
                                                          FontWeight.w600),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              },
                            )))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatus(int index, Color bgColor, String text) {
    return Positioned(
      right: 0,
      child: Container(
        width: 35.w,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.only(topRight: Radius.circular(20)),
            // gradient: getBgGradient(),
            color: bgColor
            // color: Colors.green
            ),
        child: Column(
          children: [
            if (controller.orderList[index].status.toString() == '0')
              addText('Confirmed', getSmallTextFontSIze(), colorConstants.white,
                  FontWeight.w600),
            if (controller.orderList[index].status.toString() == '1')
              addText('Ready to ship', getSmallTextFontSIze(),
                  colorConstants.white, FontWeight.w600),
            if (controller.orderList[index].status.toString() == '2')
              addText('Shipped', getSmallTextFontSIze(), colorConstants.white,
                  FontWeight.w600),
            if (controller.orderList[index].status.toString() == '3')
              addText('On the way', getSmallTextFontSIze(),
                  colorConstants.white, FontWeight.w600),
          ],
        ),
      ),
    );
  }

  Widget buildCancel(
      int index, Color bgColor, String text, BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          showConfirmationPopup(context, index);
        },
        child: Container(
          width: 30.w,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(20)),
              // gradient: getBgGradient(),
              color: bgColor
              // color: Colors.green
              ),
          child: Column(
            children: [
              addText(text, getSmallTextFontSIze(), colorConstants.white,
                  FontWeight.w600),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories() {
    return Center(
      child: SizedBox(
        height: 55,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.categoryList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                controller.categorySelectedPos.value = index;
                if (index == 0) {
                  controller.getOrders('');
                } else if (index == 1) {
                  controller.getOrders('4');
                } else if (index == 2) {
                  controller.getOrders('5');
                }
              },
              child: Obx(() => Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    decoration: BoxDecoration(
                        borderRadius: getBorderRadiusCircular(),
                        color: controller.categorySelectedPos.value == index
                            ? colorConstants.buttonColor
                            : colorConstants.white,
                        boxShadow: [getDeepBoxShadow()]),
                    child: Center(
                      child: addText(
                          controller.categoryList[index],
                          getSubheadingTextFontSIze() - 1,
                          controller.categorySelectedPos.value == index
                              ? colorConstants.white
                              : colorConstants.black,
                          FontWeight.normal),
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }

  void showReviewDialog(BuildContext context, int index) {
    // print('{Product Id ${controller.orderList[index].productId.toString()}');
    controller.reviewtextController.clear();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: 90.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                        borderRadius: getCurvedBorderRadius(),
                        color: colorConstants.white),
                    child: ClipRRect(
                        borderRadius: getCurvedBorderRadius(),
                        child: Scaffold(
                          backgroundColor: colorConstants.white,
                          body: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: GestureDetector(
                                      onTap: () => Get.back(),
                                      child: const Icon(
                                        Icons.close,
                                        color: colorConstants.black,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                addText(
                                    'Write your experience with the product',
                                    getNormalTextFontSIze(),
                                    colorConstants.black,
                                    FontWeight.bold),
                                SizedBox(
                                  height: 2.h,
                                ),
                                RatingBar.builder(
                                  initialRating: 5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  tapOnlyMode: false,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: colorConstants.buttonColor,
                                  ),
                                  onRatingUpdate: (rating) {
                                    // print(rating);
                                    controller.productRating =
                                        rating.toString();
                                  },
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  width: 80.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                      color: colorConstants.white,
                                      border: Border.all(
                                          color: colorConstants.lightGrey),
                                      borderRadius: getBorderRadius()),
                                  child: TextFormField(
                                    maxLines: 3,
                                    keyboardType: TextInputType.multiline,
                                    controller: controller.reviewtextController,
                                    textInputAction: TextInputAction.newline,
                                    style: TextStyle(
                                        fontSize: getNormalTextFontSIze()),
                                    decoration: InputDecoration(
                                        hintText: 'Comment'.tr,
                                        hintStyle: TextStyle(
                                            fontSize: getNormalTextFontSIze(),
                                            color:
                                                colorConstants.greyTextColor),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 15, 10, 15),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.addReview(
                                        controller.orderList[index].productId
                                            .toString(),
                                        controller.productRating.toString(),
                                        controller.reviewtextController.text,
                                        false,
                                        context);
                                  },
                                  child: getSolidButton(80.w, 'Submit'),
                                )
                              ],
                            ),
                          ),
                        )),
                  );
                },
              ),
            ));
  }

  void showConfirmationPopup(BuildContext context, int index) {
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
                          "Are you sure you want cancel this order?",
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
                              controller.cancelOrder(
                                  controller.orderList[index].id.toString(),
                                  context,
                                  index);
                            },
                            child: getSolidButton(30.w, "Yes"),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: getBorderButton(30.w, 'No'))
                        ],
                      )
                    ],
                  )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ));
  }
}
