// [삭제 예정] 개발용 로드 모드(success/empty/failure) 선택 메뉴
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (debug 전용)
//
// [기능]
//   - LoadModeMenu(selected, onSelected) : PopupMenuButton으로 MovieLoadMode 선택
//
// [동작]
//   kDebugMode일 때 영화 탭 AppBar에만 표시된다
//
// [의존성]
//   사용   : data/legacy/fake_movie_service.dart (MovieLoadMode)
//   사용처 : screens/movie_list/movie_list_screen.dart
//
// [교체·수정 예정]
//   - Required: FakeMovieService 제거와 함께 삭제 (Error는 401·네트워크 끊기로 재현)
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../data/legacy/fake_movie_service.dart';

/// 개발용 로드 모드 선택 메뉴 (kDebugMode에서만 표시).
/// Empty·Error 화면과 재시도 흐름을 앱 실행 중에 재현하기 위해 사용한다.
class LoadModeMenu extends StatelessWidget {
  const LoadModeMenu({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MovieLoadMode selected;
  final ValueChanged<MovieLoadMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MovieLoadMode>(
      icon: const Icon(Icons.bug_report_outlined),
      tooltip: '로드 모드 (개발용)',
      onSelected: onSelected,
      itemBuilder: (context) => [
        // MovieLoadMode.values: enum의 모든 값(success, empty, failure)을 순서대로 담은 List
        for (final mode in MovieLoadMode.values)
          CheckedPopupMenuItem(
            value: mode,
            checked: mode == selected, // 현재 모드에 체크 표시
            child: Text(mode.name), // enum 값의 이름 문자열 ('success' 등)
          ),
      ],
    );
  }
}
