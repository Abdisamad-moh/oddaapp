import 'package:get/get.dart';

import '../model/normal_response.dart';
import '../model/order_data.dart';
import '../model/order_detail_model.dart';
import '../provider/api_provider.dart';

class OrderRepository{

  late ApiProvider _apiProvider;

  OrderRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }


  Future<OrderData> getOrderData(String status) async {
    return _apiProvider.getOrderData(status);
  }

  Future<NormalResponse> addReview(String productID,String rating,String review,bool isVendor) async {
    return _apiProvider.addReview(productID, rating, review, isVendor);
  }

  Future<NormalResponse> cancelOrder(String orderId) async {
    return _apiProvider.cancelOrder(orderId);
  }

  Future<OrderDetailModel> getOrderDetails(String orderItemId) async {
    return _apiProvider.getOrderDetails(orderItemId);
  }



}