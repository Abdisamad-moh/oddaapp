import 'package:get/get.dart';
import 'package:odda/app/provider/api_provider.dart';


import '../model/product_list_data.dart';

class SearchRepository{

  late ApiProvider _apiProvider;

  SearchRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }


  Future<ProductListData> getSearchedItems(String keyword) async {
    return _apiProvider.getSearchedItems(keyword);
  }





}