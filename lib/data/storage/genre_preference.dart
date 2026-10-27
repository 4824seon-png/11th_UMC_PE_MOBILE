// 영화 목록에서 마지막으로 선택한 TMDB 장르 id를 기기에 저장·복원한다 (shared_preferences)
// ─────────────────────────────────────────────────────────────
// [계층]   Data Layer · Storage
//
// [기능]
//   - read()          : 저장된 장르 id (없으면 null = 전체)
//   - save(genreId)   : id 저장, null이면 저장값 삭제(= 전체)
//   - clear()
//
// [동작]
//   SharedPreferencesAsync에 'selected_genre_id' Key로 정수를 저장한다
//   4주차의 'selected_genre'(장르 이름 문자열)와 Key가 달라, 예전 값은 읽지 않는다
//
// [의존성]
//   사용   : shared_preferences
//   사용처 : view_models/movie_list_view_model.dart (복원·저장),
//            router/app_router.dart (생성)
//
// [교체·수정 예정]
//   - 없음.
// ─────────────────────────────────────────────────────────────

import 'package:shared_preferences/shared_preferences.dart';

/// 영화 목록에서 마지막으로 선택한 장르를 기기에 저장·복원한다.
///
/// [5주차] 장르 '이름' 대신 TMDB '장르 id'를 저장한다.
/// - 이름은 language 설정에 따라 바뀌지만('액션' ↔ 'Action') id(28)는 바뀌지 않는다.
/// - '전체'는 id가 없으므로 null로 표현하고, 저장값을 지워서 나타낸다.
///
/// shared_preferences는 보안 저장소가 아니므로 장르처럼 단순하고 중요하지 않은 값만 저장한다.
class GenrePreference {
  // preferences를 받을 수 있게 열어 두면 테스트에서 가짜 저장소를 넣을 수 있다.
  GenrePreference({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  // 읽기·쓰기에 같은 Key를 써야 복원된다.
  static const _selectedGenreIdKey = 'selected_genre_id';

  final SharedPreferencesAsync _preferences;

  /// 저장된 장르 id. 저장한 적이 없거나 '전체'면 null.
  Future<int?> read() {
    return _preferences.getInt(_selectedGenreIdKey);
  }

  /// genreId가 null('전체')이면 저장값을 지운다.
  Future<void> save(int? genreId) async {
    if (genreId == null) {
      await _preferences.remove(_selectedGenreIdKey);
      return;
    }
    await _preferences.setInt(_selectedGenreIdKey, genreId);
  }

  Future<void> clear() async {
    await _preferences.remove(_selectedGenreIdKey);
  }
}
