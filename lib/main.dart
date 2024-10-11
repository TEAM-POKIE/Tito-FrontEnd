import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tito_app/firebase_options.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'core/routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'dart:async';
import 'package:flutter/services.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(_interceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_interceptor);
    super.dispose();
  }

  bool _interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      Fluttertoast.showToast(
        msg: "뒤로 버튼을 한 번 더 누르시면 종료됩니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
      return true; // 기본 동작을 막음
    }
    return false; // 앱 종료 허용
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // 피그마에 맞춘 사이즈
      minTextAdapt: true, // 텍스트 크기 자동 조정
      splitScreenMode: true, // 분할 화면 모드 활성화
      builder: (context, child) => ProviderScope(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router, // GoRouter 설정
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
