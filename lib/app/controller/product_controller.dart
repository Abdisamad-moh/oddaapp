import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/CategoriesData.dart';
import '../model/product_list_data.dart';
import '../repository/product_repository.dart';
import 'home_controller.dart';

class ProductController extends GetxController {
  var title = 'Products'.obs;
  var originalTitle = '';
  var originalCatId = '';
  var categoryId = '';
  var itemType = '';
  final List<String> categoryItems = [];
  String? selectedCategory;
  final priceValue = 1000.0.obs;
  final sortSelectedPos = 0.obs;
  // final List<String> sortList = ['Popularity', 'Rating', 'Price', 'Relevancy'];
  final List<String> sortList = ['Popularity',  'Price', 'Relevancy'];
  late ProductRepository productRepository;
  final isProductLoading = true.obs;
  final productList = <ProductDatum>[].obs;
  final categortList = <CategoriesDatum>[].obs;
  late TextEditingController locationController;

  var currentPage = 1;
  ScrollController scrollController = ScrollController();
  final isLoadMore = false.obs;
  final isBanner = false.obs;
  final bannerId = ''.obs;
  final isBannerproduct = false.obs;

  ProductController() {
    productRepository = ProductRepository();
    locationController = TextEditingController(text: '');
    categortList.value = Get.find<HomeController>().categoriesList;
    for (int i = 0; i < categortList.length; i++) {
      categoryItems.add(categortList[i].name);
    }
  }

  @override
  void onInit() {
    super.onInit();
    print("sdfasdf");
    title.value = Get.arguments['title'] as String;
    originalTitle = Get.arguments['title'] as String;
    categoryId = Get.arguments['categoryId'] as String;
    originalCatId = Get.arguments['categoryId'] as String;
    itemType = Get.arguments['itemType'] as String;
    isBanner.value = Get.arguments['isBanner'] as bool;
    bannerId.value = Get.arguments['bannerId'] as String;
    isBannerproduct.value = Get.arguments['isBannerproduct'] as bool;
    print("sdfasdf");
    if(!isBanner.value){
      print("sdfasdf");
      getProductList(categoryId, itemType);

      scrollController.addListener(() {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
          if (!isLoadMore.value) {
            isLoadMore.value = !isLoadMore.value;
            // Perform event when user reach at the end of list (e.g. do Api call)
            if (kDebugMode) {
              print('=====================> Bottom Reached');
            }
            currentPage+=1;
            // getLoadMore(categoriesList[categorySelectedPos.value].id.toString());
            getLoadMore(categoryId);
          }
        }
      });
    } else {
      getBannerProducts(bannerId.value,isBannerproduct.value);
    }
  }

  void getBannerProducts(String bannerId, bool value) async {
    try {
      isProductLoading.value = true;
      ProductListData productListData = await productRepository.getBannerList(bannerId,value);
      productList.assignAll(productListData.data.data);
      isProductLoading.value = false;
    } catch (e) {
      isProductLoading.value = false;
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }

  void getProductList(String categoryId, String itemType) async {
    try {
      isProductLoading.value = true;
      ProductListData productListData = await productRepository.getProductList(categoryId, itemType, currentPage);
      productList.assignAll(productListData.data.data);
      isProductLoading.value = false;
    } catch (e) {
      isProductLoading.value = false;
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }

  void getFilteredItems(String categoryId, String itemType, String sortBy,
      String priceRange, String location) async {
    try {
      isProductLoading.value = true;
      ProductListData productListData =
          await productRepository.getFilteredItems(
              categoryId, itemType, sortBy.toLowerCase(), priceRange, location);
      productList.assignAll(productListData.data.data);
      isProductLoading.value = false;
    } catch (e) {
      isProductLoading.value = false;
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }


  void getLoadMore(String categoryId) async {
    try {
      isLoadMore.value = true;
      ProductListData productListData = await productRepository.getProductList(categoryId,itemType,currentPage);
      productList.addAll(productListData.data.data);
      if (kDebugMode) {
        print('List Size is ${productListData.data.data.length}');
      }
      isLoadMore.value = false;
    } catch (e) {
      isLoadMore.value = false;
      if (e is DioException) {
        Get.snackbar("", e.response!.data['msg']);
      } else {
        Get.snackbar("", e.toString());
      }
    }
  }

}
