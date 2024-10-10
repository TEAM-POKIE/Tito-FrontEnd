import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tito_app/firebase_options.dart';

import 'core/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:flutter/services.dart'; // 가로방향 막히기

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;

  if (notification != null) {
    FlutterLocalNotificationsPlugin().show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'high_importance_notification',
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}

void initializeNotification() async {
  // $ Notification 권한 요청
  // TODO: 안드로이드에서도 이렇게 해도 되는지, isDenied랑 하단의 조건 차이 뭔지 알아야함.
  if (await Permission.notification.isDenied &&
      !await Permission.notification.isPermanentlyDenied) {
    await [Permission.notification].request();
  }

  // $ Handler 1. Background 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // // $ Handler 2. Foreground 등록
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   if (notification != null) {
  //     FlutterLocalNotificationsPlugin().show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel',
  //           'high_importance_notification',
  //           importance: Importance.max,
  //         ),
  //         iOS: DarwinNotificationDetails(
  //           presentAlert: true,
  //           presentBadge: true,
  //           presentSound: true,
  //         ),
  //       ),
  //     );
  //   } else {
  //     debugPrint("DEV: 비어있는 알림이 수신됨. 코드 확인 필요");
  //   }
  // });

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // $ [Android Only] 안드로이드 Notification Channel 생성
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  // $ 안드로이드, iOS Notification Init
  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true)));

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

Future main() async {
  // ? 카카오 SDK 초기화
  KakaoSdk.init(
      nativeAppKey: '01fe6631fc7787a553528a1b214e2bc5',
      javaScriptAppKey: 'b3a30cb79cb258aee47056953e90bd7d');

  // ? 세로 모드 고정
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ? Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ? Notification 초기화
  initializeNotification();

  AndroidInitializationSettings android =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings ios = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  final InitializationSettings initSettings = InitializationSettings(
    android: android,
    iOS: ios,
  );
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );
  [Permission.notification].request();

  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('fcmToken $fcmToken');

  Timer(Duration(milliseconds: 100), () {
    FlutterNativeSplash.remove();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // 피그마에 디자인 된 앱 프레임 사이즈로 맞춰서 적용한 것
      minTextAdapt: true, // 텍스트 크기를 자동으로 조정하여 화면에 맞추는 기능을 활성화
      splitScreenMode: true, // 분할 화면 모드를 활성화
      builder: (context, child) => ProviderScope(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'Tito',
          theme: ThemeData(
            scaffoldBackgroundColor: ColorSystem.white,
            primaryColor: ColorSystem.purple,
          ),
        ),
      ),
    );
  }
}
