import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'situations_screen.dart';

class GuideShortcuts extends StatelessWidget {
  const GuideShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Tile(
          icon: Icons.forum_outlined,
          title: 'Abhi kya ho raha hai?',
          sub: 'Chidchida, rona, dard: kya bolo, kya mat bolo',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SituationsScreen()),
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;
  const _Tile({
    required this.icon,
    required this.title,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blushDeep,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.rose),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    Text(sub, style: const TextStyle(fontSize: 12.5)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
