import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odda/app/model/message_model.dart';
import '../repository/chat_repository.dart';

class ChatController extends GetxController{
  late ChatRepository chatRepository;
  final isLoading = false.obs;
  late TextEditingController chatController;
  var vendorName = '';
  var vendorImage = '';
  var vendorId = '';
  Timer? timer;
  final messageList = <MessageDatum>[].obs;

  ChatController(){
    chatRepository = ChatRepository();
    chatController = TextEditingController();
  }

  @override
  void onInit(){
    super.onInit();
    vendorName = Get.arguments['vendorName'] as String;
    vendorImage = Get.arguments['vendorImage'] as String;
    vendorId = Get.arguments['vendorId'] as String;
    Get.log(vendorName);
    Get.log(vendorId);
    Get.log(vendorImage);
    getChatMessages(true);
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => getChatMessages(false));
  }

  @override
  void onClose(){
    super.onClose();
    timer!.cancel();
  }

  void getChatMessages(bool showLoader) async {
    try {
      if(showLoader) {
        isLoading.value = true;
      }
      MessageModel messageModel = await chatRepository.getChatMessages(vendorId);
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

  void sendMessage(String otherUSerId,String messsage) async {
    try {
      MessageModel messageModel = await chatRepository.sendMessage(otherUSerId,messsage);
      messageList.assignAll(messageModel.data);
      chatController.clear();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (e is DioException) {
        Get.snackbar('', e.response!.data['msg']);
        Get.log(e.response!.data);
      } else {
        Get.snackbar('', e.toString());
        Get.log(e.toString());
      }
    }
  }

  String getTime(String time){
    DateTime dateTime = DateTime.parse(time);
    // return '${dateTime.hour}:${dateTime.minute}';
    return DateFormat('hh:mm a').format(dateTime);
  }
}