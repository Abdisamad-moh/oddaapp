import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odda/app/model/banner_data.dart';
import 'package:odda/common/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common/preferences.dart';
import '../model/CategoriesData.dart';
import '../model/normal_response.dart';
import '../model/product_list_data.dart';
import '../repository/home_repository.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController{

  final GlobalKey<ScaffoldState> key = GlobalKey();
  final categorySelectedPos = 0.obs;
  final listSize = 15.obs;

  // late CarouselController buttonCarouselController;
  late CarouselSliderController buttonCarouselController;
  final selectedIndex = 0.obs;

  final isLoading = false.obs;
  final isBannerLoading = false.obs;
  final isProductLoading = true.obs;
  final categoriesList = <CategoriesDatum>[].obs;
  final productList = <ProductDatum>[].obs;
  final bannerList = <BannerDatum>[].obs;
  late HomeRepository homeRepository;
  var currentPage = 1;
  ScrollController scrollController = ScrollController();
  final isLoadMore = false.obs;
  final currentAddress= ''.obs;
  final isLocationLoading = false.obs;
  final userImage = ''.obs;
  String currentLat = '';
  String currentLng = '';
  final isNewNotification = false.obs;

  HomeController(){
    homeRepository = HomeRepository();
    // buttonCarouselController = CarouselController();
    buttonCarouselController = CarouselSliderController();
  }

  @override
  void onInit(){
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        if (!isLoadMore.value) {
          isLoadMore.value = !isLoadMore.value;
          // Perform event when user reach at the end of list (e.g. do Api call)
          if (kDebugMode) {
            print('=====================> Bottom Reached');
          }
          currentPage+=1;
          getLoadMore('10000');
        }
      }
    });

    //getCategories();
    getBanners();
    if (kDebugMode) {
      print('User ID : ${getValue(SharedPref.userId).toString()}');
      print('Auth Token : ${getValue(SharedPref.authToken).toString()}');
    }
    if (kDebugMode) {
      print('Location : ${getValue(SharedPref.address).toString()}');
    }
    userImage.value = getValue(SharedPref.userImage);
    currentAddress.value = getValue(SharedPref.address).toString();
    if(currentAddress.value == 'null') getCurrentAddress();
  }

  void getCurrentAddress() async {
    managePermissions();
  }

  void managePermissions() async{
    if (await Permission.location.request().isGranted) {
      isLocationLoading.value = true;
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLat = position.latitude.toString();
      currentLng = position.longitude.toString();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (kDebugMode) {
        print(placemarks[0].locality);
      }
      Placemark placemark = placemarks[0];
      currentAddress.value = '${placemark.street}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';
      storeValue(SharedPref.address, currentAddress.value);
      storeValue(SharedPref.lat, position.latitude.toString());
      storeValue(SharedPref.lng, position.longitude.toString());
      if(GetStorage().hasData(SharedPref.authToken)) {
        updateAddress(currentAddress.value, placemark.administrativeArea.toString(), position.latitude.toString(), position.longitude.toString());
      }
      isLocationLoading.value = false;
    } else if (await Permission.location.request().isPermanentlyDenied && GetPlatform.isAndroid) {
      openAppSettings();
    } else {
      openAppSettings();
      // Get.snackbar('Permissions Required', 'Please allow location permissions.');
    }
  }

  void updateAddress(String address,String city,String lat,String lng) async {
    try {
      NormalResponse normalResponse = await homeRepository.updateAddress(address, city, lat, lng);
    } catch (e) {
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }

  void deleteAccount() async {
    try {
      NormalResponse normalResponse = await homeRepository.deleteAccount();
      GetStorage().remove(SharedPref.isLogin);
      GetStorage().remove(SharedPref.authToken);
      GetStorage().remove(SharedPref.address);
      Get.offAllNamed(Routes.Login);
    } catch (e) {
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }

  void onPageChanged(int index){
    selectedIndex.value = index;
  }

  void getBanners() async {
    try {
      isBannerLoading.value = true;
      BannerData bannerData = await homeRepository.getBanners();
      // if(bannerData.hasNewNotification){
      //   isNewNotification.value = true;
      // }
      print('Banner Data ayaa xigta');
      print(bannerData.toJson());
      bannerList.assignAll(bannerData.data);
      isBannerLoading.value = false;
      getProductList("10000");
    } catch (e) {
      isBannerLoading.value = false;
      if (e is DioException) {
        print(e.error);
        print(e.message);
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }

  void getCategories() async {
    try {
      isLoading.value = true;
      CategoriesData categoriesData = await homeRepository.getCategories();
      categoriesList.assignAll(categoriesData.data);
      getProductList(categoriesData.data[0].id.toString());
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }

  void getProductList(String categoryId) async {
    try {
      isProductLoading.value = true;
      // ProductListData productListData = await homeRepository.getProductList( '10000', 'latest',currentPage);
      ProductListData productListData = await homeRepository.getProductList( '10000', 'all',currentPage);
      productList.assignAll(productListData.data.data);
      isProductLoading.value = false;
    } catch (e) {
      isProductLoading.value = false;
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg'].toString());
      } else {
        Get.snackbar('', e.toString());
      }
    }
  }

  void getLoadMore(String categoryId) async {
    try {
      isLoadMore.value = true;
      ProductListData productListData = await homeRepository.getProductList(
          // categoryId, 'none', currentPage);
          categoryId, 'all', currentPage);
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