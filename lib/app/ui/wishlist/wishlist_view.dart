import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/bottom_navigation.dart';
import '../../../common/header.dart';
import '../../../common/preferences.dart';
import '../../controller/wishlist_controller.dart';
import '../../routes/app_routes.dart';

class WishlistView extends GetView<WishlistController>{
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {

    // controller.getWishListItems();

    return Scaffold(
      backgroundColor: colorConstants.white,
            bottomNavigationBar: const SafeArea(
        child: AppBottomNavigation(),
      ),
      body: RefreshIndicator(
          onRefresh: ()async{
           controller.getWishListItems();
          },
          child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppHeader(title: 'Wishlist'),
            ),
            SizedBox(height: 4.h,),
            Expanded(child: Obx(() => controller.isLoading.value ? buildLoader() :
            controller.wishList.isEmpty ? Center(
                child: addText('Nothing in your wishlist', getNormalTextFontSIze(), colorConstants.black, FontWeight.w600))
                :buildGrids()
            ))
          ],
        ),
      )),
    );
  }




  Widget buildGrids(){
    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // crossAxisSpacing: 20,
          // mainAxisSpacing: 20,
          mainAxisExtent: 27.h
      ),
      itemBuilder: (context, index) => GestureDetector(
        onTap: (){
          Get.toNamed(Routes.ProductDetail, arguments: {
            'title': controller.wishList[index].product.name.toString(),
            'productId': controller.wishList[index].product.id.toString()
          });
        },
        child: buildItem(index),
      ),
      itemCount:controller.wishList.length,
    );
  }


  Widget buildItem(int index){
    return Stack(
      children: [
        Container(
          margin: index.isOdd ? const EdgeInsets.only(right: 20,left: 10,bottom: 20) : const EdgeInsets.only(left: 20,right: 10,bottom: 20),
          decoration: BoxDecoration(
              boxShadow: [getDeepBoxShadow()],
              color: colorConstants.white,
              borderRadius: getCurvedBorderRadius()
          ),child: ClipRRect(
          borderRadius: getCurvedBorderRadius(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    controller.wishList[index].product.productImages[0].name.toString(),
                    fit: BoxFit.cover,
                    height: 16.h,
                    width: double.infinity,
                  ),
                  // if(index%3 ==0)
                  //   Align(
                  //     heightFactor:5 ,
                  //     alignment: Alignment.bottomCenter,
                  //     child: buildSoldOutIcon(),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: addText(controller.wishList[index].product.name.toString(), getSmallTextFontSIze(), colorConstants.black, FontWeight.normal),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                      getValue(SharedPref.currency).length == 1
                          ? addText(
                              '${getValue(SharedPref.currency)}${controller.wishList[index].product.price.toString()}',
                              getSmallTextFontSIze() - 1,
                              colorConstants.black,
                              FontWeight.w800)
                          : addText(
                              '${controller.wishList[index].product.price.toString()} ${getValue(SharedPref.currency)}',
                              getSmallTextFontSIze() - 1,
                              colorConstants.black,
                              FontWeight.w800),
                    //   verticalDivider(),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Icon(Icons.star,color: colorConstants.buttonColor,size: getHeadingTextFontSIze(),),
                    //     addText(controller.wishList[index].product.rating.toString(), getSmallTextFontSIze(), colorConstants.black, FontWeight.w800),
                    //   ],
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
        ),
        Positioned(
            top: 10,
            right: index.isOdd ? 30:20,
            child:  SvgPicture.asset('assets/images/ic_favourite.svg',width: getLargeTextFontSIze(),))
      ],
    );
  }

  Widget buildSoldOutIcon(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
      decoration: BoxDecoration(
          color: colorConstants.black.withOpacity(0.3),
          borderRadius: getBorderRadiusCircular()
      ),child: addText('SOLD OUT', 10, colorConstants.white, FontWeight.normal),
    );
  }
}