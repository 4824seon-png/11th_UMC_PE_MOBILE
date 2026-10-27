// 영화 탭 화면: 장르 Chip + TMDB Discover 최대 30개 Grid (MovieListViewModel 구독)
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View
//
// [기능]
//   - MovieListScreen : AppBar(검색 아이콘) + Consumer(Chip 바 + 상태별 영역)
//
// [동작]
//   notifyListeners → Consumer builder 다시 실행
//   → Chip 바: genres·selectedGenreId 표시, isLoading이면 비활성 (미션 7)
//   → switch(status): idle|loading 스피너 / error 다시 시도 / empty 안내 / success Grid
//   Chip 탭 → context.read<MovieListViewModel>().selectGenre(id)
//   다시 시도 → context.read<MovieListViewModel>().retry()
//
// [의존성]
//   사용   : provider, flutter_svg, view_models/movie_list_view_model.dart,
//            widgets/movielog_app_bar.dart, screens/movie_list/widgets/*
//   사용처 : router/app_router.dart (/movies)
//
// [교체·수정 예정]
//   - Challenge: Pull to Refresh, 장르 다중 선택 BottomSheet, 실패 시 재시도 Dialog
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../view_models/movie_list_view_model.dart';
import '../../widgets/movielog_app_bar.dart';
import 'widgets/genre_chip_bar.dart';
import 'widgets/movie_grid.dart';
import 'widgets/movie_list_empty.dart';
import 'widgets/movie_list_error.dart';
import 'widgets/movie_list_loading.dart';

/// 영화 탭 화면.
///
/// [5주차] 상태(장르·영화·로드 상태)와 로직(30개 수집·장르 재조회)은 MovieListViewModel이 가진다.
/// 이 화면은 상태를 읽어 그리고, Chip 선택·재시도 입력만 ViewModel에 전달한다.
/// → 화면 안에 기억할 값이 없으므로 StatelessWidget이다. (4주차: StatefulWidget + FutureBuilder)
class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar는 상태와 무관 → Consumer 밖에 두어 다시 그리지 않는다.
      appBar: MovieLogAppBar(
        title: '영화',
        actions: [
          // Figma W3-02 오른쪽 위 검색 아이콘 (18px, #494551). 검색 기능은 이후 주차 범위.
          IconButton(
            tooltip: '검색',
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('검색 기능은 준비 중이에요.'))),
            // search.svg는 24px 상자 안에 18px 크기의 돋보기가 그려져 있다.
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      // Chip 바와 목록 영역이 모두 ViewModel 상태에 따라 바뀌므로 함께 Consumer로 감싼다.
      body: Consumer<MovieListViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8), // Figma: 본문 위 여백 8
              GenreChipBar(
                genres: viewModel.genres,
                selectedGenreId: viewModel.selectedGenreId,
                // [미션 7] Discover 요청 중에는 장르를 바꿀 수 없다.
                enabled: !viewModel.isLoading,
                // 콜백: 한 번만 호출하므로 watch가 아니라 read.
                onSelected: (genreId) =>
                    context.read<MovieListViewModel>().selectGenre(genreId),
              ),
              // Column 안의 GridView는 높이가 정해져야 한다 → 남은 높이를 전부 준다.
              Expanded(
                // [미션 4] Loading / Error / Empty / Success
                child: switch (viewModel.status) {
                  MovieListLoadStatus.idle ||
                  MovieListLoadStatus.loading => const MovieListLoading(),
                  MovieListLoadStatus.error => MovieListError(
                    message: viewModel.message,
                    onRetry: () => context.read<MovieListViewModel>().retry(),
                  ),
                  MovieListLoadStatus.empty => const MovieListEmpty(),
                  MovieListLoadStatus.success => MovieGrid(
                    movies: viewModel.movies,
                    genreNames: viewModel.genreNames,
                  ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
