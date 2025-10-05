import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/bottom_navigation.dart';
import '../../../common/preferences.dart';
import '../../controller/product_detail_controller.dart';
import '../../routes/app_routes.dart';

class ProductDetail extends GetView<ProductDetailController> {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      bottomNavigationBar: const AppBottomNavigation(),
      body:  SafeArea(
        child: Obx(() => controller.isLoading.value
            ? buildLoader()
            : Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              buildAppBar(context),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      CarouselSlider.builder(
                        carouselController:
                        controller.buttonCarouselController,
                        itemCount: controller
                            .productDetailData.data.productImages.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) =>
                            ClipRRect(
                              borderRadius: getCurvedBorderRadius(),
                              child: CachedNetworkImage(
                                imageUrl: controller.productDetailData.data
                                    .productImages[itemIndex].name,
                                fit: BoxFit.cover,
                                alignment: Alignment.bottomCenter,
                                errorWidget: (context, url, error) =>
                                    Image.network('https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'),
                              )
                            ),
                        options: CarouselOptions(
                          height: 66.w,
                          // aspectRatio: 16/9,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          // onPageChanged: controller.onPageChanged(),
                          onPageChanged: controller.onPageChanged,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 13.w,
                        child: buildHorizontalImages(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addText(
                                  controller.productDetailData.data.name
                                      .toString(),
                                  getLargeTextFontSIze(),
                                  colorConstants.black,
                                  FontWeight.bold),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/ic_productorderInfo.svg',
                                    width: 18,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  addText('Stock : ', getNormalTextFontSIze(),
                                      colorConstants.black, FontWeight.bold),
                                  addText(
                                      controller.productDetailData.data.quantity.toString() == '0'
                                          ? 'Sold Out'
                                          : 'Available',
                                      getNormalTextFontSIze(),
                                      controller.productDetailData.data
                                          .quantity
                                          .toString() ==
                                          '0'
                                          ? Colors.red
                                          : Colors.green,
                                      FontWeight.bold)
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/ic_productPrice.svg',
                                    width: 18,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  getValue(SharedPref.currency).length == 1 ?
                                  addText(
                                      '${getValue(SharedPref.currency)}${controller
                                          .productDetailData.data.price}',
                                      getHeadingTextFontSIze(),
                                      colorConstants.primaryColor2,
                                      FontWeight.bold)  :   addText(
                                      '${controller
                                          .productDetailData.data.price} ${getValue(SharedPref.currency)}',
                                      getHeadingTextFontSIze(),
                                      colorConstants.primaryColor2,
                                      FontWeight.bold),
                                ],
                              ),
                             // if(controller.productDetailData.data.brand_name != '')
                              const SizedBox(
                                height: 20,
                              ),
                             /* if(controller.productDetailData.data.brand_name != '')
                              buildInfo('ic_productCat',
                                  'Brand Name : ${controller.productDetailData.data.brand_name.toString()}'),
                              const SizedBox(
                                height: 20,
                              ),
                              buildInfo('ic_productCat',
                                  'Category : ${controller.productDetailData.data.category.name.toString()}'),
                              const SizedBox(
                                height: 20,
                              ),*/
                              buildInfo('ic_home',
                                  "Vendor Address :  ${controller.productDetailData.data.address.toString()}"),
                            ],
                          ),
                          // Positioned(
                          //     right: 1,
                          //     child: GestureDetector(
                          //       onTap: (){
                          //         Get.toNamed(Routes.DetailReview,
                          //             arguments: {
                          //               'id': controller.productDetailData.data.id.toString(),
                          //               'type': 'product',
                          //             });
                          //       },
                          //       child: Container(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 15, vertical: 5),
                          //         decoration: BoxDecoration(
                          //             borderRadius: getBorderRadius(),
                          //             boxShadow: [getDeepBoxShadow()],
                          //             color: colorConstants.white),
                          //         child: Column(
                          //           children: [
                          //             const Icon(
                          //               Icons.star,
                          //               color: colorConstants.buttonColor,
                          //             ),
                          //             addText(
                          //                 controller.productDetailData.data.rating.toString(),
                          //                 getSmallTextFontSIze(),
                          //                 colorConstants.black,
                          //                 FontWeight.normal)
                          //           ],
                          //         ),
                          //       ),
                          //     )),

                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),


                      controller.isAddedToCart.value ? GestureDetector(
                        onTap: (){
                          Get.back();
                          Get.toNamed(Routes.Cart);
                        },
                        child: getSolidButton(90.w, 'Go to Cart'),
                      ) :
                      controller.productDetailData.data.quantity >= 1 ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 34.w,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: colorConstants.primaryColor2),
                                borderRadius: getBorderRadiusCircular()),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.productCount.value > 1) {
                                      controller.productCount.value--;
                                    }
                                  },
                                  child: const Icon(Icons.remove),
                                ),


                                GestureDetector(
                                  onTap: (){
                                    showQuantityDialog(context);
                                  },
                                  child: Obx(() => addText(
                                      controller.productCount.value
                                          .toString(),
                                      getNormalTextFontSIze() + 2,
                                      colorConstants.black,
                                      FontWeight.bold)),
                                ),



                                GestureDetector(
                                  onTap: () {
                                    controller.productCount.value++;
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                          controller.isAddingtoCart.value ? getLoader() : GestureDetector(
                            onTap: () async {
                              if (!GetStorage().hasData(SharedPref.authToken)) {
                                Get.toNamed(Routes.Login);
                              } else {
                                controller.addToCart(context,controller.productId.toString());

                                await Posthog().capture(eventName: 'product_added_to_cart',properties: {
                                  'cart_added_product_id': controller.productId.toString(),
                                  'user_id': getValue(SharedPref.userId),
                                  'user_name': getValue(SharedPref.userName),
                                  'mobile_no': getValue(SharedPref.mobileNo),

                                });

                              }
                            },
                            child: getSolidButton(50.w, 'Add to Cart'),
                          )
                        ],
                      ) : getDisabledButton(100.w, 'Sold Out'),




                  /*    const SizedBox(
                        height: 20,
                      ),
                      addText('Product Description', getNormalTextFontSIze(),
                          colorConstants.black, FontWeight.bold),
                      const SizedBox(
                        height: 10,
                      ),
                      addText(
                          controller.productDetailData.data.description
                              .toString(),
                          getSmallTextFontSIze(),
                          colorConstants.black,
                          FontWeight.normal),*/
                      const SizedBox(
                        height: 20,
                      ),
                      if(controller.productDetailData.data.vendor.mobileNo != null)

                      buildSellerSection(context),
                      const SizedBox(
                        height: 20,
                      ),
                      addText('Related Products', getNormalTextFontSIze(),
                          colorConstants.black, FontWeight.bold),
                      const SizedBox(
                        height: 20,
                      ),
                      buildRelatedProducts(context),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ))
            ],
          ),
        )),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: colorConstants.white,
              ),
            ),
          ],
        ),
        addText('Products', getHeadingTextFontSIze(), colorConstants.black,
            FontWeight.w600),
        Row(
          children: [

            GestureDetector(
              onTap: () {
                if (GetStorage().hasData(SharedPref.authToken)) {
                  controller.addToWishList(context, controller.productId);
                } else {
                  Get.toNamed(Routes.Login);
                }
              },
              child: Obx(() => controller.isAdding.value
                  ? SizedBox(
                height: 20,
                width: 20,
                child: getLoader(),
              )
                  : controller.isFavourite.value
                  ? SvgPicture.asset(
                'assets/images/ic_favourite'
                    '.svg',
                height: 20,
              )
                  : SvgPicture.asset(
                'assets/images/non_favourite.svg',
                height: 20,
              )),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () async {
                if (GetStorage().hasData(SharedPref.authToken)) {
                  Get.toNamed(Routes.Notification);
                  await Posthog().capture(eventName: 'clicked_on_notifications',properties: {
                    'user_id': getValue(SharedPref.userId),
                    'user_name': getValue(SharedPref.userName),
                    'mobile_no': getValue(SharedPref.mobileNo),
                  });
                } else {
                  Get.toNamed(Routes.Login);
                }
              },
              child: SvgPicture.asset('assets/images/notification.svg'),
            )
          ],
        )
      ],
    );
  }

  Widget buildHorizontalImages() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          // controller.showCaseImageUrl.value = controller.productDetailData.data.productImages[index].name;
          controller.buttonCarouselController.jumpToPage(index);
        },
        child: Container(
          margin: const EdgeInsets.all(3),
          width: 13.w,
          height: 13.w,
          child: ClipRRect(
            borderRadius: getBorderRadius(),
            child:CachedNetworkImage(
              imageUrl: controller.productDetailData.data.productImages[index].name,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              errorWidget: (context, url, error) =>
                  Image.network('https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'),
            ),
          ),
        ),
      ),
      // itemCount: subCategoryList.length,
      itemCount: controller.productDetailData.data.productImages.length,
    );
  }

  Widget buildInfo(String image, String information) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/images/$image.svg',
          width: 18,
          color: colorConstants.black,
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(width: 80.w,child: addText(information, getNormalTextFontSIze(), colorConstants.black,
            FontWeight.bold),)
      ],
    );
  }

  Widget buildSellerSection(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routes.VendorProductsView,arguments: {
          'vendorId': controller.productDetailData.data.vendor.id.toString(),
          'vendorName': controller.productDetailData.data.vendor.name.toString(),
        });
      },
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            boxShadow: [getDeepBoxShadow()],
            color: colorConstants.white,
            borderRadius: getCurvedBorderRadius()),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addText('Meet the seller', getNormalTextFontSIze() - 1,
                    colorConstants.black, FontWeight.bold),
                // GestureDetector(
                //   onTap: () {
                //     if (controller.productDetailData.data.can_reviewed) {
                //       showReviewDialog(context);
                //     } else {
                //       showErrorDialog(context);
                //     }
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                //     decoration: BoxDecoration(
                //         color: colorConstants.black,
                //         borderRadius: getCurvedBorderRadius()),
                //     child: addText('Add Review', getSmallTextFontSIze(),
                //         colorConstants.white, FontWeight.normal),
                //   ),
                // )
              ],
            ),
            Divider(
              height: 4.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: getBorderRadiusCircular(),
                  child: Image.network(
                    controller.productDetailData.data.vendor.image.toString(),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addText(
                        controller.productDetailData.data.vendor.name.toString(),
                        getSmallTextFontSIze(),
                        colorConstants.black,
                        FontWeight.bold),
                    const SizedBox(
                      height: 5,
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     Get.toNamed(Routes.DetailReview,
                    //       arguments: {
                    //       'id':controller.productDetailData.data.id.toString(),
                    //       'type':'seller',
                    //       }
                    //     );
                    //   }, child: Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     addText(
                    //         controller.productDetailData.data.vendor.rating
                    //             .toString(),
                    //         getSmallTextFontSIze(),
                    //         colorConstants.black,
                    //         FontWeight.bold),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     RatingBar.builder(
                    //       itemSize: 15,
                    //       initialRating: controller
                    //           .productDetailData.data.vendor.rating
                    //           .toDouble(),
                    //       minRating: 1,
                    //       direction: Axis.horizontal,
                    //       allowHalfRating: true,
                    //       ignoreGestures: true,
                    //       itemCount: 5,
                    //       itemBuilder: (context, _) => const Icon(
                    //         Icons.star,
                    //         color: colorConstants.buttonColor,
                    //       ),
                    //       onRatingUpdate: (rating) {
                    //
                    //       },
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     addText(
                    //         '(${controller.productDetailData.data.vendor.review.length})',
                    //         getSmallTextFontSIze(),
                    //         colorConstants.black,
                    //         FontWeight.bold),
                    //   ],
                    // ),
                    // ),
                    // const SizedBox(height: 5,),
                    addText(
                        DateFormat('dd-MM-yyyy hh:mm').format(controller.productDetailData.data.vendor.createdAt),
                        getSmallTextFontSIze() - 1,
                        colorConstants.greyTextColor,
                        FontWeight.bold),

                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void showReviewDialog(BuildContext context) {
    controller.reviewtextController.clear();
    showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,

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
                                'Write your experience with the seller',
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
                                controller.vendorRating = rating.toString();
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
                                  // boxShadow: [getDeepBoxShadow()],
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
                                    const EdgeInsets.fromLTRB(20, 15, 10, 15),
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.addReview(
                                    controller
                                        .productDetailData.data.vendor.id
                                        .toString(),
                                    controller.vendorRating.toString(),
                                    controller.reviewtextController.text,
                                    true,
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

  void showErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) =>  AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(
            builder: (context) {
              return Container(
                width: 90.w,
                height: 30.h,
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
                            SizedBox(
                              height: 2.h,
                            ),
                            addAlignedText(
                                "Haven't purchased this product?",
                                getNormalTextFontSIze() + 2,
                                colorConstants.black,
                                FontWeight.bold),
                            SizedBox(
                              height: 2.h,
                            ),
                            addAlignedText(
                                "Sorry! You are not allowed to review this product since you haven't bought in on the ODDA store.",
                                getNormalTextFontSIze(),
                                colorConstants.black,
                                FontWeight.normal),
                            SizedBox(
                              height: 2.h,
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child:
                              getSolidButton(80.w, 'Continue Shopping'),
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

  Widget buildRelatedProducts(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 27.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.productDetailData.data.relatedProducts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                controller.productId = controller
                    .productDetailData.data.relatedProducts[index].id
                    .toString();
                controller.getProductDetails(controller.productId);
              },
              child: Container(
                margin: index.isOdd
                    ? const EdgeInsets.only(right: 10, left: 5, bottom: 10)
                    : const EdgeInsets.only(left: 10, right: 5, bottom: 10),
                decoration: BoxDecoration(
                    boxShadow: [getDeepBoxShadow()],
                    color: colorConstants.white,
                    borderRadius: getCurvedBorderRadius()),
                child: ClipRRect(
                  borderRadius: getCurvedBorderRadius(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl:  controller.productDetailData.data.relatedProducts[index].productImages[0].name.toString(),
                            fit: BoxFit.cover,
                            height: 16.h,
                            width: 45.w,
                            alignment: Alignment.bottomCenter,
                            errorWidget: (context, url, error) =>
                                Image.network('https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'),
                          )

                         /* Image.network(
                            controller.productDetailData.data.relatedProducts[index].productImages[0].name.toString(),
                            fit: BoxFit.cover,
                            height: 16.h,
                            width: 45.w,
                          ),*/
                          // if(index%3 ==0)
                          //   Align(
                          //     heightFactor:5 ,
                          //     alignment: Alignment.bottomCenter,
                          //     child: buildSoldOutIcon(),)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: addText(
                            controller.productDetailData.data.relatedProducts[index].name.toString(),
                            getSmallTextFontSIze(),
                            colorConstants.black,
                            FontWeight.normal),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            getValue(SharedPref.currency).length == 1 ?
                            addText(
                                '${getValue(SharedPref.currency)}${controller.productDetailData.data.relatedProducts[index].price.toString()}',
                                getSmallTextFontSIze() - 1,
                                colorConstants.black,
                                FontWeight.w800)  :   addText(
                                '${controller.productDetailData.data.relatedProducts[index].price.toString()} ${getValue(SharedPref.currency)}',
                                getSmallTextFontSIze() - 1,
                                colorConstants.black,
                                FontWeight.w800),
                            // verticalDivider(),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.end,
                            //   children: [
                            //     Icon(
                            //       Icons.star,
                            //       color: colorConstants.buttonColor,
                            //       size: getHeadingTextFontSIze(),
                            //     ),
                            //     addText(
                            //         controller.productDetailData.data.relatedProducts[index].rating.toString(),
                            //         getSmallTextFontSIze(),
                            //         colorConstants.black,
                            //         FontWeight.w800),
                            //   ],
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  void showQuantityDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Container(),
          content: SizedBox(
              width: 70.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [

                  addText('Update Quantity', getHeadingTextFontSIze(), colorConstants.black, FontWeight.w600),
                  SizedBox(height: 1.h,),


                  SizedBox(height: 1.h,),
                  SizedBox(width: 90.w
                    ,child: addNumberEditText(controller.productCountController, '0'),),


                  SizedBox(height: 1.h,),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.productCount.value = int.parse(controller.productCountController.text);
                    },
                    child: getSolidButton(90.w, "Update"),
                  ),

                  SizedBox(height: 1.h,),
                ],
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ));
  }
}
