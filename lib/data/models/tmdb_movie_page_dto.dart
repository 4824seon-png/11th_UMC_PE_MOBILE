// TMDB Popular·Discover 응답의 한 페이지(영화 목록 + 페이지 정보) DTO
// ─────────────────────────────────────────────────────────────
// [계층]   Data Layer · Model(DTO)
//
// [기능]
//   - 필드: page, results(List<TmdbMovieDto>), totalPages, totalResults
//   - TmdbMoviePageDto.fromJson(Map) : results 각 요소를 TmdbMovieDto.fromJson으로 변환
//
// [동작]
//   Service가 response.data를 넘기면 페이지 정보와 영화 20개를 한 번에 변환한다
//   totalPages는 '다음 페이지가 있는지' 판단에 쓰인다
//
// [의존성]
//   사용   : data/models/tmdb_movie_dto.dart
//   사용처 : data/services/tmdb_movie_service.dart
//
// [교체·수정 예정]
//   - Required 12: MovieListViewModel의 최대 30개 수집 종료 조건(pageNumber < totalPages)
// ─────────────────────────────────────────────────────────────

import 'tmdb_movie_dto.dart';

class TmdbMoviePageDto {
  const TmdbMoviePageDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<TmdbMovieDto> results;
  final int totalPages;
  final int totalResults;

  factory TmdbMoviePageDto.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? const [];

    return TmdbMoviePageDto(
      page: (json['page'] as num).toInt(),
      results: rawResults
          .map((item) => TmdbMovieDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );
  }
}
