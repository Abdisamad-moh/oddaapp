import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/common/color_constants.dart';

import '../../../common/header.dart';
import '../../../common/utils.dart';
import '../../controller/message_list_controller.dart';
import '../../routes/app_routes.dart';

class MessageListView extends GetView<MessageListController> {
  MessageListView({super.key});

  @override
  var controller = Get.put(MessageListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorConstants.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
        children: [
            AppHeader(title: 'Seller Chats'),
            const SizedBox(height: 20,),
            Expanded(child: Obx(() => controller.isLoading.value ? buildLoader() :
            controller.messageList.isEmpty ? Center(
              child: addText('No Chats Found', getHeadingTextFontSIze(), colorConstants.black, FontWeight.normal),
            ) :

            ListView.builder(
              itemCount: controller.messageList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {

                      Get.toNamed(Routes.ChatView,arguments: {
                        'vendorName' : controller.messageList[index].toUser.name.toString(),
                        'vendorImage' : controller.messageList[index].toUser.image.toString(),
                        'vendorId' : controller.messageList[index].toUser.id.toString(),
                      });
                      // controller.messageList[index].unreadMsgs = 0;
                      // controller.messageList.assignAll(controller.messageList);
                      controller.getChatMessages();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: colorConstants.lightGrey.withOpacity(0.2),
                          borderRadius: getCurvedBorderRadius()
                      ),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: getBorderRadiusCircular(),
                                child: Image.network(controller.messageList[index].toUser.image.toString(),width: 50,height: 50,fit: BoxFit.cover,),
                              ),
                              const SizedBox(width: 20,),
                              addText(controller.messageList[index].toUser.name.toString(), getSubheadingTextFontSIze(), colorConstants.black, FontWeight.normal),


                            ],
                          ),


                          if(controller.messageList[index].unreadMsgs > 0)
                            Container(
                              margin : const EdgeInsets.only(top:3),
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: colorConstants.primaryColor,
                                shape: BoxShape.circle,
                              ),child: addText(controller.messageList[index].unreadMsgs.toString(), getSmallestTextFontSIze(), colorConstants.white, FontWeight.normal),
                            )


                        ],

                      ),
                    )
                );
              },
            )

            ))


        ],
      ),
          )),
    );
  }
}
