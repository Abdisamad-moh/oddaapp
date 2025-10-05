import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/address_controller.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:super_banners/super_banners.dart';


import '../../../common/bottom_navigation.dart';
import '../../../common/header.dart';
import '../../../common/utils.dart';

class AddressView extends GetView<AddressController>{
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Get.toNamed(Routes.AddAddress);
            },
            child: getSolidButton(90.w, 'Add New Address'),
          ),
          const SizedBox(height: 10,),
          const AppBottomNavigation()
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppHeader(title: 'Addresses'),
            ),
            SizedBox(height: 4.h,),
            Expanded(child: Obx(() => controller.isLoading.value ? buildLoader() : ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.addressList.length,
              itemBuilder: (context, index) {
                return Obx(() =>  GestureDetector(
                    onTap: () {
                      controller.addressSelectedPos.value = index;
                      controller.setDefaultAddress(controller.addressList[index].id.toString(), false);
                    },

                    child:Container(
                      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      decoration: BoxDecoration(
                        color: colorConstants.white,
                        border: controller.addressSelectedPos.value == index ? Border.all(color: colorConstants.primaryColor2,width: 2): null,
                        borderRadius: getCurvedBorderRadius(),
                        boxShadow: [getDeepBoxShadow()],
                      ), child:
                    Obx(() => Stack(
                      children: [

                        if( controller.addressSelectedPos.value == index)
                          Positioned(
                            right:0,
                            child:CornerBanner(
                              bannerPosition: CornerBannerPosition.topRight,
                              bannerColor: colorConstants.primaryColor2,
                              child: addText('   Default   ', getSmallTextFontSIze(), colorConstants.white, FontWeight.bold),
                            ), ),



                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              SizedBox(
                                width:60.w,
                                child: Column(
                                  crossAxisAlignment : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorConstants.whiteShade
                                          ),child: SvgPicture.asset('assets/images/home_icon.svg'),
                                        ),
                                        const SizedBox(width: 10,),
                                        SizedBox(
                                          width: 40.w,
                                          child: addText(controller.addressList[index].addressType.toString(), getSubheadingTextFontSIze(),
                                              controller.addressSelectedPos.value == index ? colorConstants.primaryColor2 : colorConstants.black, FontWeight.bold),
                                        )

                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    addText('${controller.addressList[index].address.toString()} ${controller.addressList[index].city.toString()} '
                                        '${controller.addressList[index].pincode.toString()}', getSmallTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
                                    const SizedBox(height: 5,),

                                    Row(
                                      children: [
                                        // addText(controller.addressList[index].mobileNo.toString(),
                                        //     getNormalTextFontSIze(), colorConstants.black, FontWeight.bold),
                                        // const SizedBox(width: 20,),


                                         if( controller.addressSelectedPos.value != index)
                                        GestureDetector(
                                          onTap: (){
                                            showConfirmationPopup(context, index);
                                          }, child: SvgPicture.asset('assets/images/ic_del.svg'),
                                        )
                                      ],
                                    )

                                  ],
                                ),
                              ),


                              Image.asset('assets/images/ic_map.png',width: 15.w,)



                            ],
                          ),
                        )
                      ],
                    )),
                    )






















                ));
              },
            )))
          ],
        ),
      ),
    );
  }


  void showConfirmationPopup(BuildContext context,int index) {
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
                      "Are you sure you want to delete this address?",
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
                        },
                        child: getSolidButton(30.w, "Cancel"),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          controller.deleteAddress(controller.addressList[index].id.toString(), index);
                          },
                        child: addText("Delete", getNormalTextFontSIze(), Colors.red, FontWeight.bold),)
                    ],
                  )
                ],
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
        ));
  }

}