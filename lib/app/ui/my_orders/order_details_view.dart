import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odda/app/controller/my_orders_controller.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/header.dart';
import '../../../common/timeline_view.dart';

class OrderDetailView extends GetView<MyOrdersController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppHeader(title: 'Order Details'),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.network(controller.orderList[controller.selectedIndex].product.productImages[0].name,height: 25.h,),
              addText(controller.orderList[controller.selectedIndex].product.name, getHeadingTextFontSIze(), colorConstants.black, FontWeight.bold),
              addText('Order Id: ${controller.orderList[controller.selectedIndex].orderId}', getSubheadingTextFontSIze(), colorConstants.black, FontWeight.normal),

              const SizedBox(
                height: 20,
              ),

              addUnderlineText('Shipping Details', getHeadingTextFontSIze(), colorConstants.black, FontWeight.bold),

              // Obx(() => controller.isDetailsLoading.value ? const Center(child: CircularProgressIndicator(),) : Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: OrderTracker(
              //     status: Status.shipped,
              //     activeColor: colorConstants.primaryColor,
              //     inActiveColor: Colors.grey[300],
              //     headingDateTextStyle: const TextStyle(color: Colors.white),
              //     orderTitleAndDateList: controller.orderListt,
              //     shippedTitleAndDateList: controller.shippedList,
              //     outOfDeliveryTitleAndDateList: controller.outOfDeliveryList,
              //     deliveredTitleAndDateList: controller.deliveredList,
              //   ),
              // )),


              Obx(() => controller.isDetailsLoading.value ? Container(
                height: 50.h,
                margin: const EdgeInsets.only(top: 20),
                child: buildLoader(),
              ) : controller.orderDetailData == null ? Container() : Padding(
                padding: const EdgeInsets.all(20),
                child: Timeline(
                  indicators: List.generate(controller.orderStatusImages.length, (index) => controller.orderStatusStaticList[index].updatedAt == null ?
                  Image.asset(controller.orderStatusImages[index]) : const Icon(Icons.verified,color: Colors.green,)),
                    // [
                    //   Image.asset('assets/images/ic_confirmed.png'),
                    //   Image.asset('assets/images/ic_readytoshipped.png'),
                    //   Image.asset('assets/images/ic_shipped.png'),
                    //   Image.asset('assets/images/ic_ontheway.png'),
                    //   Image.asset('assets/images/ic_delivered.png'),
                    // ],

                  children: List.generate(
                    controller.orderStatusStaticList.length,
                        (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          addText(' ${controller.orderStatusStaticList[index].deliveryStatus}', getSubheadingTextFontSIze(), colorConstants.black, FontWeight.bold),
                          addText( controller.orderStatusStaticList[index].updatedAt == null ? ' Pending' :
                          ' ${DateFormat('dd-mm-yyyy').format(controller.orderStatusStaticList[index].updatedAt!)}', getNormalTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
                          SizedBox(height: 2.h,)
                        ],
                      );
                    },
                  )
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
  Widget timelineRow(String title, String subTile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Text(""),
              ),
              Container(
                width: 3,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.rectangle,
                ),
                child: const Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addText(title, getSubheadingTextFontSIze(), colorConstants.black, FontWeight.bold),
              addText(subTile, getNormalTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
            ],
          ),
        ),
      ],
    );
  }
  Widget timelineLastRow(String title, String subTile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Text(""),
              ),
              Container(
                width: 3,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.rectangle,
                ),
                child: const Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              addText(title, getSubheadingTextFontSIze(), colorConstants.black, FontWeight.bold),
              addText(subTile, getNormalTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
            ],
          ),
        ),
      ],
    );
  }
}

