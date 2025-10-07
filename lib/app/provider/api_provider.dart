import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';
import 'package:odda/app/model/CategoriesData.dart';
import 'package:odda/app/model/admin_account_data.dart';
import 'package:odda/app/model/banner_data.dart';
import 'package:odda/app/model/cart_data.dart';
import 'package:odda/app/model/job_applicants_model.dart';
import 'package:odda/app/model/login_data.dart';
import 'package:odda/app/model/message_model.dart';
import 'package:odda/app/model/order_data.dart';
import 'package:odda/app/model/product_detail_data.dart';
import 'package:odda/app/model/profile_data.dart';
import 'package:odda/app/model/update_app_data.dart';
import 'package:odda/app/model/wishlist_data.dart';
import 'package:odda/common/utils.dart';

import '../../common/preferences.dart';
import '../model/add_address_data.dart';
import '../model/detail_review_data.dart';
import '../model/normal_response.dart';
import '../model/notification_data.dart';
import '../model/order_detail_model.dart';
import '../model/otp_data.dart';
import '../model/product_list_data.dart';
import '../services/auth_service.dart';

class ApiProvider extends GetxService {
  late dio.Dio _dio;

  // final _baseUrl = "https://v1.checkprojectstatus.com/odda/api/user/"; // local
    final _baseUrl = "https://www.oddaapp.com/appadmin/api/user/"; // live

  ApiProvider() {
    _dio = dio.Dio();
  }

  Future<ApiProvider> init() async {
    //init changes
    return this;
  }

  String getBaseURL(String endpoint) {
    return _baseUrl + endpoint;
  }

  dio.Options getOptions() {
    var token = getValue(SharedPref.authToken);
    var options = dio.Options(headers: {
      'Authorization': 'Bearer $token',
    });
    print('Bearer $token');
    return options;
  }

  Future<void> setDeviceVariables() async {
    // deviceType = getDeviceType();
    // await getDeviceId().then((value) {
    //   deviceId = value;
    //   storeValue(SharedPref.device_id, value.toString());
    // });
    // await getDeviceToken().then((value) {
    //   deviceToken = value;
    //   storeValue(SharedPref.device_token, value.toString());
    // });
  }

