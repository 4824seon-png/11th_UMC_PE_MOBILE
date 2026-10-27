// TMDB 영화 API를 호출하고 응답 JSON을 DTO로 변환하는 Service
// ─────────────────────────────────────────────────────────────
// [계층]   Data Layer · Service (상태 없음, 앱 전체에서 1개 공유)
//
// [기능]
//   - fetchPopular(page)            : 인기 영화 한 페이지 → TmdbMoviePageDto
//   - discoverMovies(page, genreId) : 조건 탐색 (genreId가 null이면 with_genres 생략)
//   - fetchGenres()                 : 공식 장르 목록 → List<TmdbGenreDto>
//
// [동작]
//   Dio GET → (Interceptor 로그) → TMDB → response.data(Map) → DTO.fromJson
//   실패(401·timeout 등)는 DioException으로 호출한 ViewModel에 그대로 전달된다
//
// [의존성]
//   사용   : dio, data/models/tmdb_movie_page_dto.dart, data/models/tmdb_genre_dto.dart
//   사용처 : app/movie_log_app.dart (생성), view_models/movie_home_view_model.dart
//
// [교체·수정 예정]
//   - 없음. '5개·30개·선택 장르' 같은 화면 정책은 넣지 않는다(ViewModel 담당).
//   - Required: MovieListViewModel이 discoverMovies·fetchGenres를 사용한다.
// ─────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';

import '../models/tmdb_genre_dto.dart';
import '../models/tmdb_movie_page_dto.dart';

class TmdbMovieService {
  TmdbMovieService(this._dio);
  final Dio _dio;

  Future<TmdbMoviePageDto> fetchPopular({int page = 1}) async {
    final response = await _dio.get(
      '/movie/popular',
      queryParameters: {'language': 'ko-KR', 'page': page},
    );
    return TmdbMoviePageDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TmdbMoviePageDto> discoverMovies({
    required int page,
    int? genreId,
  }) async {
    final response = await _dio.get(
      '/discover/movie',
      queryParameters: {
        'language': 'ko-KR',
        'page': page,
        'sort_by': 'popularity.desc',
        'include_adult': false,
        'include_video': false,
        'with_genres': ?genreId,
        // genreId가 null이면 이 항목 자체를 넣지 않는다 → "전체" 조회
      },
    );
    return TmdbMoviePageDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<TmdbGenreDto>> fetchGenres() async {
    final response = await _dio.get(
      '/genre/movie/list',
      queryParameters: {'language': 'ko'},
    );
    final data = response.data as Map<String, dynamic>;
    final genres = data['genres'] as List<dynamic>? ?? const [];
    return genres
        .map((item) => TmdbGenreDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
