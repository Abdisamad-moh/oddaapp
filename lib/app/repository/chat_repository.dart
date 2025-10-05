import 'package:get/get.dart';
import 'package:odda/app/provider/api_provider.dart';

import '../model/message_model.dart';

class ChatRepository{

  late ApiProvider _apiProvider;

  ChatRepository(){
    _apiProvider = Get.find<ApiProvider>();
  }


  Future<MessageModel> getChatMessages(String toUserId) async {
    return _apiProvider.getChatMessages(toUserId);
  }


  Future<MessageModel> sendMessage(String toUserId,String message) async {
    return _apiProvider.sendMessage(toUserId, message);
  }

  Future<MessageModel> getMessageList() async {
    return _apiProvider.getMessageList();
  }




}