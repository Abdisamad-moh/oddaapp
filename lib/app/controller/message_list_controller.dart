import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../model/message_model.dart';
import '../repository/chat_repository.dart';

class MessageListController extends GetxController{

  late ChatRepository chatRepository;
  final isLoading = false.obs;
  final messageList = <MessageDatum>[].obs;

  MessageListController(){
    chatRepository = ChatRepository();
  }


  @override
  void onInit(){
    super.onInit();
    getChatMessages();
  }


  void getChatMessages() async {
    try {
        isLoading.value = true;
      MessageModel messageModel = await chatRepository.getMessageList();
      messageList.assignAll(messageModel.data);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        Get.log('Upper ===  ${e.response!.data}');
      } else {
        Get.snackbar('', e.toString());
        Get.log('Lower ===  $e');
      }
    }
  }

}