  Future<LoginData> sendOTP(String type, String name, String mobileNo, String licenseNo,String countryCode) async {
    Get.log("signupCountryCode:$countryCode");
    var formData = dio.FormData.fromMap({
      // 'type': type,
      'mobile_no': mobileNo,
      'name': name,
      'licence_no': licenseNo,
      'country_code':countryCode.toString()
    });
    Get.log("signupCountryCode:$countryCode");
    Get.log("sendOtp:${formData.toString()}");
    var response = await _dio.post(getBaseURL("send_otp"), data: formData);
    if (kDebugMode) {
      print("send_otp Sign up $formData");
      print("seeRespon${response.data}");
    }
    if (response.statusCode == 200) {
      return LoginData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<LoginData> loginAPI(String mobileNo,String countryCode) async {

    var formData = dio.FormData.fromMap({
      'mobile_no': mobileNo,
      "country_code":countryCode.toString()
    });
    Get.log("countryCodeSendFromApi:${countryCode.toString()}");
    var response = await _dio.post(getBaseURL("login_api"), data: formData);
    if (kDebugMode) {
      print("see+loginResponse comming here $formData");
      print("see+loginResponse${response.data}");
    }
    if (response.statusCode == 200) {
      return LoginData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<OtpData> verifyLoginOtp(String otp, String mobileNo,String countryCode) async {
    Get.log("countryCode on verify login otp:$countryCode");
    var formData = dio.FormData.fromMap({
      'mobile_no': mobileNo,
      'otp': otp,
      'device_token': Get.find<AuthService>().deviceToken,
      "country_code":countryCode.toString()
    });
    var response =
        await _dio.post(getBaseURL("check_login_otp"), data: formData);
    if (kDebugMode) {
      print("seeVerifyResponse${response.data}");
    }
    if (response.statusCode == 200) {
      return OtpData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<OtpData> verifyOtp(String otp, String name, String mobileNo, String licenseNo,String countryCode ) async {
    var formData = dio.FormData.fromMap({
      'mobile_no': mobileNo,
      'name': name,
      'otp': otp,
      'licence_no': licenseNo,
      'device_token': Get.find<AuthService>().deviceToken,
      "country_code":countryCode.toString()
    });
    var response =
        await _dio.post(getBaseURL("login_with_otp"), data: formData);
    if (kDebugMode) {
      print(response.data.toString());
      print('EndPoint: login_with_otp ${formData.fields} ');

    }
    if (response.statusCode == 200) {
      return OtpData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<BannerData> getBanners() async {
    var response = await _dio.get(getBaseURL("banners"));
    print(getBaseURL("banners"));
    if (response.statusCode == 200) {
      return BannerData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<CategoriesData> getCategories() async {
    var response = await _dio.get(getBaseURL("categories"));
    if (response.statusCode == 200) {
      return CategoriesData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductListData> getSellerProducts(String sellerId) async {
    final Map<String, String> params = <String, String>{
      'seller_id': sellerId,
      'currency': getValue(SharedPref.currencyCode)
    };
    var response = await _dio.get(getBaseURL("get_seller_products"),
        queryParameters: params);
    // Get.log(response.data.toString());
    if (response.statusCode == 200) {
      return ProductListData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductListData> getProductList(String categoryId, String itemType, int currentPage) async {
    final Map<String, String> params;
    if (itemType == 'none') {
      params = <String, String>{
        'category_id': categoryId,
        'sort_by': 'latest',
        'page': currentPage.toString(),
        'currency': getValue(SharedPref.currencyCode)
      };
    } else {
      params = <String, String>{
        'item_type': itemType,
        'sort_by': 'latest',
        'page': currentPage.toString(),
        'currency': getValue(SharedPref.currencyCode)
      };
    }

    log('item type in home getProduct:$params');

    var response =
        await _dio.get(getBaseURL("products"),options: getOptions(), queryParameters: params);
    // print(response.data);
    if (response.statusCode == 200) {
      return ProductListData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductListData> getBannerList(String bannerId, bool value) async {
    final Map<String, String> params = <String, String>{
       value==true?'banner_id':"ad_id": bannerId,
      'currency': getValue(SharedPref.currencyCode)
    };
    print(params);
    var response =
        await _dio.get(getBaseURL("products"), queryParameters: params);
    if (response.statusCode == 200) {
      return ProductListData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductListData> getFilteredItems(String categoryId, String itemType, String sortBy, String priceRange, String location) async {
    if (kDebugMode) {
      print('Category Id $categoryId');
      print('price range $priceRange');
      print('sort_by $sortBy');
      print('location Id $location');
    }

    final Map<String, String> params;
    if (itemType == 'none') {
      params = <String, String>{
        'category_id': categoryId,
        'price_range': priceRange,
        'sort_by': sortBy,
        'location': location,
        'page': '1',
        'currency': getValue(SharedPref.currencyCode)
      };
    } else {
      params = <String, String>{
        'item_type': itemType,
        'price_range': priceRange,
        'sort_by': sortBy,
        'location': location,
        'page': '1',
        'currency': getValue(SharedPref.currencyCode)
      };
    }
    var response =
        await _dio.get(getBaseURL("products"), queryParameters: params);
    if (response.statusCode == 200) {
      return ProductListData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductDetailData> getProductDetails(String productId) async {
    print("response");
    dio.Response response;
    var params = <String, String>{
      'currency': getValue(SharedPref.currencyCode)
    };
    print(getBaseURL("products/$productId"));
    if (GetStorage().hasData(SharedPref.authToken)) {
      response = await _dio.get(getBaseURL("products/$productId"),
          options: getOptions(), queryParameters: params);
    } else {
      response = await _dio.get(getBaseURL("products/$productId"),
          queryParameters: params);
    }
    print(response);
    if (response.statusCode == 200) {
      return ProductDetailData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> addToWishlist(String productId) async {
    var response = await _dio.post(getBaseURL("wishlist/$productId"),
        options: getOptions());
    if (kDebugMode) {
      print(response.data.toString());
    }
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> deleteAccount() async {
    var response =
        await _dio.post(getBaseURL("delete_account"), options: getOptions());
    if (kDebugMode) {
      print(response.data.toString());
    }
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> addToCart(String productId, String quantity) async {
    var formData = dio.FormData.fromMap({'quantity': quantity});
    var response = await _dio.post(getBaseURL("cart/product/$productId"),
        options: getOptions(), data: formData);
    if (kDebugMode) {
      print(response.data.toString());
    }
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<CartData> getCartItems() async {
    var params = <String, String>{
      'currency': getValue(SharedPref.currencyCode)
    };
    var response = await _dio.get(getBaseURL("cart"),
        options: getOptions(), queryParameters: params);
    if (kDebugMode) {
      print(response.data.toString());
      log(response.data.toString());
    }
    if (response.statusCode == 200) {
      return CartData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<UpdateAppData> getUpdateApp() async {
    var response = await _dio.get(getBaseURL("check_app_version"),
        options: getOptions());
    if (kDebugMode) {
      print(response.data.toString());
      log(response.data.toString());
    }
    if (response.statusCode == 200) {
      return UpdateAppData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ModelJobApplicants> getJobApplicants(int jobType) async {
    var params = <String, dynamic>{
      'job_type': jobType
    };


    log('job_applications queryParameters::$params:: ');
    var response = await _dio.get(getBaseURL("job_applications"),
        options: getOptions(),queryParameters: params);
    if (kDebugMode) {
      print(response.data.toString());
      log(response.data.toString());
    }
    if (response.statusCode == 200) {
      return ModelJobApplicants.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> deleteCartItem(String cartId) async {
    var response =
        await _dio.delete(getBaseURL("cart/$cartId"), options: getOptions());
    if (kDebugMode) {
      print(response.data.toString());
    }
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<WishlistData> getWishListItems() async {
    var params = <String, String>{
      'currency': getValue(SharedPref.currencyCode)
    };
    var response = await _dio.get(getBaseURL("wishlist"),
        options: getOptions(), queryParameters: params);
    if (kDebugMode) {
      print(response.data.toString());
    }
    if (response.statusCode == 200) {
      return WishlistData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NotificationData> getNotifications() async {
    var response =
        await _dio.get(getBaseURL("notifications"), options: getOptions());
    if (response.statusCode == 200) {
      return NotificationData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> contactUs(String name, String email, String mobile, String message) async {
    var formData = dio.FormData.fromMap(
        {'email': email, 'mobile': mobile, 'name': name, 'message': message});
    var response = await _dio.post(getBaseURL("contact_us"),
        data: formData, options: getOptions());
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProfileData> getProfile() async {
    var response =
        await _dio.get(getBaseURL("get_profile"), options: getOptions());
    if (kDebugMode) {
      print(response.data.toString());
    }
    if (response.statusCode == 200) {
      return ProfileData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> updateProfile(
    String name,
    String email,
    String mobile,
    String about,
    File image,
    String countryCode
    /*String country_code*/
  ) async {
    dio.FormData formData;
    if (image.path == '') {
      formData = dio.FormData.fromMap({
        'name': name,
        'email': email,
        'mobile_no': mobile,
        'about': about,
        "country_code":countryCode
        // 'country_code': country_code,
      });
    } else {
      formData = dio.FormData.fromMap({
        'name': name,
        'email': email,
        'mobile_no': mobile,
        'about': about,
        "country_code":countryCode,
        'image': await dio.MultipartFile.fromFile(image.path,
            filename: '${DateTime.now()}.png'),
      });
    }

    var response = await _dio.post(getBaseURL("update_profile"),
        data: formData, options: getOptions());
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> updateAddress(
      String address, String city, String lat, String lng) async {
    var formData = dio.FormData.fromMap(
        {'address': address, 'city': city, 'lat': lat, 'lng': lng});
    print(formData.fields);
    var response = await _dio.post(getBaseURL("update_address"),
        data: formData, options: getOptions());
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductListData> getSearchedItems(String keyword) async {
    Get.log(getValue(SharedPref.lat));
    Get.log(getValue(SharedPref.lng));
    Get.log(keyword);

    final params = <String, String>{
      'keyword': keyword,
      'latitude': getValue(SharedPref.lat) == 'null' ? '20.5937' : getValue(SharedPref.lat),
      'longitude': getValue(SharedPref.lng) == 'null' ? '78.9629' : getValue(SharedPref.lng),
      'currency': getValue(SharedPref.currencyCode)
    };
    params.addIf(GetStorage().hasData(SharedPref.isLogin), 'mobile_no',
        getValue(SharedPref.mobileNo));
    var response = await _dio.get(getBaseURL("products"),
        queryParameters: params, options: getOptions());
    Get.log('Response is ${response.data.toString()}');
    if (response.statusCode == 200) {
      return ProductListData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<AddAddressData> addAddress(
      String address,
      String pin,
      String addressType,
      String mobileNo,
      String city,
      String state,
      String lat,
      String lng) async {
    if (kDebugMode) {
      print('Address is $addressType');
      print(' =================== Pin code is $pin');
    }
    var formData = dio.FormData.fromMap({
      'address': address,
      'pincode': pin,
      'address_type': addressType,
      'mobile_no': mobileNo,
      'city': city,
      'state': state,
      'lat': lat,
      'lng': lng
    });
    print(formData.fields);
    print(getOptions());
    print(getBaseURL("addresses"));
    var response = await _dio.post(getBaseURL("addresses"),
        data: formData, options: getOptions());
    if (response.statusCode == 200) {
      return AddAddressData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<AddAddressData> getAddressList() async {
    var response =
        await _dio.get(getBaseURL("addresses"), options: getOptions());
    if (response.statusCode == 200) {
      return AddAddressData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> deleteAddress(String addressId) async {
    var response = await _dio.delete(getBaseURL("addresses/$addressId"),
        options: getOptions());
    if (kDebugMode) {
      print(getBaseURL("addresses/$addressId"));
      print(response.data.toString());
    }
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> setDefaultAddress(String addressId) async {
    var response = await _dio.post(getBaseURL("addresses/default/$addressId"),
        options: getOptions());
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> placeOrder() async {
    var response = await _dio.post(getBaseURL("orders"), options: getOptions());
    if (kDebugMode) {
      print('=================== > ${response.data}');
    }
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      Get.log("placeOrderProError:${response.data}");
      throw Exception(response.data);
    }
  }

  Future<AdminAccountData> getAdminAccount() async {
    var response =
        await _dio.get(getBaseURL("account_details"), options: getOptions());
    if (response.statusCode == 200) {
      return AdminAccountData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<OrderData> getOrderData(String status) async {
    final params = <String, String>{
      'status': status,
      'currency': getValue(SharedPref.currencyCode)
    };
    Get.log("getOrderDataParams:$params");
    var response = await _dio.get(getBaseURL("orders"),
        queryParameters: params, options: getOptions());
    log('Response ${response.data}');
    if (response.statusCode == 200) {
      // print(jsonDecode(orderData));
      return OrderData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<OrderDetailModel> getOrderDetails(String orderItemId) async {
    var formData = dio.FormData.fromMap({
      'order_item_id': orderItemId,
    });
    var response = await _dio.post(getBaseURL("getOrderStatus"),
        data: formData, options: getOptions());
    Get.log(response.data.toString());
    if (response.statusCode == 200) {
      return OrderDetailModel.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> addReview(String productID, String rating, String review, bool isVendor) async {
    dio.FormData formData;
    if (isVendor) {
      formData = dio.FormData.fromMap(
          {'vendor_id': productID, 'rating': rating, 'review': review});
    } else {
      formData = dio.FormData.fromMap(
          {'product_id': productID, 'rating': rating, 'review': review});
    }
    var response = await _dio.post(getBaseURL("reviews"),
        data: formData, options: getOptions());
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<NormalResponse> cancelOrder(String orderId) async {
    var response = await _dio.post(getBaseURL("orders/cancel/$orderId"),
        options: getOptions());
    if (response.statusCode == 200) {
      return NormalResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<DetailReviewData> getDetailReview(String type, String itemId) async {
    final params = <String, String>{
      'type': type,
    };
    var response = await _dio.get(getBaseURL("reviews/product/$itemId"),
        options: getOptions(), queryParameters: params);
    if (response.statusCode == 200) {
      return DetailReviewData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<DetailReviewData> getUserReview() async {
    var response =
        await _dio.get(getBaseURL("reviews/user"), options: getOptions());
    if (response.statusCode == 200) {
      return DetailReviewData.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<MessageModel> getChatMessages(String toUserId) async {
    var formData = dio.FormData.fromMap({
      'to_user_id': toUserId,
    });
    var response = await _dio.post(getBaseURL("chat_messages"),
        data: formData, options: getOptions());
    if (response.statusCode == 200) {
      return MessageModel.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<MessageModel> sendMessage(String toUserId, String message) async {
    var formData =
        dio.FormData.fromMap({'to_user_id': toUserId, 'message': message});
    var response = await _dio.post(getBaseURL("save_chat"),
        data: formData, options: getOptions());
    if (response.statusCode == 200) {
      return MessageModel.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<MessageModel> getMessageList() async {
    var response =
        await _dio.get(getBaseURL("chat_users_list"), options: getOptions());
    Get.log(
        'chat response ========================= ${response.data}');
    if (response.statusCode == 200) {
      return MessageModel.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<String> downloadReport(String userId, String startDate, String endDate) async {
    var response = await _dio.download(
        'https://oddaapp.com/appadmin/api/user/downloadOrderReport?user_id=$userId&from=$startDate&to$endDate',
        '/sdcard/download/abc.xlsX');
    if (response.statusCode == 200) {
      return "Report Downloaded";
    } else {
      throw Exception(response.data);
    }
  }
}
