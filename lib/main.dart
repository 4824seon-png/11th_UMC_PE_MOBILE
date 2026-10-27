// 앱 진입점: .env(TMDB Token)를 로드한 뒤 MovieLogApp을 실행한다
// ─────────────────────────────────────────────────────────────
// [계층]   앱 시작 (Entry Point)
//
// [기능]
//   - main() : Flutter 엔진 준비 → dotenv.load → (debug) Token 설정 여부 출력 → runApp
//
// [동작]
//   WidgetsFlutterBinding.ensureInitialized() → await dotenv.load('.env')
//   → [TMDB] Token 설정됨: true/false (원문은 출력하지 않음) → runApp(MovieLogApp)
//
// [의존성]
//   사용   : flutter_dotenv, app/movie_log_app.dart, core/config/tmdb_config.dart
//   사용처 : 없음 (Flutter가 가장 먼저 실행)
//
// [교체·수정 예정]
//   - 없음. 앱 구성(Provider·테마·라우터)은 app/movie_log_app.dart에서 수정한다.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/movie_log_app.dart';
import 'core/config/tmdb_config.dart';

// [5주차] .env를 읽은 뒤에 앱을 시작해야 하므로 async main.
Future<void> main() async {
  // runApp 전에 asset(.env)을 읽으려면 Flutter 엔진 연결을 먼저 준비해야 한다.
  WidgetsFlutterBinding.ensureInitialized();

  // await: 로드가 끝나기 전에 Token을 읽으면 빈 값이 나온다.
  await dotenv.load(fileName: '.env');

  // Token 원문 대신 설정 여부만 출력한다. (debug 빌드에서만)
  if (kDebugMode) {
    debugPrint('[TMDB] Token 설정됨: ${TmdbConfig.hasAccessToken}');
  }

  runApp(const MovieLogApp());
}
