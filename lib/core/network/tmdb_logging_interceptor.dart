// TMDB 요청·응답·오류를 콘솔에 남기는 Dio Interceptor (Token 마스킹)
// ─────────────────────────────────────────────────────────────
// [계층]   Core · 네트워크
//
// [기능]
//   - onRequest  : Method·URL·Header(Authorization → 'Bearer ***')·Query 출력
//   - onResponse : Status Code·응답 Body(앞 800자) 출력
//   - onError    : 실패 URL·오류 종류·Status·TMDB 오류 Body 출력
//
// [동작]
//   모든 TMDB 요청이 이 검문소를 지난다 → 로그 형식이 하나로 통일
//   각 메서드 끝 handler.next(...)가 요청/응답을 다음 단계로 넘긴다 (빠뜨리면 멈춤)
//
// [의존성]
//   사용   : dio, flutter/foundation (debugPrint)
//   사용처 : core/network/tmdb_client.dart (kDebugMode에서만 등록)
//
// [교체·수정 예정]
//   - 없음. 트러블슈팅 기록의 '호출 API / Query / status / 응답 모양'을 이 로그에서 옮긴다.
// ─────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// TMDB Client를 지나는 모든 요청·응답·오류를 같은 형식으로 콘솔에 남긴다.
///
/// 화면마다 로그를 찍지 않고 이 한 곳에서 처리하므로, 형식이 통일되고 누락이 없다.
/// 기록만 담당하며 로그를 화면에 표시하거나 저장하지 않는다.
class TmdbLoggingInterceptor extends Interceptor {
  // 응답 Body는 수천 자가 넘어 콘솔이 잘리므로 앞부분만 출력한다.
  static const _maxBodyLength = 800;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 원본 headers를 바꾸면 실제 요청의 Token이 사라지므로 복사본을 마스킹한다.
    final maskedHeaders = Map<String, dynamic>.from(options.headers);
    if (maskedHeaders.containsKey('Authorization')) {
      maskedHeaders['Authorization'] = 'Bearer ***';
    }

    debugPrint('[TMDB 요청] ${options.method} ${options.uri}');
    debugPrint('[TMDB 요청 Header] $maskedHeaders');
    if (options.queryParameters.isNotEmpty) {
      debugPrint('[TMDB 요청 Query] ${options.queryParameters}');
    }

    // next를 호출해야 요청이 다음 단계(서버)로 넘어간다. 빠뜨리면 요청이 멈춘다.
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      '[TMDB 응답] ${response.statusCode} ${response.requestOptions.uri}',
    );
    debugPrint('[TMDB 응답 Body] ${_shorten(response.data.toString())}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[TMDB 오류] ${err.requestOptions.uri}');
    // 401 등 서버가 응답한 오류면 상태 코드와 TMDB의 오류 메시지도 남긴다.
    // Dio 기본 메시지는 여러 줄의 안내문이 붙으므로 첫 줄만 남긴다.
    debugPrint(
      '[TMDB 오류 내용] ${err.type.name} '
      '${err.response?.statusCode ?? '-'} ${err.message?.split('\n').first ?? ''}',
    );
    if (err.response?.data != null) {
      debugPrint('[TMDB 오류 Body] ${_shorten(err.response!.data.toString())}');
    }
    handler.next(err);
  }

  String _shorten(String text) => text.length <= _maxBodyLength
      ? text
      : '${text.substring(0, _maxBodyLength)}… (${text.length}자)';
}
