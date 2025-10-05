import 'package:get/get.dart';

import '../model/CategoriesData.dart';
import '../model/banner_data.dart';
import '../model/normal_response.dart';
import '../model/product_list_data.dart';
import '../provider/api_provider.dart';

class HomeRepository{

  late ApiProvider _apiProvider;

  HomeRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<BannerData> getBanners() async {
    return _apiProvider.getBanners();
  }

  Future<CategoriesData> getCategories() async {
    return _apiProvider.getCategories();
  }

  Future<ProductListData> getProductList(String categoryId, String itemType,int currentPage) async {
    return _apiProvider.getProductList(categoryId, itemType,currentPage);
  }

  Future<NormalResponse> contactUs(
      String name, String email, String mobile, String message) async {
    return _apiProvider.contactUs(name, email, mobile, message);
  }

  Future<NormalResponse> updateAddress(String address,String city,String lat,String lng) async {
    return _apiProvider.updateAddress(address, city, lat, lng);
  }

  Future<NormalResponse> deleteAccount() async {
    return _apiProvider.deleteAccount();
  }


}