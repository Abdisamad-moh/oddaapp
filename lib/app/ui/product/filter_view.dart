import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:odda/common/color_constants.dart';
import 'package:intl/intl.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../common/preferences.dart';
import '../../../common/utils.dart';
import '../../controller/product_controller.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  var controller = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Container(
                width: 30.w,
                height: 5,
                decoration: BoxDecoration(
                    color: colorConstants.lightGrey,
                    borderRadius: getBorderRadiusCircular()),
              ),
              const SizedBox(
                height: 20,
              ),
              addText('Filter', getHeadingTextFontSIze(), colorConstants.black,
                  FontWeight.bold),
              Divider(
                height: 5.h,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDropDown(),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      width: 100.w,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: getBorderRadiusCircular(),
                          border: Border.all(color: colorConstants.lightGrey)),
                      child: addText('Select Location', getNormalTextFontSIze(),
                          colorConstants.black, FontWeight.normal),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    addText('Price Range', getNormalTextFontSIze(),
                        colorConstants.black, FontWeight.bold),
                    Obx(
                      () => SfSlider(
                        min: 0.0,
                        max: 20000.0,
                        value: controller.priceValue.value,
                        interval: 5000,
                        showTicks: true,
                        showLabels: true,
                        numberFormat: NumberFormat(getValue(SharedPref.currency)),
                        enableTooltip: true,
                        tooltipShape: const SfPaddleTooltipShape(),
                        stepSize: 5,
                        minorTicksPerInterval: 1,
                        activeColor: colorConstants.primaryColor2,
                        inactiveColor: colorConstants.lightGrey,
                        onChanged: (dynamic value) {
                          controller.priceValue.value = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    addText('Sort by', getNormalTextFontSIze(),
                        colorConstants.black, FontWeight.bold),
                    buildSortBy(),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.getFilteredItems(
                            controller.categoryId ?? controller.originalCatId,
                            controller.itemType,
                            controller.sortList[controller.sortSelectedPos.value],
                            controller.priceValue.value.toString(),
                            controller.locationController.text.trim());
                      },
                      child: getSolidButton(100.w, 'Apply Filter'),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                          controller.title.value = controller.originalTitle;
                          controller.categoryId = controller.originalCatId;
                          controller.getProductList(controller.categoryId, controller.itemType);
                        },
                        child: addText('CLEAR', getNormalTextFontSIze(),
                            colorConstants.black, FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

Widget buildDropDown() {
  return Container(
    width: 100.w,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      border: Border.all(color: colorConstants.lightGrey),
      borderRadius: getBorderRadiusCircular(),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(
          'Select Category',
          style: TextStyle(
            fontSize: getNormalTextFontSIze(), 
            color: colorConstants.black
          ),
        ),
        items: controller.categoryItems
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: getNormalTextFontSIze(),
                    ),
                  ),
                ))
            .toList(),
        value: controller.selectedCategory,
        onChanged: (value) {
          setState(() {
            controller.selectedCategory = value as String;
            for (int i = 0; i < controller.categortList.length; i++) {
              if (controller.selectedCategory == controller.categortList[i].name) {
                controller.categoryId = controller.categortList[i].id.toString();
              }
            }
          });
        },
      ),
    ),
  );
}

  Widget buildSortBy() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          setState(() {
            controller.sortSelectedPos.value = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: getBorderRadius(),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  if (controller.sortSelectedPos.value != index)
                    Container(
                      width: 30,
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFB7B7B7)),
                          shape: BoxShape.circle),
                    ),
                  if (controller.sortSelectedPos.value == index)
                    SvgPicture.asset('assets/images/radio_icon.svg',
                        width: 30, height: 30)
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              addText(controller.sortList[index], getNormalTextFontSIze() - 1,
                  colorConstants.black, FontWeight.bold)
            ],
          ),
        ),
      ),
      itemCount: 3,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 5.h),
    );
  }
}