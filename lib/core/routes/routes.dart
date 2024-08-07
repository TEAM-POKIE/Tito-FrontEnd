import 'package:go_router/go_router.dart';
import 'package:tito_app/src/screen/debate/debate_create_chat.dart';
import 'package:tito_app/src/screen/debate/debate_create_third.dart';
import 'package:tito_app/src/screen/home_screen.dart';
import 'package:tito_app/src/screen/list_screen.dart';
import 'package:tito_app/src/screen/myPage/change_name.dart';
import 'package:tito_app/src/screen/myPage/change_password.dart';
import 'package:tito_app/src/screen/myPage/myPage_main_screen.dart';
import 'package:tito_app/src/screen/myPage/my_alarm.dart';
import 'package:tito_app/src/screen/myPage/my_contact.dart';
import 'package:tito_app/src/screen/myPage/my_debate.dart';
import 'package:tito_app/src/screen/myPage/my_block.dart';
import 'package:tito_app/splash_screen.dart';
import 'package:tito_app/src/view/chatView/show_case.dart';
import 'package:tito_app/src/view/myPage/my_personalRule.dart';
import 'package:tito_app/src/view/myPage/my_rule.dart';
import 'package:tito_app/src/widgets/ai/ai_create.dart';
import 'package:tito_app/src/screen/debate/debate_create.dart';
import 'package:tito_app/src/screen/debate/debate_create_second.dart';
import 'package:tito_app/src/screen/login/basic_login.dart';
import 'package:tito_app/src/screen/login/login_main.dart';
import 'package:tito_app/src/screen/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/src/widgets/ai/ai_select.dart';
import 'package:tito_app/src/widgets/reuse/bottombar.dart';
import 'package:tito_app/src/screen/chat.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<bool> refreshNotifier = ValueNotifier<bool>(false);
final GoRouter router = GoRouter(
  //이 부분 없으니까 처음 화면 그냥 보라색으로 뜨는 경우도 있음. 초기화면 지정해 놓은 부분이야
  navigatorKey: rootNavigatorKey,
  refreshListenable: refreshNotifier,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const BottomBar(),
        );
      },
      branches: [
        //여러 개의 StatefulShellBranch를 포함
        //각 브랜치는 하나의 경로 집합
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/list',
              builder: (context, state) => const ListScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/mypage',
      builder: (context, state) => const MypageMainScreen(),
    ),
    GoRoute(
      path: '/mydebate',
      builder: (context, state) => const MyDebate(),
    ),
    GoRoute(
      path: '/myalarm',
      builder: (context, state) => const MyAlarm(),
    ),
    GoRoute(
      path: '/myblock',
      builder: (context, state) => const MyBlock(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const MyContact(),
    ),
    GoRoute(
      path: '/personalRule',
      builder: (context, state) => const MyPersonalrule(),
    ),
    GoRoute(
      path: '/rule',
      builder: (context, state) => const MyRule(),
    ),
    GoRoute(
      path: '/nickname',
      builder: (context, state) => const ChangeName(),
    ),
    GoRoute(
      path: '/password',
      builder: (context, state) => const ChangePassword(),
    ),
    GoRoute(
      path: '/debate_create',
      builder: (context, state) => const DebateCreate(),
    ),
    GoRoute(
      path: "/debate_create_second",
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: DebateCreateSecond()),
    ),
    GoRoute(
      path: '/debate_create_third',
      builder: (context, state) => const DebateCreateThird(),
    ),
    GoRoute(
      path: '/debate_create_chat',
      builder: (context, state) => const DebateCreateChat(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        // 'id'를 String에서 int로 변환
        final int id = int.parse(state.pathParameters['id']!);
        return Chat(
          id: id,
        );
      },
    ),
    //초기화면 지정하는 부분
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginMain(),
    ),
    GoRoute(
      path: '/ai_create',
      builder: (context, state) => AiCreate(),
    ),
    GoRoute(
      path: '/ai_select', 
      builder: (context, state) => AiSelect()
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const Signup(),
    ),
    GoRoute(
      path: '/basicLogin',
      builder: (context, state) => const BasicLogin(),
    ),
    GoRoute(
      path: '/showCase',
      builder: (context, state) => ShowCase(),
    ),
  ],
);
