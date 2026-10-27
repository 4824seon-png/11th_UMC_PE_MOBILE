// 0.5점 단위 별점 입력 위젯 (RatingBar.builder)
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (상세 화면 전용 위젯)
//
// [기능]
//   - MovieRatingInput(rating, onChanged) : 별 5개, 0.5 단위, 최소 0.5
//
// [동작]
//   값은 부모(RatingDialog)가 관리하고, 이 위젯은 입력만 onChanged로 알린다
//
// [의존성]
//   사용   : flutter_rating_bar
//   사용처 : screens/movie_detail/widgets/rating_dialog.dart
//
// [교체·수정 예정]
//   - 없음. (사용자 평점 입력은 5점 기준 유지, TMDB 평균 평점 표시는 10점 기준)
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// 0.5점 단위로 별점을 입력받는 위젯.
/// 별점 값은 부모가 관리하고, 이 위젯은 입력만 담당한다.
class MovieRatingInput extends StatelessWidget {
  const MovieRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  final double rating;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return RatingBar.builder(
      initialRating: rating,
      minRating: 0.5,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 40,
      itemBuilder: (context, index) => Icon(Icons.star, color: colors.primary),
      onRatingUpdate: onChanged,
    );
  }
}
