// 영화 목록 Loading 상태 화면 (스피너)
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (영화 목록 전용 위젯)
//
// [기능]
//   - MovieListLoading : 가운데 CircularProgressIndicator
//
// [동작]
//   부모가 status == idle|loading일 때 표시한다
//
// [의존성]
//   사용   : flutter/material
//   사용처 : screens/movie_list/movie_list_screen.dart
//
// [교체·수정 예정]
//   - 없음. Required에서 그대로 재사용한다.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// 영화 목록을 불러오는 중(ConnectionState.waiting)에 보여주는 Loading 상태 화면.
/// 빈 화면 대신 진행 상태를 표시해 앱이 멈추지 않았음을 알린다.
class MovieListLoading extends StatelessWidget {
  const MovieListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
