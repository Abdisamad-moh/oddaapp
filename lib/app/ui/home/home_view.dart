import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/bottom_navigation.dart';
import '../../../common/drawer.dart';
import '../../../common/preferences.dart';
import '../../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    return Scaffold(
      key: controller.key,
      backgroundColor: colorConstants.primaryColor,
      drawer: const AppDrawer(),
      // bottomNavigationBar: const AppBottomNavigation(),
      bottomNavigationBar: Container(
          color: colorConstants.white,
          child: const AppBottomNavigation()),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.currentPage = 1;
          controller.getProductList("10000");
          controller.getBanners();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.key.currentState!.openDrawer();
                      },
                      child: SvgPicture.asset(
                        'assets/images/menu.svg',
                        color: colorConstants.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.Address);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/images/Pin.svg', color: colorConstants
                              .white,),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 60.w),
                            // width: 60.w,
                            child: GestureDetector(
                              onTap: () => controller.getCurrentAddress(),
                              child: Obx(() =>
                              controller.isLocationLoading.value
                                  ? const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(),
                              )
                              // : addText(controller.currentAddress.value, getSmallTextFontSIze(), colorConstants.white, FontWeight.w600)),
                                  : addText(
                                  controller.currentAddress.value == "null"
                                      ? "Permission Required"
                                      : controller.currentAddress.value,
                                  getSmallTextFontSIze(), colorConstants.white,
                                  FontWeight.w600)),
                            ),)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (GetStorage().hasData(SharedPref.authToken)) {
                          Get.toNamed(Routes.Notification);


                          await Posthog().capture(
                              eventName: 'clicked_on_notifications',
                              properties: {
                                'user_id': getValue(SharedPref.userId),
                                'user_name': getValue(SharedPref.userName),
                                'mobile_no': getValue(SharedPref.mobileNo),
                              });
                        } else {
                          Get.toNamed(Routes.Login);
                        }
                      },
                      child: Stack(
                        children: [
                          SvgPicture.asset('assets/images/notification.svg',
                            color: colorConstants.white,),
                          Obx(() =>
                          controller.isNewNotification.value ? Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle
                            ),
                          ) : const SizedBox.shrink()),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              GestureDetector(
                onTap: () async {
                  await Posthog().screen(
                      screenName: 'search_screen', properties: {
                    'user_id': getValue(SharedPref.userId),
                    'user_name': getValue(SharedPref.userName),
                    'mobile_no': getValue(SharedPref.mobileNo),
                  }).then((value) {
                    print('object:::::');
                  });
                  Get.toNamed(Routes.Search);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorConstants.white,
                    boxShadow: [getDeepBoxShadow()],
                    borderRadius: getEdgyBorderRadius(),),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/images/search.svg'),
                      const SizedBox(width: 10,),
                      addText('Search Products / Distributors / Category',
                          getNormalTextFontSIze(), colorConstants.greyTextColor,
                          FontWeight.normal)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h,),

              Expanded(child: Container(
                decoration: const BoxDecoration(
                    color: colorConstants.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller.scrollController,
                  children: [
                    SizedBox(height: 2.h,),
                    Obx(() =>
                    controller.isBannerLoading.value ? SizedBox(
                        height: 66.w,
                        child: buildLoader()) : buildCarousel()),
                    SizedBox(height: 2.h,),
                    Obx(() =>
                    controller.isBannerLoading.value ? Container() : Align(
                      alignment: Alignment.center,
                      child: Obx(() =>
                          CarouselIndicator(
                            count: controller.bannerList.length,
                            index: controller.selectedIndex.value,
                            color: colorConstants.lightGrey,
                            activeColor: colorConstants.primaryColor,
                            width: 10,
                          )),
                    )),
                    SizedBox(height: 2.h,),
                    /* Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: addText('Categories', getNormalTextFontSIze(), colorConstants.black, FontWeight.bold),
                    ),
                    SizedBox(height: 1.h,),
                    buildCategories(),
                    SizedBox(height: 1.h,),*/
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          addText('Products', getSubheadingTextFontSIze(),
                              colorConstants.black, FontWeight.bold),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.ProductView, arguments: {
                                'title': "Products",
                                'categoryId': '10000',
                                'itemType': 'all',
                                'bannerId': '',
                                'isBanner': false,
                                'isBannerproduct': false,
                                'ad_id': "",
                              });
                            },
                            child: addText('See All', getSmallTextFontSIze(),
                                colorConstants.primaryColor2, FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    Obx(() =>
                    controller.isProductLoading.value
                        ? buildProductLoader()
                        : controller.productList.isEmpty
                        ? Center(child: addText(
                        'No Item Found', getHeadingTextFontSIze(),
                        colorConstants.black, FontWeight.bold),)
                        : buildGrids()),

                    Obx(() {
                      return controller.isLoadMore.value? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(strokeWidth: 1,).marginOnly(right: 12),
                          addText('loading...', getHeadingTextFontSIze(),
                              colorConstants.black, FontWeight.bold)
                        ],
                      ): const SizedBox.shrink();
                    }),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories() {
    return SizedBox(
      height: 55,
      child: Obx(() =>
      controller.isLoading.value
          ? buildShimmer()
          : ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categoriesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.currentPage = 1;
              controller.getProductList(
                  controller.categoriesList[index].id.toString());
              controller.categorySelectedPos.value = index;
            },
            child: Obx(() =>
                Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: getBorderRadiusCircular(),
                      // color: selectedPos == int ? colorConstants.notificationBgColor : colorConstants.notificationBgColorLight
                      color: controller.categorySelectedPos.value == index
                          ? colorConstants.black
                          : colorConstants.white,
                      boxShadow: [getDeepBoxShadow()]),
                  child: Center(
                    child: addText(
                        controller.categoriesList[index].name.toString(),
                        getNormalTextFontSIze() - 1,
                        controller.categorySelectedPos.value == index
                            ? colorConstants.white
                            : colorConstants.black,
                        FontWeight.normal),
                  ),
                )),
          );
        },
      )),
    );
  }

  Widget buildGrids() {
    // lokesh
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 30.h),
      itemBuilder: (context, index) =>
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.ProductDetail, arguments: {
                'title': controller.productList[index].name,
                'productId': controller.productList[index].id.toString()
              });
            },
            child: buildItem(index),
          ),
      itemCount: controller.productList.length,
    );
  }

  Widget buildItem(int index) {
    return Container(
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
                controller.productList[index].productImages.isNotEmpty ?
                CachedNetworkImage(
                  imageUrl: controller.productList[index].productImages[0].name,
                  fit: BoxFit.cover,
                  height: 16.h,
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  errorWidget: (context, url, error) =>
                      Image.network(
                          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'),
                ) : SizedBox(height: 16.h,
                  child: Center(child: addText(
                      'No Image', getSmallTextFontSIze(), colorConstants.black,
                      FontWeight.w800),),),

                if(controller.productList[index].quantity == 0)
                  Positioned(
                    top: 8.h,
                    left: 20,
                    right: 20,
                    child: buildSoldOutIcon(),
                  )
              ],
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: addText(
                  controller.productList[index].name,
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
                      '${getValue(SharedPref.currency)}${controller
                          .productList[index].price}',
                      getSmallTextFontSIze() - 1,
                      colorConstants.black,
                      FontWeight.w800) :
                  addText(
                      '${controller.productList[index].price} ${getValue(
                          SharedPref.currency)}',
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
                  //         controller.productList[index].rating.toString(),
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
    );
  }

  Widget buildCarousel() {
    /* return CarouselSlider.builder(
      carouselController:
      controller.buttonCarouselController,
      itemCount: controller.bannerList.length,
      itemBuilder: (BuildContext context, int itemIndex,
          int pageViewIndex) =>
          GestureDetector(
            onTap: (){
              if(controller.bannerList[itemIndex].has_product) {
                Get.toNamed(Routes.ProductView, arguments: {
                  'title': 'Product',
                  'categoryId': '',
                  'itemType': '',
                  'bannerId': controller.bannerList[itemIndex].id.toString(),
                  'isBanner': true,
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: getCurvedBorderRadius(),
                child: Container(
                  color: colorConstants.lightGrey,
                  child: Image.network(
                    controller.bannerList[itemIndex].image.toString(),
                    fit: BoxFit.cover,

                  ),
                ),
              ),
            ),
          ),
      options: CarouselOptions(
        scrollPhysics: const BouncingScrollPhysics(),
        height: 66.w,
        // aspectRatio: 16/9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: true,

        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (value,reason){
          controller.onPageChanged(value);
        },
        scrollDirection: Axis.horizontal,
      ),
    );*/
    return CarouselSlider.builder(
      carouselController:
      controller.buttonCarouselController,
      itemCount: controller.bannerList.length,
      itemBuilder: (BuildContext context, int itemIndex,
          int pageViewIndex) =>
          GestureDetector(
            onTap: () async {
              if (controller.bannerList[itemIndex].has_product) {
                await Posthog().capture(eventName: 'on_banner_click',
                    properties: {
                      'banner_id': controller.bannerList[itemIndex].id
                          .toString(),
                      'user_id': getValue(SharedPref.userId),
                      'user_name': getValue(SharedPref.userName),
                      'mobile_no': getValue(SharedPref.mobileNo),
                    });

                Get.toNamed(Routes.ProductView, arguments: {
                  'title': 'Product',
                  'categoryId': '',
                  'itemType': '',
                  'bannerId': controller.bannerList[itemIndex].id.toString(),
                  'isBanner': true,
                  'ad_id': "",
                  'isBannerproduct': controller.bannerList[itemIndex]
                      .is_banner ?? true,
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: getCurvedBorderRadius(),
                child: Container(
                  color: colorConstants.lightGrey,
                  child: Image.network(
                    controller.bannerList[itemIndex].image.toString(),
                    fit: BoxFit.cover,

                  ),
                ),
              ),
            ),
          ),
      options: CarouselOptions(
        scrollPhysics: const BouncingScrollPhysics(),
        height: 66.w,
        // aspectRatio: 16/9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (value, reason) {
          controller.onPageChanged(value);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildShimmer() {
    return SizedBox(
      width: 100.w,
      height: 55,
      child: Shimmer.fromColors(
        baseColor: colorConstants.lightGrey,
        highlightColor: colorConstants.shimmerColor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, __) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 30.w,
                      height: 45,
                      decoration: BoxDecoration(
                          color: colorConstants.white,
                          borderRadius: getBorderRadiusCircular()),
                    ),
                  ],
                ),
              ),
          itemCount: 6,
        ),
      ),
    );
  }
}
