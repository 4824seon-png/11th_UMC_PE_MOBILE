// TMDB 영화 목록을 2열 Grid로 그리는 위젯 (Success 상태 화면)
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (영화 목록 전용 위젯)
//
// [기능]
//   - MovieGrid(movies, genreNames) : Figma 간격(좌우 16, 열 16, 행 24)
//     칸 높이 = 포스터(칸 너비 × 1.5) + TmdbMovieCard.infoHeight(60)
//
// [동작]
//   LayoutBuilder로 칸 너비 계산 → GridView.builder로 보이는 칸만 생성
//   각 영화의 genreIds를 앞에서부터 genreNames에서 찾아 첫 번째 이름을 카드 부제로 넘긴다
//
// [의존성]
//   사용   : data/models/tmdb_movie_dto.dart, widgets/tmdb_movie_card.dart
//   사용처 : screens/movie_list/movie_list_screen.dart
//
// [교체·수정 예정]
//   - Challenge: Pull to Refresh는 이 Grid를 RefreshIndicator로 감싸 구현할 수 있다
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../data/models/tmdb_movie_dto.dart';
import '../../../widgets/tmdb_movie_card.dart';

/// 영화 목록을 2열 Grid로 보여준다.
/// 어떤 목록을 보여줄지는 부모가 정하고, 이 위젯은 그리기만 담당한다(Success 상태 화면).
class MovieGrid extends StatelessWidget {
  const MovieGrid({
    super.key,
    required this.movies,
    this.genreNames = const {},
  });

  final List<TmdbMovieDto> movies;

  /// 장르 id → 이름 (ViewModel.genreNames). 카드 부제 '2024 · SF'에 사용한다.
  final Map<int, String> genreNames;

  static const double _horizontalPadding = 16; // Figma 좌우 여백
  static const double _columnGap = 16; // Figma 열 간격
  static const double _rowGap = 24; // Figma 행 간격

  /// genreIds를 앞에서부터 확인해 이름을 아는 첫 장르를 돌려준다. 없으면 null.
  String? _firstGenreName(TmdbMovieDto movie) {
    for (final id in movie.genreIds) {
      final name = genreNames[id];
      if (name != null) return name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // [결정] 칸 높이: childAspectRatio 대신 mainAxisExtent(고정 높이)
    // - Figma 포스터는 2:3 비율이고 텍스트 영역은 60px로 고정이다.
    // → LayoutBuilder로 실제 칸 너비를 구해 "포스터 높이(너비 × 1.5) + 60"을 칸 높이로 쓴다.
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - _horizontalPadding * 2 - _columnGap) / 2;

        return GridView.builder(
          padding: const EdgeInsets.all(_horizontalPadding),
          itemCount: movies.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한 줄에 2개
            crossAxisSpacing: _columnGap, // 좌우 간격
            mainAxisSpacing: _rowGap, // 위아래 간격
            mainAxisExtent: itemWidth * 1.5 + TmdbMovieCard.infoHeight,
          ),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return TmdbMovieCard(
              movie: movie,
              genreName: _firstGenreName(movie),
            );
          },
        );
      },
    );
  }
}
