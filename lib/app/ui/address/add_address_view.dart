import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/address_controller.dart';

import 'package:flutter/material.dart';
import 'package:odda/common/color_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../common/header.dart';
import '../../../common/utils.dart';

class AddAddressView extends GetView<AddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {

    controller.getCurrentAddress();

    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppHeader(title: 'New Address'),
            ),
            SizedBox(
              height: 4.h,
            ),
            Expanded(
                child: Obx(() => controller.isFetchingAddress.value ? Container(
                  margin: EdgeInsets.only(top: 40.h),
                  child: Column(
                  children: [
                    getLoader(),
                    const SizedBox(height: 5,),
                    addText('Fetchng Address', getNormalTextFontSIze(), colorConstants.black, FontWeight.normal)
                  ],
                ),) : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    addEditText(controller.cityController, "Address"),
                    // SizedBox(height: 2.h),
                    // addEditText(controller.stateController, "State"),
                    SizedBox(height: 2.h),
                    addEditText(controller.addressTypeController, "Address type: E.g. Home, Office"),
                   /* SizedBox(height: 2.h),
                    addNumberEditText(controller.pinController, 'Pin code'),*/
                    SizedBox(height: 2.h),
                    addText('Additional information', getSubheadingTextFontSIze(), colorConstants.black, FontWeight.bold),
                    // SizedBox(height: 2.h),
                    // Image.asset('assets/images/map_view.png',width: 90.w,),
                    // SizedBox(height: 2.h),
                    // addNumberEditText(controller.numberController, 'Additional contact number',inputFormatter: [FilteringTextInputFormatter.digitsOnly]),
                    SizedBox(height: 2.h),
                    Container(
                      height: 20.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                          color: colorConstants.white,
                          // boxShadow: [getDeepBoxShadow()],
                          border: Border.all(color: colorConstants.lightGrey),
                          borderRadius: getCurvedBorderRadius()),
                      child: TextFormField(
                        // inputFormatters: [CapitalCaseTextFormatter()],
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        controller: controller.informationController,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(fontSize: getNormalTextFontSIze()),
                        decoration: InputDecoration(
                            hintText: 'Additional information : E.g. house no',
                            hintStyle: TextStyle(
                                fontSize: getNormalTextFontSIze(),
                                color: colorConstants.greyTextColor),
                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Obx(() => controller.isLoading.value ? SizedBox(width: 30,height: 30, child: Center(child: getLoader()),) : GestureDetector(
                      onTap: (){
                          /*if(controller.pinController.text.isEmpty) {
                            showSnackbar(context, 'Please enter pin');
                          } else*/
                          if(controller.cityController.text.isEmpty) {
                            showSnackbar(context, 'Please enter city');
                          }
                          // else if (controller.stateController.text.isEmpty) {
                          //   showSnackbar(context, 'Please enter state');
                          // }
                          else if (controller.addressTypeController.text.isEmpty) {
                            showSnackbar(context, 'Please enter address type');
                          }/* else if(controller.numberController.text.isEmpty) {
                              showSnackbar(context, 'Please enter mobile number');
                          }*//* else if(controller.informationController.text.isEmpty) {
                            showSnackbar(context, 'Please enter additional information');
                          }*/ else {
                            if (kDebugMode) {
                              print('Address Type ${controller.addressTypeController.text}');
                            }
                            controller.addAddress(context);
                          }
                        },
                      child: getSolidButton(90.w, 'Save'),
                    )),
                    SizedBox(height: 2.h),

                  ],
                ))

                )
          ],
        ),
      ),
    );
  }


  // Widget buildCityDropDown(){
  //   return  DropdownButtonHideUnderline(
  //     child: Obx(() => DropdownButton2(
  //       buttonPadding: EdgeInsets.symmetric(horizontal: 20),
  //       hint: Text(
  //         'City',
  //         style: TextStyle(
  //             fontSize: getNormalTextFontSIze(),
  //             color: colorConstants.black
  //         ),
  //       ),
  //       items: controller.cityItems
  //           .map((item) =>
  //           DropdownMenuItem<String>(
  //             value: item,
  //             child: Text(
  //               item,
  //               style:  TextStyle(
  //                 fontSize: getNormalTextFontSIze(),
  //               ),
  //             ),
  //           ))
  //           .toList(),
  //       value: controller.selectedCity.value.isNotEmpty ? controller.selectedCity.value : null,
  //       onChanged: (value) {
  //         controller.selectedCity.value = value as String;
  //       },
  //       buttonDecoration: BoxDecoration(
  //           border: Border.all(color: colorConstants.lightGrey),
  //           borderRadius: getBorderRadiusCircular()
  //       ),
  //       iconSize: 10,
  //       icon: SvgPicture.asset('assets/images/down_arrow.svg'),
  //       buttonWidth: 100.w,
  //       dropdownElevation: 1,
  //       dropdownDecoration: BoxDecoration(
  //         color: colorConstants.white,
  //         boxShadow: [getDeepBoxShadow()],
  //       ),
  //     )),
  //   );
  // }
  //
  // Widget buildStateDropDown(){
  //   return  DropdownButtonHideUnderline(
  //     child: Obx(() => DropdownButton2(
  //       buttonPadding: EdgeInsets.symmetric(horizontal: 20),
  //       hint: Text(
  //         'State',
  //         style: TextStyle(
  //             fontSize: getNormalTextFontSIze(),
  //             color: colorConstants.black
  //         ),
  //       ),
  //       items: controller.stateItems
  //           .map((item) =>
  //           DropdownMenuItem<String>(
  //             value: item,
  //             child: Text(
  //               item,
  //               style:  TextStyle(
  //                 fontSize: getNormalTextFontSIze(),
  //               ),
  //             ),
  //           ))
  //           .toList(),
  //       value: controller.selectedState.value.isNotEmpty ? controller.selectedState.value : null,
  //       onChanged: (value) {
  //         controller.selectedState.value = value as String;
  //       },
  //       buttonDecoration: BoxDecoration(
  //           border: Border.all(color: colorConstants.lightGrey),
  //           borderRadius: getBorderRadiusCircular()
  //       ),
  //       iconSize: 10,
  //       icon: SvgPicture.asset('assets/images/down_arrow.svg'),
  //       buttonWidth: 100.w,
  //       dropdownElevation: 1,
  //       dropdownDecoration: BoxDecoration(
  //         color: colorConstants.white,
  //         boxShadow: [getDeepBoxShadow()],
  //       ),
  //     )),
  //   );
  // }

}
