// TMDB 영화 카드: 포스터·★10점 평점·제목·개봉 연도, 탭하면 TMDB id로 상세 이동
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (공통 위젯)
//
// [기능]
//   - TmdbMovieCard(movie: TmdbMovieDto) : MovieCard와 같은 Figma 레이아웃
//   - TmdbMovieCard.infoHeight(60) : Grid 칸 높이 계산용
//
// [동작]
//   포스터는 TmdbPosterImage가 Positioned.fill 영역을 채운다
//   개봉일이 null·빈 문자열이면 연도를 비워 둔다 (줄 높이는 유지)
//   탭 → context.push('/movies/${id}') (TMDB id = 이후 평점 movieId)
//
// [의존성]
//   사용   : go_router, data/models/tmdb_movie_dto.dart, widgets/tmdb_poster_image.dart
//   사용처 : screens/home/home_screen.dart
//
// [교체·수정 예정]
//   - Required: MovieGrid에서도 사용 (MovieCard 대체)
// ─────────────────────────────────────────────────────────────

import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/tmdb_movie_dto.dart';
import 'tmdb_poster_image.dart';

/// TMDB 영화 한 편을 보여주는 카드. (MovieCard의 TMDB 버전)
/// 탭하면 TMDB id로 상세 화면에 이동한다.
///
/// 크기는 부모가 정한다(홈: SizedBox, 목록: Grid 칸).
/// 레이아웃·색은 Figma W3-02 "Article - Movie Item" 값을 따른다.
class TmdbMovieCard extends StatelessWidget {
  const TmdbMovieCard({super.key, required this.movie});

  /// 포스터 아래 텍스트 영역의 고정 높이. (간격 4 + 위 여백 8 + 제목 24 + 부제 24)
  static const double infoHeight = 60;

  final TmdbMovieDto movie;

  /// 'YYYY-MM-DD'에서 연도만 꺼낸다.
  /// TMDB는 개봉일이 없으면 null 또는 빈 문자열을 주므로 둘 다 '표시 안 함'으로 처리한다.
  String get _releaseYear {
    final date = movie.releaseDate;
    if (date == null || date.length < 4) return '';
    return date.substring(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // index가 아니라 TMDB id를 전달한다. 이 값이 이후 평점 API의 movieId가 된다.
      onTap: () => context.push('/movies/${movie.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest, // 이미지가 뜨기 전 자리 색
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      // 크기를 주지 않으면 Positioned.fill이 정한 영역을 채운다.
                      child: TmdbPosterImage(posterPath: movie.posterPath),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _RatingBadge(rating: movie.voteAverage),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              color: colors.onSurface,
            ),
          ),
          Opacity(
            opacity: 0.8,
            child: Text(
              _releaseYear, // 개봉일이 없으면 빈 줄(높이는 유지되어 카드 정렬이 깨지지 않음)
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 24 / 16,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 포스터 오른쪽 위의 ★ 평점 뱃지. TMDB vote_average(10점 만점)를 그대로 표시한다.
class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: colors.inverseSurface.withValues(alpha: 0.8),
          child: Text(
            '★ ${rating.toStringAsFixed(1)}', // 8.471 → '8.5'
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 16 / 12,
              color: colors.onInverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}
