// 영화 목록 Error 상태 화면 (안내 문구 + 다시 시도)
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (영화 목록 전용 위젯)
//
// [기능]
//   - MovieListError(onRetry) : 오류 아이콘 + 고정 문구 + '다시 시도' 버튼
//
// [동작]
//   재시도 시 무엇을 할지는 부모가 onRetry로 전달한다
//
// [의존성]
//   사용   : flutter/material
//   사용처 : screens/movie_list/movie_list_screen.dart
//
// [교체·수정 예정]
//   - Required: ViewModel의 message를 보여주도록 선택 파라미터 추가 가능
//   - Required: onRetry = context.read<MovieListViewModel>()의 재요청
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// 영화 목록을 불러오지 못했을 때의 Error 상태 화면.
///
/// 내부 Exception·StackTrace 대신 고정된 안내 문구를 보여주고,
/// 사용자가 할 수 있는 행동(다시 시도)을 함께 제공한다.
/// 재시도 시 무엇을 할지는 부모가 정하므로 onRetry로 전달받는다.
class MovieListError extends StatelessWidget {
  const MovieListError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Column이 세로 전체를 차지하지 않고 내용만큼만
        children: [
          const Icon(Icons.error_outline),
          const SizedBox(height: 12),
          const Text('영화를 불러오지 못했습니다.'),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
