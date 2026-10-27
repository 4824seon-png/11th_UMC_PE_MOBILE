// 영화 목록 Empty 상태 화면 (조건에 맞는 영화 없음)
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (영화 목록 전용 위젯)
//
// [기능]
//   - MovieListEmpty : 가운데 안내 문구
//
// [동작]
//   부모가 status == empty일 때 표시한다
//
// [의존성]
//   사용   : flutter/material
//   사용처 : screens/movie_list/movie_list_screen.dart
//
// [교체·수정 예정]
//   - 없음. (4주차 위젯을 5주차 ViewModel 상태에서도 그대로 재사용)
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// 불러오기는 성공했지만 보여줄 영화가 없을 때의 Empty 상태 화면.
/// 서버가 빈 목록을 준 경우와 장르 필터 결과가 빈 경우 모두 이 화면을 쓴다.
class MovieListEmpty extends StatelessWidget {
  const MovieListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('조건에 맞는 영화가 없습니다.'));
  }
}
