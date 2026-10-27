// 앱의 모든 경로(URL)와 화면을 연결하고, 화면별 ViewModel을 생성하는 라우터
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · 라우팅
//
// [기능]
//   - /start, /register                : 탭 없는 화면
//   - ShellRoute(/home, /movies, /my)  : MainScreen(하단 탭) 안에 표시
//   - /movies/:movieId                 : 상세 화면 (URL = TMDB id, extra = TmdbMovieDto)
//   - indexFromLocation(path)          : URL → 하단 탭 번호
//
// [동작]
//   /home   → ChangeNotifierProvider(MovieHomeViewModel..loadPopular())
//   /movies → ChangeNotifierProvider(MovieListViewModel(service, GenrePreference())..loadInitial())
//   create는 화면 수명 동안 1번, 화면을 떠나면 ViewModel dispose 자동 호출
//   /movies/:movieId → state.extra가 TmdbMovieDto일 때만 상세 화면에 전달
//
// [의존성]
//   사용   : go_router, provider, screens/*, view_models/*,
//            data/services/tmdb_movie_service.dart, data/storage/genre_preference.dart,
//            data/models/tmdb_movie_dto.dart
//   사용처 : app/movie_log_app.dart (routerConfig)
//
// [교체·수정 예정]
//   - 이후: 상세 화면을 TMDB 상세 API로 바꾸면 extra 없이 id만 전달
// ─────────────────────────────────────────────────────────────

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/models/tmdb_movie_dto.dart';
import '../data/services/tmdb_movie_service.dart';
import '../data/storage/genre_preference.dart';
import '../screens/home/home_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/movie_detail/movie_detail_screen.dart';
import '../screens/movie_list/movie_list_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/register/register_screen.dart';
import '../screens/start/start_screen.dart';
import '../view_models/movie_home_view_model.dart';
import '../view_models/movie_list_view_model.dart';

/// 앱의 모든 경로(URL)와 화면의 연결을 한 곳에서 관리한다.
class AppRouter {
  // private 생성자: 인스턴스를 만들지 않고 AppRouter.router처럼 사용하는 네임스페이스 클래스.
  AppRouter._();

  // static final: 처음 접근할 때 한 번만 생성된다.
  // build 안에서 만들면 rebuild마다 새 라우터가 생겨 현재 위치가 초기화된다.
  static final router = GoRouter(
    // 앱 첫 화면. MaterialApp.home 대신 여기서 결정한다.
    initialLocation: '/start',
    routes: [
      // ── ShellRoute 밖: NavigationBar가 없는 화면 ──
      GoRoute(path: '/start', builder: (context, state) => const StartScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── ShellRoute: 하위 route들에 MainScreen(NavigationBar)을 공통으로 씌운다 ──
      // builder의 child = 현재 URL에 매칭된 하위 화면(안쪽 Navigator).
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(
            // 선택된 탭 번호를 상태로 들고 있지 않고 URL에서 계산한다.
            currentIndex: indexFromLocation(state.uri.path),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            // [5주차] 홈 화면 전용 ViewModel을 이 Route에서 만든다.
            // create는 화면에 처음 들어올 때 한 번만 실행되고(rebuild마다 X),
            // 화면이 사라지면 ChangeNotifierProvider가 dispose를 호출한다.
            builder: (context, state) => ChangeNotifierProvider(
              // 캐스케이드(..): 생성 직후 첫 요청을 보내고, create의 반환값은 ViewModel 자신
              create: (context) =>
                  MovieHomeViewModel(context.read<TmdbMovieService>())
                    ..loadPopular(),
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/movies',
            // [5주차 Required] 영화 탭 전용 ViewModel.
            // GenrePreference는 영화 탭에서만 쓰므로 여기서 만들어 생성자로 주입한다.
            builder: (context, state) => ChangeNotifierProvider(
              create: (context) => MovieListViewModel(
                context.read<TmdbMovieService>(),
                GenrePreference(),
              )..loadInitial(),
              child: const MovieListScreen(),
            ),
          ),
          GoRoute(
            path: '/my',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // 상세 화면에는 NavigationBar가 없으므로 ShellRoute 밖에 둔다.
      // 탭 화면에서 push하면 루트 스택이 [MainScreen, MovieDetailScreen]이 되고,
      // pop하면 원래 탭으로 돌아간다.
      GoRoute(
        // ':movieId' = Path Parameter. 아래 pathParameters의 key와 철자가 같아야 한다.
        path: '/movies/:movieId',
        builder: (context, state) {
          // [미션 8] extra = push할 때 함께 넘긴 영화. URL에 남지 않아 딥링크에서는 null.
          // as로 강제 변환하지 않고 is로 확인한다 → 다른 타입이 와도 앱이 죽지 않는다.
          final extra = state.extra;
          return MovieDetailScreen(
            // URL 값은 항상 String → int로 변환한다. 숫자가 아니면 null.
            movieId: int.tryParse(state.pathParameters['movieId'] ?? ''),
            movie: extra is TmdbMovieDto ? extra : null,
          );
        },
      ),
    ],
  );

  /// 현재 경로를 NavigationBar의 탭 번호로 변환한다.
  /// 순서는 MainScreen의 destinations 순서(홈 0, 영화 1, 마이 2)와 일치해야 한다.
  static int indexFromLocation(String path) {
    // == 대신 startsWith: '/movies/…' 같은 하위 경로도 영화 탭으로 본다.
    if (path.startsWith('/movies')) return 1;
    if (path.startsWith('/my')) return 2;

    return 0; // 기본값: 홈
  }
}
