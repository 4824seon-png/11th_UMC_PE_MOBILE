// TMDB 영화 한 편의 응답 JSON을 담는 DTO
// ─────────────────────────────────────────────────────────────
// [계층]   Data Layer · Model(DTO)
//
// [기능]
//   - 필드: id, title, overview, posterPath?, backdropPath?, releaseDate?, genreIds,
//   -       voteAverage(10점 만점), popularity
//   - TmdbMovieDto.fromJson(Map) : snake_case 키 → 필드, num → int/double, null 기본값
//
// [동작]
//   TmdbMoviePageDto.fromJson이 results의 각 요소마다 호출한다
//   overview·releaseDate는 null 대신 빈 문자열로 올 수 있다 → 화면에서 isEmpty로 확인
//
// [의존성]
//   사용   : 없음 (순수 데이터)
//   사용처 : data/models/tmdb_movie_page_dto.dart, view_models/movie_home_view_model.dart,
//            widgets/tmdb_movie_card.dart, screens/home/home_screen.dart
//
// [교체·수정 예정]
//   - Required: MovieListViewModel·MovieGrid에서도 사용 (id는 평점 API의 movieId)
// ─────────────────────────────────────────────────────────────

class TmdbMovieDto {
  const TmdbMovieDto({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.genreIds,
    required this.voteAverage,
    required this.popularity,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final List<int> genreIds;
  final double voteAverage;
  final double popularity;

  factory TmdbMovieDto.fromJson(Map<String, dynamic> json) {
    return TmdbMovieDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '제목 없음',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>? ?? const [])
          .map((value) => (value as num).toInt())
          .toList(),
      voteAverage: (json['vote_average'] as num? ?? 0).toDouble(),
      popularity: (json['popularity'] as num? ?? 0).toDouble(),
    );
  }
}
