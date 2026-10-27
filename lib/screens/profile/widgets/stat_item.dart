// 라벨과 값을 보여주는 통계 카드 1개
// ─────────────────────────────────────────────────────────────
// [계층]   UI Layer · View (프로필 전용 위젯)
//
// [기능]
//   - StatItem(label, value) : 라벨 + 강조 색 값
//
// [동작]
//   데이터만 바꿔 같은 카드를 재사용한다
//
// [의존성]
//   사용   : flutter/material
//   사용처 : screens/profile/profile_screen.dart
//
// [교체·수정 예정]
//   - 없음.
// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// 라벨과 값을 보여주는 통계 카드 1개. 데이터만 바꿔 재사용한다.
class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(color: colors.primary),
          ),
        ],
      ),
    );
  }
}
