import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/vendor_products_controller.dart';
import 'package:odda/common/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/light_header.dart';
import '../../../common/preferences.dart';
import '../../../common/utils.dart';
import '../../controller/product_detail_controller.dart';

class VendorProductView extends GetView<VendorProductsController> {
  const VendorProductView({super.key});

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
                title: 'Seller Products',
              ),
            ),

            Center(
              child: addText('(${controller.vendorName.value})', getHeadingTextFontSIze(), Colors.white, FontWeight.normal),
            ),
            SizedBox(
              height: 2.h,
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
                  ? buildProductLoader()
                  : buildGrids()),
            ))
          ],
        ),
      ),
    );
  }


  Widget buildGrids() {
    return controller.productList.isEmpty
        ? Center(
      child: addText('No Items found', getNormalTextFontSIze(),
          colorConstants.black, FontWeight.bold),
    )
        : GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // crossAxisSpacing: 20,
          // mainAxisSpacing: 20,
          mainAxisExtent: 27.h),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          // Get.toNamed(Routes.ProductDetail, arguments: {
          //   'title': controller.productList[index].name,
          //   'productId': controller.productList[index].id.toString()
          // });


          Get.back();
          // Get.find<ProductDetailController>().title = controller.productList[index].name;
          Get.find<ProductDetailController>().getProductDetails(controller.productList[index].id.toString());


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
                CachedNetworkImage(
                  imageUrl: controller.productList[index].productImages[0].name
                      .toString(),
                  fit: BoxFit.cover,
                  height: 15.h,
                  alignment: Alignment.bottomCenter,
                  errorWidget: (context, url, error) =>
                      Image.network('https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg'),
                ),
                /*Image.network(
                  controller.productList[index].productImages[0].name
                      .toString(),
                  fit: BoxFit.cover,
                  height: 16.h,
                  width: double.infinity,
                ),*/
                if (controller.productList[index].quantity == 0)
                  Align(
                    heightFactor: 5,
                    alignment: Alignment.bottomCenter,
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
                  getValue(SharedPref.currency).length == 1
                      ? addText(
                      '${getValue(SharedPref.currency)}${controller.productList[index].price}',
                      getSmallTextFontSIze() - 1,
                      colorConstants.black,
                      FontWeight.w800)
                      : addText(
                      '${controller.productList[index].price} ${getValue(SharedPref.currency)}',
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


}



