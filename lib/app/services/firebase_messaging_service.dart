
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odda/app/controller/home_controller.dart';
import 'package:odda/app/routes/app_routes.dart';
import 'package:odda/common/color_constants.dart';
import 'package:odda/common/utils.dart';
import 'package:odda/main.dart';

import 'auth_service.dart';



class FireBaseMessagingService extends GetxService {

  Future<FireBaseMessagingService> init() async {

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,);
    await fcmOnResumeListeners();
    await fcmOnMessageListeners();
    await fcmOnInitialMessageListener();
    await setDeviceToken();
    await onMessageOpened();
    FirebaseMessaging.instance.getToken().then((value) {
      if (kDebugMode) {
        print("Firebase Messaging token is $value");
      }
    });
    return this;
  }

  Future<void> setDeviceToken() async {
    Get.find<AuthService>().deviceToken = await FirebaseMessaging.instance.getToken();
  }

  Future<void> onMessageOpened() async {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.log('====================================> onMessageOpened');
      notificationsBackground(message);
    });
  }

  Future fcmOnInitialMessageListener() async {

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      Get.log('====================================> fcmOnInitialMessageListener');
      if (value != null) {
        notificationsBackground(value);
      }
    });
  }

  Future fcmOnMessageListeners() async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        Get.log('====================================> onFcmMessageListener');
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        print('Message data 2 : ${message.notification}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
          print('Notification Title: ${message.notification?.title}');
          print('Notification Body: ${message.notification?.body}');
        }
      }

      if(Get.find<HomeController>().initialized){
        Get.find<HomeController>().isNewNotification.value = true;
      }

      if (message.data['click_action'] == 'my_orders') {
        _newOrderNotificationForeground(message);
      } else if (message.data['click_action'] == "chats") {
        Get.snackbar(
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          backgroundColor: colorConstants.primaryColor,
          icon: const Icon(Icons.notifications_active,color: Colors.white,),
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          boxShadows: [getDeepBoxShadow(),getBoxShadow()],
          colorText: Colors.white,
          onTap: (getBar) async {
            Get.toNamed(Routes.VendorChats);
          },
        );
      } else {
        _newOtherNotificationBackground(message);
      }
    });
  }

  Future fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.log('====================================> fcmOnResumeListeners');
      notificationsBackground(message);
    });
  }

  void notificationsBackground(RemoteMessage message) {
    if (message.data['click_action'] == 'my_orders') {
      _newOrderNotificationBackground(message);
    } else if (message.data['click_action'] == "chats") {
      isNotificationOpened = true;
      Get.log('=============================== opened called');
      Get.offAllNamed(Routes.VendorChats);
    } else {
      _newOtherNotificationBackground(message);
    }
  }

  void _newOtherNotificationBackground(message) {

  }

  void _newOrderNotificationBackground(RemoteMessage message) {
    isNotificationOpened = true;
    Get.log('=============================== opened called');
    Get.offAllNamed(Routes.MyOrders);
  }

  void _newOrderNotificationForeground(RemoteMessage message) {
    Get.snackbar(

      message.notification!.title.toString(),
      message.notification!.body.toString(),
      backgroundColor: colorConstants.primaryColor,
      colorText: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      boxShadows: [getDeepBoxShadow(),getBoxShadow()],
      icon: const Icon(Icons.notifications_active,color: Colors.white,),
      onTap: (getBar) async {
        Get.toNamed(Routes.MyOrders);
      },
    );
  }
}











// class FireBaseMessagingService extends GetxService {
//
//   Future<FireBaseMessagingService> init() async {
//     FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,);
//     await fcmOnLaunchListeners();
//     await fcmOnResumeListeners();
//     await fcmOnMessageListeners();
//     await fcmOnInitialMessageListener();
//     await setDeviceToken();
//     // await onMessageOpened();
//     FirebaseMessaging.instance.getToken().then((value) {
//       if (kDebugMode) {
//         print("Firebase Messaging token is $value");
//       }
//     });
//     return this;
//   }
//
//   Future<void> setDeviceToken() async {
//     Get.find<AuthService>().deviceToken = await FirebaseMessaging.instance.getToken();
//   }
//
//   Future onMessageOpened() async {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       notificationsBackground(message);
//     });
//   }
//
//   Future fcmOnInitialMessageListener() async {
//     // FirebaseMessaging.instance.getInitialMessage().then((value) {
//     //   if (value != null) {
//     //     notificationsBackground(value);
//     //   }
//     // });
//     FirebaseMessaging.instance.getInitialMessage();
//
//   }
//
//   Future fcmOnMessageListeners() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print('Got a message whilst in the foreground!');
//         print('Message data: ${message.data}');
//       }
//
//       if (message.notification != null) {
//         if (kDebugMode) {
//           print('Message also contained a notification: ${message.notification}');
//           print('Notification Title: ${message.notification?.title}');
//           print('Notification Body: ${message.notification?.body}');
//         }
//       }
//
//       Get.snackbar(
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         backgroundColor: colorConstants.primaryColor,
//         colorText: Colors.white,
//         onTap: (getBar) async {
//
//         },
//       );
//     });
//   }
//
//   Future fcmOnLaunchListeners() async {
//     RemoteMessage? message =
//     await FirebaseMessaging.instance.getInitialMessage();
//     if (message != null) {
//       notificationsBackground(message);
//     }
//   }
//
//   Future fcmOnResumeListeners() async {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       notificationsBackground(message);
//     });
//   }
//
//   void notificationsBackground(RemoteMessage message) {
//     Get.log('Background app opened clicked');
//     // Get.toNamed(Routes.Root);
//   }
//
//   void _newOtherNotificationBackground(message) {
//     Get.toNamed(Routes.Root);
//   }
//
// }