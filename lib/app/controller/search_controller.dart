import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/debouncer.dart';
import '../model/product_list_data.dart';
import '../repository/search_repository.dart';

class SearchController extends GetxController{

  late TextEditingController searchTextController;
  late SearchRepository searchRepository;
  final isProductLoading = false.obs;
  final productList = <ProductDatum>[].obs;

  late TextEditingController locationController;
  final isBlur = true.obs;
  late Timer _debounce;
  final int _debouncetime = 1000;
  List<bool> showQty=<bool>[].obs;

  final debouncer = Debouncer(milliseconds: 1000);

  SearchController() {
    searchRepository = SearchRepository();
    searchTextController = TextEditingController();
    locationController = TextEditingController();
  }

  void _onSearchChanged() {
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      if (searchTextController.text != "") {
        getProductList(searchTextController.text.trim().toString());
      } else {
        productList.clear();
      }
    });
  }

  void getProductList(String keyword) async {
    // try {
      isProductLoading.value = true;
      showQty.clear();
      ProductListData productListData = await searchRepository.getSearchedItems(keyword);
      productList.assignAll(productListData.data.data);
      for(int i=0;i<productList.length;i++){
        showQty.add(false);
      }

      isProductLoading.value = false;
    // }
    // catch (e) {
    //   isProductLoading.value = false;
    //   if (e is DioError) {
    //     // Get.snackbar('', e.response!.data['msg']);
    //     Get.snackbar('', e.response!.data.toString());
    //   } else {
    //     Get.snackbar('', e.toString());
    //   }
    // }
  }

  void showHide(int i){
      showQty[i]=!showQty[i];
  }


}