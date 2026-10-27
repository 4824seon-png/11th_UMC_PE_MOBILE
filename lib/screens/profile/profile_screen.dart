// 마이 탭 화면: 프로필 헤더, 활동 통계, 선호 장르
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View
//
// [기능]
//   - ProfileScreen  : AppBar + 아래 세 영역
//   - ProfileHeader  : 프로필 이미지·닉네임
//   - ProfileStats   : 본 영화·평점·즐겨찾기 통계 카드 3개 (고정 값)
//   - FavoriteGenres : 선호 장르 Chip (고정 값)
//
// [동작]
//   상태 없는 정적 화면 (StatelessWidget)
//
// [의존성]
//   사용   : flutter_svg, widgets/movielog_app_bar.dart, screens/profile/widgets/stat_item.dart
//   사용처 : router/app_router.dart (/my)
//
// [교체·수정 예정]
//   - 없음 (5주차 범위 밖). 이후 자체 API 연동 시 통계·장르를 실제 값으로 교체한다.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/movielog_app_bar.dart';
import 'widgets/stat_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MovieLogAppBar(title: '내 프로필'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(),
            SizedBox(height: 24),
            ProfileStats(),
            SizedBox(height: 24),
            FavoriteGenres(),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.primary, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile/profile_movielog.jpg',
              width: 120,
              height: 120,
              fit: BoxFit.cover, // 비율을 유지하며 영역을 꽉 채움
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('무비러버', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '매주 주말엔 영화관으로 출근하는 프로 관람객. 좋은 영화를 보고 기록하는 것을 좋아합니다.',
            textAlign: TextAlign.center,
          ),
        ),
        // Margin: 버튼 '바깥'을 띄운다 (소개 문장과의 간격)
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: TextButton(
            onPressed: () {}, // 1주차에는 동작을 연결하지 않습니다.
            style: TextButton.styleFrom(
              side: BorderSide(color: colors.primary),
              // Padding: 버튼 '안쪽'을 띄운다 (테두리와 글자 사이)
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('프로필 수정'),
          ),
        ),
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      // 주축(가로): 카드가 Expanded로 폭을 균등 분배 / 교차축(세로): 위쪽 기준
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: StatItem(label: '본 영화', value: '342')),
        SizedBox(width: 8),
        Expanded(child: StatItem(label: '평점', value: '4.2')),
        SizedBox(width: 8),
        Expanded(child: StatItem(label: '즐겨찾기', value: '58')),
      ],
    );
  }
}

class FavoriteGenres extends StatelessWidget {
  const FavoriteGenres({super.key});

  static const _genres = ['드라마', 'SF', '애니메이션'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start, // 주축: 왼쪽부터
          crossAxisAlignment: CrossAxisAlignment.center, // 교차축: 아이콘·글자 세로 중앙
          children: [
            SvgPicture.asset(
              'assets/icons/movie.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(colors.primary, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text('선호하는 장르', style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final g in _genres) Chip(label: Text(g))],
        ),
      ],
    );
  }
}
