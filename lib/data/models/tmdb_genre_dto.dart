// TMDB 공식 장르 하나(id, name)를 담는 DTO
// ─────────────────────────────────────────────────────────────
// [계층]   Data Layer · Model(DTO)
//
// [기능]
//   - 필드: id(with_genres에 보낼 값), name(Chip에 표시할 이름)
//   - TmdbGenreDto.fromJson(Map)
//
// [동작]
//   Service.fetchGenres()가 genres 배열의 각 요소마다 호출한다
//
// [의존성]
//   사용   : 없음 (순수 데이터)
//   사용처 : data/services/tmdb_movie_service.dart, view_models/movie_list_view_model.dart,
//            screens/movie_list/widgets/genre_chip_bar.dart
//
// [교체·수정 예정]
//   - 없음.
// ─────────────────────────────────────────────────────────────

class TmdbGenreDto {
  const TmdbGenreDto({required this.id, required this.name});
  final int id;
  final String name;

  factory TmdbGenreDto.fromJson(Map<String, dynamic> json) {
    return TmdbGenreDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );
  }
}
