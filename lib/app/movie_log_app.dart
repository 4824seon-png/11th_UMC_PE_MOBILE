// 앱 최상단 위젯: 공용 Provider를 등록하고 MaterialApp.router를 구성한다
// ─────────────────────────────────────────────────────────────
// [계층]   앱 구성 (UI Layer 최상단)
//
// [기능]
//   - MultiProvider  : 여러 화면이 공유하는 객체 등록 (TmdbMovieService 1개)
//   - MaterialApp.router : 테마(AppTheme.light)·제목·라우터(AppRouter.router) 설정
//
// [동작]
//   MultiProvider가 MaterialApp.router를 감싼다
//   → GoRouter가 만드는 모든 화면에서 context.read<TmdbMovieService>() 가능
//   → Provider.create는 처음 read될 때 1번 실행 (Dio·Service를 앱 전체가 공유)
//
// [의존성]
//   사용   : provider, core/network/tmdb_client.dart, data/services/tmdb_movie_service.dart,
//            router/app_router.dart, core/theme/app_theme.dart
//   사용처 : main.dart
//
// [교체·수정 예정]
//   - 이후 주차: MovieLog 자체 API Client·인증 상태 등을 providers 목록에 추가한다.
//   - 화면별 ViewModel은 여기가 아니라 router/app_router.dart의 각 Route에서 만든다.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/network/tmdb_client.dart';
import '../data/services/tmdb_movie_service.dart';
import '../router/app_router.dart';
import '../core/theme/app_theme.dart';

/// 앱의 최상단 위젯.

/// MaterialApp.router 바깥에 있어야 GoRouter가 만드는 모든 화면에서 context.read로 찾을 수 있다.
class MovieLogApp extends StatelessWidget {
  const MovieLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 상태 없는 Service는 앱 전체에서 1개를 공유한다.
        // 화면별 ViewModel은 여기가 아니라 각 Route(app_router.dart)에서 만든다.
        Provider<TmdbMovieService>(
          create: (_) => TmdbMovieService(createTmdbClient()),
        ),
      ],
      // MaterialApp.router: 앱 전역 설정(테마·제목)만 담당하고,
      // 어떤 화면을 보여줄지는 routerConfig로 넘긴 GoRouter가 결정한다.
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'MovieLog',
        theme: AppTheme.light,
        routerConfig: AppRouter.router, // static final → 앱 전체에서 라우터 1개 유지
      ),
    );
  }
}
