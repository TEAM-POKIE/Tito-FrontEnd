import 'package:go_router/go_router.dart';
import 'package:tito_app/screen/free_screen.dart';
import 'package:tito_app/screen/home_screen.dart';
import 'package:tito_app/screen/list_screen.dart';
import 'package:tito_app/screen/login_screen.dart';
import 'package:tito_app/widgets/ai/ai_create.dart';
import 'package:tito_app/widgets/debate/debate_create.dart';
import 'package:tito_app/widgets/debate/debate_create_second.dart';
import 'package:tito_app/widgets/login/basic_login.dart';
import 'package:tito_app/widgets/login/login_main.dart';
import 'package:tito_app/widgets/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/widgets/reuse/bottombar.dart';
import 'package:tito_app/widgets/debate/chat.dart';

final GoRouter router = GoRouter(
  //이 부분 없으니까 처음 화면 그냥 보라색으로 뜨는 경우도 있음. 초기화면 지정해 놓은 부분이야
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomBar(),
        );
      },
      branches: [
        //여러 개의 StatefulShellBranch를 포함
        //각 브랜치는 하나의 경로 집합
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/list',
              builder: (context, state) => ListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/free',
              builder: (context, state) => FreeScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/debate_create',
      builder: (context, state) => DebateCreate(),
    ),
    GoRoute(
      path: "/debate_create_second",
      pageBuilder: (BuildContext context, GoRouterState state) =>
          const NoTransitionPage(child: DebateCreateSecond()),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return Chat(
          id: id,
        );
      },
    ),

    //초기화면 지정하는 부분
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/ai_create',
      builder: (context, state) => AiCreate(),
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
      path: '/login',
      builder: (context, state) => const LoginMain(),
    ),
  ],
);
