// TMDB 전용 Dio Client(주소·Token 헤더·timeout·로그)를 만든다
// ─────────────────────────────────────────────────────────────
// [계층]   Core · 네트워크
//
// [기능]
//   - createTmdbClient() : baseUrl·Authorization 헤더·timeout 10초가 설정된 Dio 반환
//
// [동작]
//   BaseOptions로 모든 요청에 'Bearer <Token>' 헤더 자동 첨부
//   kDebugMode일 때만 TmdbLoggingInterceptor 등록 (release에서는 로그 없음)
//   timeout 초과·4xx·5xx는 DioException으로 호출한 쪽에 전달
//
// [의존성]
//   사용   : dio, core/config/tmdb_config.dart, core/network/tmdb_logging_interceptor.dart
//   사용처 : app/movie_log_app.dart (TmdbMovieService 생성 시 1번)
//
// [교체·수정 예정]
//   - 없음. MovieLog 자체 API는 인증 방식이 달라 별도 Client를 만든다.
// ─────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/tmdb_config.dart';
import 'tmdb_logging_interceptor.dart';

/// TMDB 전용 Dio Client를 만든다.
///
/// MovieLog 자체 API는 주소·인증 방식이 달라 Client를 따로 만든다.
/// (하나로 섞으면 자체 서버 요청에 TMDB Token이 실려 나갈 수 있다)
Dio createTmdbClient() {
  final dio = Dio(
    BaseOptions(
      // Service에서는 '/movie/popular'처럼 경로만 적는다.
      baseUrl: 'https://api.themoviedb.org/3',
      // 응답이 없을 때 무한히 기다리지 않고 DioException → Error 상태로 넘어가게 한다.
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        // Read Access Token은 Bearer 방식으로 헤더에 담는다. (.env에는 값만 저장)
        'Authorization': 'Bearer ${TmdbConfig.accessToken}',
        'accept': 'application/json',
      },
    ),
  );

  // 로그는 개발 중 확인용이므로 debug 빌드에서만 등록한다.
  if (kDebugMode) {
    dio.interceptors.add(TmdbLoggingInterceptor());
  }

  return dio;
}
