import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:odda/app/controller/category_controller.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/header.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryView extends GetView<CategoryController>{
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: AppHeader(title: 'Category'),
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(height: 2.h,),

            Expanded(child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.categoriesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.ProductView, arguments: {
                        'title': controller.categoriesList[index].name,
                        'categoryId': controller.categoriesList[index].id.toString(),
                        'itemType': 'none',
                        'bannerId': '',
                        'isBannerproduct': false,
                        'isBanner': false,
                        'ad_id': "",
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                            decoration: BoxDecoration(
                              color: colorConstants.white,
                              borderRadius: getCurvedBorderRadius(),
                              // boxShadow: [getDeepBoxShadow()]
                            ), child: Container(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 7.h,height: 7.h,
                                child: ClipRRect(
                                  borderRadius: getBorderRadius(),
                                  child: Image.network(controller.categoriesList[index].image,fit: BoxFit.cover,),
                                ),),
                              const SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width : 60.w,
                                      child: addText(controller.categoriesList[index].name, getSubheadingTextFontSIze(), colorConstants.primaryColor2, FontWeight.bold)),
                                  SizedBox(height: 0.5.h,),
                                  SizedBox(
                                      width: 60.w,
                                      child: addLengthText(controller.categoriesList[index].description.toString(), getSmallTextFontSIze(), colorConstants.greyTextColor, FontWeight.w600)),
                                  SizedBox(height: 0.5.h,),
                                ],
                              )

                            ],
                          ),
                        )
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(),
                        )
                      ],
                    )






















                );
              },
            ))

          ],
        ),
      ),
    );
  }

}