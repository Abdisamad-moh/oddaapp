import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:odda/app/repository/product_repository.dart';

import '../model/product_list_data.dart';

class VendorProductsController extends GetxController{

  ProductRepository? _productRepository;
  final isProductLoading = false.obs;
  final productList = <ProductDatum>[].obs;
  final vendorName = ''.obs;

  VendorProductsController(){
    _productRepository = ProductRepository();
  }

  @override
  void onInit(){
    super.onInit();
    var vendorId = Get.arguments['vendorId'] as String;
    vendorName.value = Get.arguments['vendorName'] as String;
    getSellerProducts(vendorId);
  }

  void getSellerProducts(String vendorId) async {
    Get.log('Vendor Id : $vendorId');
    try {
      isProductLoading.value = true;
      ProductListData productListData = await _productRepository!.getSellerProducts(vendorId);
      productList.assignAll(productListData.data.data);
      isProductLoading.value = false;
    } catch (e) {
      isProductLoading.value = false;
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
        Get.log(e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
        Get.log(e.toString());
      }
    }
  }
}