
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/search_controller.dart'
    as search_controller;
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/preferences.dart';
import 'package:odda/common/utils.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/light_header.dart';
import '../../routes/app_routes.dart';

class SearchView extends GetView<search_controller.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LightAppHeader(
                title: 'Search',
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                  // border: Border.all(color: colorConstants.primaryColor2, width: 2.0),
                  color: colorConstants.white,
                  borderRadius: getBorderRadius()),
              child: Row(
                children: [
                  SvgPicture.asset('assets/images/search.svg'),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 70.w,
                    child: GestureDetector(
                      onTap: () {
                        controller.isBlur.value = true;
                      },
                      child: TextFormField(
                        // inputFormatters: [CapitalCaseTextFormatter()],
                        keyboardType: TextInputType.text,
                        controller: controller.searchTextController,
                        textInputAction: TextInputAction.search,
                        // onFieldSubmitted: (value){
                        //   controller.getProductList(value);
                        // },
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            controller.isBlur.value = true;

                          } else {
                            controller.isBlur.value = false;
                          }
                          controller.debouncer.run(() async {
                            if (value.isNotEmpty) {
                              controller.getProductList(value.toString());
                              await Posthog().capture(eventName: 'product_search',properties: {
                                'user_id': getValue(SharedPref.userId),
                                'user_name': getValue(SharedPref.userName),
                                'mobile_no': getValue(SharedPref.mobileNo),
                                'search_text': value.toString(),
                              });
                            } else {
                              controller.productList.clear();
                            }
                          });
                        },
                        autofocus: true,
                        style: TextStyle(fontSize: getNormalTextFontSIze()),
                        decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                fontSize: getNormalTextFontSIze(),
                                color: colorConstants.greyTextColor),
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 0, 10, 0),
                            border: InputBorder.none),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                  color: colorConstants.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Obx(() => controller.isProductLoading.value
                  ? buildLoader()
                  : controller.productList.isEmpty
                      ? Center(
                          child: addText(
                              'No Item Found',
                              getHeadingTextFontSIze(),
                              colorConstants.black,
                              FontWeight.bold),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: controller.productList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Get.focusScope!.unfocus();
                                  Get.toNamed(Routes.ProductDetail, arguments: {
                                    'title': controller.productList[index].name
                                        .toString(),
                                    'productId': controller
                                        .productList[index].id
                                        .toString()
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: colorConstants.white,
                                        borderRadius: getCurvedBorderRadius(),
                                        boxShadow: [getDeepBoxShadow()]),
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: addText(
                                                          '${controller.productList[index].name}',
                                                          getNormalTextFontSIze(),
                                                          colorConstants.black,
                                                          FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: addText(
                                                        // controller.productList[index].vendorName.toString().toString(),
                                                        controller
                                                            .productList[index]
                                                            .vendorName,
                                                        getNormalTextFontSIze(),
                                                        colorConstants.black,
                                                        FontWeight.bold),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          addText(
                                                              '${controller.productList[index].distance.toString().toString()} km',
                                                              getNormalTextFontSIze(),
                                                              colorConstants
                                                                  .primaryColor,
                                                              FontWeight.bold),
                                                          Obx(() => controller
                                                                      .showQty[
                                                                  index]
                                                              ? TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        colorConstants
                                                                            .primaryColor,
                                                                    shape:
                                                                        const CircleBorder(),
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    color: colorConstants
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    controller
                                                                        .showHide(
                                                                            index);
                                                                  },
                                                                )
                                                              : TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        colorConstants
                                                                            .primaryColor,
                                                                    shape:
                                                                        const CircleBorder(),
                                                                  ),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .arrow_drop_up,
                                                                    color: colorConstants
                                                                        .white,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    controller
                                                                        .showHide(
                                                                            index);
                                                                  },
                                                                )),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),

                                              Obx(() =>
                                                  controller.showQty[index]
                                                      ? const Divider(
                                                          height: 20,
                                                        )
                                                      : Container()),

                                              // Obx(() => controller.showQty[index] ?  Row(
                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              //   mainAxisSize: MainAxisSize.max,
                                              //   crossAxisAlignment: CrossAxisAlignment.center,
                                              //   children: [
                                              //
                                              //     SizedBox(
                                              //       width: 8.h,
                                              //       height: 8.h,
                                              //      /* child: ClipRRect(
                                              //         borderRadius:
                                              //         getCurvedBorderRadius(),
                                              //         child: Image.network(
                                              //           controller.productList[index]
                                              //               .productImages[0].name
                                              //               .toString(),
                                              //           fit: BoxFit.cover,
                                              //         ),
                                              //       ),*/
                                              //     ),
                                              //
                                              //     addText(
                                              //         '${controller.productList[index].price.toString().toString()} ${getValue(SharedPref.currency)}',
                                              //         getNormalTextFontSIze(),
                                              //         colorConstants.primaryColor,
                                              //         FontWeight.bold)
                                              //
                                              //   ],
                                              // ) : Container()),
                                              Obx(
                                                  () =>
                                                      controller.showQty[index]
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    // SvgPicture.asset(
                                                                    //   'assets/images/ic_productorderInfo.svg',
                                                                    //   width: 18,
                                                                    // ),
                                                                    addText(
                                                                        'Stock : ',
                                                                        getNormalTextFontSIze(),
                                                                        colorConstants
                                                                            .black,
                                                                        FontWeight
                                                                            .bold),
                                                                    addText(
                                                                        controller.productList[index].quantity.toString() ==
                                                                                '0'
                                                                            ? 'Sold Out'
                                                                            : controller.productList[index].quantity
                                                                                .toString(),
                                                                        getNormalTextFontSIze(),
                                                                        controller.productList[index].quantity.toString() ==
                                                                                '0'
                                                                            ? Colors
                                                                                .red
                                                                            : Colors
                                                                                .green,
                                                                        FontWeight
                                                                            .bold),
                                                                  ],
                                                                ),
                                                                addText(
                                                                    'Price ${controller.productList[index].price.toString().toString()} ${getValue(SharedPref.currency)}',
                                                                    getNormalTextFontSIze(),
                                                                    colorConstants
                                                                        .primaryColor,
                                                                    FontWeight
                                                                        .bold)
                                                              ],
                                                            )
                                                          : Container()),
                                            ],
                                          ),
                                        ),
                                        if (index < 2 &&
                                            controller.productList[index]
                                                    .isFeatured ==
                                                1)
                                          Positioned(
                                            top: 10,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  color:
                                                      colorConstants.whiteShade,
                                                  borderRadius:
                                                      getBorderRadius()),
                                              child: addText(
                                                  'Ad',
                                                  getSmallestTextFontSIze() + 1,
                                                  colorConstants.black,
                                                  FontWeight.normal),
                                            ),
                                          )
                                      ],
                                    )));
                          },
                        )
              ),
            ))
          ],
        ),
      ),
    );
  }
}
