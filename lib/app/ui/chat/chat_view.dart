import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/chat_controller.dart';
import 'package:odda/common/color_constants.dart';

import '../../../common/preferences.dart';
import '../../../common/utils.dart';

class ChatView extends GetView<ChatController>{
   ChatView({super.key});

   @override
  var controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        children: [

          Padding(
            padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: colorConstants.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ClipRRect(
                      borderRadius: getBorderRadiusCircular(),
                      child: Image.network(controller.vendorImage,
                          fit: BoxFit.cover,
                          width: getLargeTextFontSIze() * 1.6,
                          height: getLargeTextFontSIze() * 1.6),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addText(
                            controller.vendorName,
                            getNormalTextFontSIze(),
                            colorConstants.black,
                            FontWeight.bold),
                        // addText('Online', getSmallTextFontSIze(), colorConstants.greyTextColor, FontWeight.normal),
                      ],
                    )
                  ],
                ),
                GestureDetector(
                    onTap: () {

                    },
                    child: SizedBox())
              ],
            ),
          ),
          const Divider(),
          Expanded(child: buildChat()),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 2),
            decoration: BoxDecoration(
                border: Border.all(
                    color: colorConstants.lightGrey, width: 0.5),
                borderRadius: getBorderRadiusCircular()),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextFormField(
                      // inputFormatters: [CapitalCaseTextFormatter()],
                      maxLines: 100,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      controller: controller.chatController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: getNormalTextFontSIze()),
                      decoration: InputDecoration(
                          hintText: 'Type your text here...'.tr,
                          hintStyle: TextStyle(
                              fontSize: getNormalTextFontSIze(),
                              color: colorConstants.greyTextColor
                                  .withOpacity(0.8)),
                          contentPadding:
                          const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          // contentPadding: EdgeInsets.zero,
                          border: InputBorder.none),
                    )),
                GestureDetector(
                  onTap: () {
                    if (controller.chatController.text.trim().isNotEmpty) {
                      controller.sendMessage(controller.vendorId, controller.chatController.text.trim());
                    }
                  },
                  child: SvgPicture.asset(
                    'assets/images/send.svg',
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),

        ],
      )),
    );
  }

   Widget buildChat() {
     return Obx(() => controller.isLoading.value
         ? buildLoader()
         : ListView.builder(
       itemCount: controller.messageList.length,
       shrinkWrap: true,
       padding: const EdgeInsets.only(top: 10, bottom: 10),
       physics: const BouncingScrollPhysics(),
       reverse: true,
       itemBuilder: (context, index) {
         return Container(
           padding:
           const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
           child: Column(
             children: [
               Align(
                 alignment:
                 (controller.messageList[index].userId.toString() ==
                     getValue(SharedPref.userId)
                     ? Alignment.topRight
                     : Alignment.topLeft),
                 child: Container(
                   decoration: BoxDecoration(
                     borderRadius: controller.messageList[index].userId
                         .toString() ==
                         getValue(SharedPref.userId)
                         ? const BorderRadius.only(
                         topLeft: Radius.circular(20),
                         topRight: Radius.circular(20),
                         bottomLeft: Radius.circular(20))
                         : const BorderRadius.only(
                         topLeft: Radius.circular(20),
                         topRight: Radius.circular(20),
                         bottomRight: Radius.circular(20)),
                     color: (controller.messageList[index].userId
                         .toString() ==
                         getValue(SharedPref.userId)
                         ? colorConstants.primaryColor
                         : Colors.grey.shade200),
                   ),
                   padding: const EdgeInsets.symmetric(
                       horizontal: 15, vertical: 10),
                   child: addText(
                       controller.messageList[index].message.toString(),
                       getNormalTextFontSIze(),
                       controller.messageList[index].userId.toString() ==
                           getValue(SharedPref.userId)
                           ? colorConstants.white
                           : colorConstants.black,
                       FontWeight.normal),
                 ),
               ),
               const SizedBox(
                 height: 5,
               ),
               Align(
                 alignment:
                 (controller.messageList[index].userId.toString() ==
                     getValue(SharedPref.userId)
                     ? Alignment.topRight
                     : Alignment.topLeft),
                 child: addText(
                     // controller.getTime(controller.messageList[index].updatedAt.toString()),
                     controller.messageList[index].createdAt.toString(),
                     getSmallestTextFontSIze(),
                     colorConstants.greyTextColor,
                     FontWeight.normal),
               ),
             ],
           ),
         );
       },
     ));
   }

}