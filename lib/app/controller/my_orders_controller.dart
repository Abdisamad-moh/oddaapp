import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/model/order_data.dart';
import 'package:order_tracker/order_tracker.dart';

import '../../common/utils.dart';
import '../model/normal_response.dart';
import '../model/order_detail_model.dart';
import '../repository/order_repository.dart';

class MyOrdersController extends GetxController{

  final categorySelectedPos= 0.obs;
  final listSize= 3.obs;
  final categoryList = [
    'Confirmed',
    'Delivered',
    'Cancelled',
  ].obs;
  final isLoading = false.obs;
  late OrderRepository orderRepository;
  final orderList = <OrderDatum>[].obs;
  late TextEditingController reviewtextController;
  var productRating = '5';
  final isDetailsLoading = false.obs;

  List<TextDto> orderListt = [
    TextDto("Your order has been placed",null),
  ];

  List<TextDto> shippedList = [
    TextDto("Your order has been shipped", ''),
  ];

  List<TextDto> outOfDeliveryList = [
    TextDto("Your order is out for delivery", null),
  ];

  List<TextDto> deliveredList = [
    TextDto("Your order has been delivered", null),
  ];

  int selectedIndex = 0;

  OrderDetailData? orderDetailData;

  final orderStatusStaticList = <OrderItemStatus>[
    OrderItemStatus(updatedAt: null,deliveryStatus: 'Confirmed'),
    // OrderItemStatus(updatedAt: null,deliveryStatus: 'Ready to Ship'),
    // OrderItemStatus(updatedAt: null,deliveryStatus: 'Shipped'),
    OrderItemStatus(updatedAt: null,deliveryStatus: 'Delivered'),
    // OrderItemStatus(updatedAt: null,deliveryStatus: 'Cancelled'),
  ];


  final orderStatusImages = <String>[
  'assets/images/ic_confirmed.png',
  'assets/images/ic_readytoshipped.png',
  // 'assets/images/ic_shipped.png',
  // 'assets/images/ic_ontheway.png',
  // 'assets/images/ic_delivered.png',
  ];

  MyOrdersController() {
    orderRepository = OrderRepository();
    reviewtextController = TextEditingController();
  }

  @override
  void onInit(){
    super.onInit();
    getOrders('');
  }

  void getOrders(String status) async {
    try {
      isLoading.value = true;
      OrderData orderData = await orderRepository.getOrderData(status);

      orderList.assignAll(orderData.data);
      isLoading.value = false;
    } 
    catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        Get.log("getOrderDioError:${e.response!.data['msg']}");
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.log("getOrderError:${e.toString()}");
        Get.snackbar('', e.toString());
      }
    }
  }


  void addReview(String productID, String rating, String review, bool isVendor,
      BuildContext context) async {
    try {
      NormalResponse normalResponse = await orderRepository.addReview(productID, rating, review, isVendor);
      Get.back();
    } catch (e) {
      if (e is DioException) {
        showSnackbar(context, e.response!.data['msg']);
      } else {
        showSnackbar(context, e.toString());
      }
    }
  }

  void cancelOrder(String orderId,BuildContext context,int index) async {
    try {
      NormalResponse normalResponse = await orderRepository.cancelOrder(orderId);
      showSnackbar(context, normalResponse.msg);
      orderList.removeAt(index);
      orderList.refresh();
    } catch (e) {
      if (e is DioException) {
        showSnackbar(context, e.response!.data['msg']);
      } else {
        showSnackbar(context, e.toString());
      }
    }
  }

  void getOrderDetails(BuildContext context) async {
    try {
      isDetailsLoading.value = true;
      orderStatusStaticList.clear();
      orderStatusStaticList.addAll(<OrderItemStatus>[
        OrderItemStatus(updatedAt: null,deliveryStatus: 'Confirmed'),
        // OrderItemStatus(updatedAt: null,deliveryStatus: 'Ready to Ship'),
        // OrderItemStatus(updatedAt: null,deliveryStatus: 'Shipped'),
        OrderItemStatus(updatedAt: null,deliveryStatus: 'Delivered'),
        // OrderItemStatus(updatedAt: null,deliveryStatus: 'Cancelled'),
      ]);
      OrderDetailModel orderDetailModel = await orderRepository.getOrderDetails(orderList[selectedIndex].id.toString());
      orderDetailData = orderDetailModel.data;
      orderStatusStaticList.replaceRange(0, orderDetailModel.data.orderItemStatuses.length, orderDetailModel.data.orderItemStatuses);
      isDetailsLoading.value = false;
    } catch (e) {
      isDetailsLoading.value = false;
      if (e is DioException) {
        Get.log(e.response!.toString());
        showSnackbar(context, e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }
}