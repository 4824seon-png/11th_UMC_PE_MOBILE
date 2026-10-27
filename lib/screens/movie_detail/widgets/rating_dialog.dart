// 평점 입력 Dialog: 별점을 고르고 확인하면 값을 반환한다 (TMDB movieId 보유)
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (상세 화면 전용 위젯)
//
// [기능]
//   - RatingDialog(movieId) : MovieRatingInput + 확인 버튼 (0점이면 비활성)
//
// [동작]
//   확인 → [평점] movieId·score 로그 → Navigator.pop(context, rating)
//   → showDialog<double>의 반환값이 된다
//   [미션 8] movieId = TmdbMovieDto.id. 이후 평점 API(CreateRatingRequest.movieId)에 그대로 쓴다
//
// [의존성]
//   사용   : screens/movie_detail/widgets/movie_rating_input.dart
//   사용처 : screens/movie_detail/movie_detail_screen.dart
//
// [교체·수정 예정]
//   - 이후 주차: 확인 시 MovieLog 자체 평점 API로 movieId·score 전송
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import 'movie_rating_input.dart';

/// 별점을 입력받는 Dialog.
/// 어떤 영화의 평점인지 알 수 있도록 TMDB 영화 id(movieId)를 함께 받는다.
class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, required this.movieId});

  /// TMDB 영화 id. 배열 index가 아니라 영화를 식별하는 값이다.
  final int movieId;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '영화는 어떠셨나요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            MovieRatingInput(
              rating: rating,
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              // [결정] 0점일 때 확인 버튼 비활성화
              // - onPressed가 null이면 버튼이 비활성화된다. 별을 누르면 setState → rebuild로 다시 계산되어 활성화.
              onPressed: rating == 0
                  ? null
                  : () {
                      // [미션 8] 인증용: 평점이 어떤 TMDB 영화 id로 기록되는지 남긴다.
                      // (State 안에서는 생성자 값을 widget.으로 읽는다)
                      debugPrint(
                        '[평점] movieId=${widget.movieId}, score=$rating',
                      );
                      // 두 번째 인자가 showDialog<double>의 반환값이 된다.
                      Navigator.pop(context, rating);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
