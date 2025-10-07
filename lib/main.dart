import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odda/app/provider/api_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'app/routes/Theme1AppPages.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_messaging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  //flutter build appbundle --obfuscate --split-debug-info=build/app/outputs/symbols/
  Get.log('starting services ...');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await GetStorage.init();
  await Get.putAsync(() => ApiProvider().init());
  await Get.putAsync(() => AuthService().init());
  Get.log('All services started....');
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  Get.log(
      "=====================handling a background message: ${message.messageId}");
}

bool isNotificationOpened = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ResponsiveSizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        builder: (context, child) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return CustomError(errorDetails: errorDetails);
          };
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
            child: child!,
          );
        },
        onReady: () async {
          await Get.putAsync(() => FireBaseMessagingService().init());
        },
        title: 'Odda',
        initialRoute: Theme1AppPages.INITIAL,
        getPages: Theme1AppPages.routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Nunito',
        ),
      );
    });
  }
}

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        color: Colors.red,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Something is not right here...",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
