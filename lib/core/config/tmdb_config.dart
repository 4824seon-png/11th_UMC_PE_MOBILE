// TMDB 설정값(.env의 Access Token)을 읽는 창구
// ─────────────────────────────────────────────────────────────
// [계층]   Core · 설정
//
// [기능]
//   - TmdbConfig.accessToken    : .env의 TMDB_ACCESS_TOKEN (없으면 빈 문자열)
//   - TmdbConfig.hasAccessToken : Token 설정 여부 (원문 없이 확인용)
//
// [동작]
//   main()의 dotenv.load() 이후 getter가 호출될 때마다 dotenv.env에서 읽는다
//   값이 비어 있으면 TMDB 요청이 401로 실패한다
//
// [의존성]
//   사용   : flutter_dotenv
//   사용처 : main.dart, core/network/tmdb_client.dart
//
// [교체·수정 예정]
//   - 없음. 키 이름('TMDB_ACCESS_TOKEN')은 이 파일에만 둔다.
// ─────────────────────────────────────────────────────────────

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// .env에 저장한 TMDB 설정을 읽는 곳.
///
/// 키 문자열('TMDB_ACCESS_TOKEN')을 이 파일에만 두어,
/// 여러 파일에서 반복하다 오타로 빈 Token이 들어가는 문제를 막는다.
/// abstract final class: 인스턴스를 만들지도, 상속하지도 않는 이름공간 (TmdbConfig.accessToken으로 사용).
abstract final class TmdbConfig {
  static const _accessTokenKey = 'TMDB_ACCESS_TOKEN';

  /// main()의 dotenv.load()가 끝난 뒤에 읽어야 값이 들어 있다.
  /// 값이 없으면 빈 문자열 → 요청 시 TMDB가 401로 응답한다.
  static String get accessToken => dotenv.env[_accessTokenKey] ?? '';

  /// Token 원문을 출력하지 않고 설정 여부만 확인할 때 사용한다.
  static bool get hasAccessToken => accessToken.isNotEmpty;
}
