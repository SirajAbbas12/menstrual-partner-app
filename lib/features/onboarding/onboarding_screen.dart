import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../core/storage/local_store.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_shell.dart';
import '../cycle/providers/cycle_provider.dart';
import '../notifications/notification_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  String _role = 'partner';
  String _relation = 'partner';
  DateTime? _date;
  double _len = 28;

  bool get _isPartner => _role == 'partner';

  void _go(int s) => setState(() => _step = s);

  Future<void> _finish(bool notif) async {
    final d = _date ?? DateTime.now();
    await LocalStore.saveProfile(_role, _relation);
    await ref.read(cycleProvider.notifier).save(d, _len.round());
    if (notif) {
      final ok = await NotificationService.requestPermission();
      if (ok) await Hive.box('settings').put('notifOn', true);
    }
    await LocalStore.setOnboarded();
    await NotificationService.refresh();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget body;
    switch (_step) {
      case 0:
        body = _stepRole(theme);
        break;
      case 1:
        body = _stepRelation(theme);
        break;
      case 2:
        body = _stepDate(theme);
        break;
      default:
        body = _stepNotif(theme);
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(24), child: body),
      ),
    );
  }

  Widget _stepRole(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Icon(Icons.favorite, size: 40, color: AppColors.rose),
          const SizedBox(height: 16),
          Text('Cycle Partner mein swagat hai',
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Aap kaun ho?'),
          const SizedBox(height: 20),
          _Choice(
            icon: Icons.favorite_border,
            title: 'Main partner hun',
            sub: 'Uska cycle samajhna aur saath dena chahta hun',
            onTap: () {
              _role = 'partner';
              _go(1);
            },
          ),
          const SizedBox(height: 12),
          _Choice(
            icon: Icons.person_outline,
            title: 'Main khud apna cycle track karti hun',
            sub: 'Apne cycle ka dhyan rakhna chahti hun',
            onTap: () {
              _role = 'self';
              _go(2);
            },
          ),
          const Spacer(),
        ],
      );

  Widget _stepRelation(ThemeData theme) {
    const items = <(String, String)>[
      ('husband', 'Husband'),
      ('boyfriend', 'Boyfriend'),
      ('wife', 'Wife'),
      ('girlfriend', 'Girlfriend'),
      ('partner', 'Partner'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => _go(0),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Peeche'),
        ),
        const Spacer(),
        Text('Aap uske kya lagte ho?', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final it in items)
              ChoiceChip(
                label: Text(it.$2),
                selected: _relation == it.$1,
                onSelected: (_) {
                  _relation = it.$1;
                  _go(2);
                },
              ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _stepDate(ThemeData theme) {
    final f = DateFormat('d MMM yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => _go(_isPartner ? 1 : 0),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Peeche'),
        ),
        const SizedBox(height: 8),
        Text('Cycle ki jaankari', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        const Text('Last period kab shuru hua?'),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final now = DateTime.now();
            final p = await showDatePicker(
              context: context,
              initialDate: _date ?? now,
              firstDate: now.subtract(const Duration(days: 120)),
              lastDate: now,
            );
            if (p != null) setState(() => _date = p);
          },
          icon: const Icon(Icons.event),
          label: Text(_date == null ? 'Date chuno' : f.format(_date!)),
        ),
        const SizedBox(height: 20),
        Text('Cycle kitne din ka hai? ${_len.round()} din'),
        Slider(
          min: 21,
          max: 45,
          divisions: 24,
          value: _len,
          onChanged: (v) => setState(() => _len = v),
        ),
        const Text('Pata na ho to 28 rehne do. Baad mein badal sakte ho.',
            style: TextStyle(fontSize: 12.5)),
        if (_isPartner) ...[
          const SizedBox(height: 12),
          const Text('Ye jaankari unki ijazat se daalo.',
              style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic)),
        ],
        const Spacer(),
        FilledButton(
          onPressed: _date == null ? null : () => _go(3),
          child: const Text('Aage'),
        ),
      ],
    );
  }

  Widget _stepNotif(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () => _go(2),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Peeche'),
          ),
          const Spacer(),
          const Icon(Icons.notifications_active_outlined,
              size: 40, color: AppColors.rose),
          const SizedBox(height: 16),
          Text('Roz ek caring message bhejun?',
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
              'Roz raat 9 baje, aaj ke mood ke hisaab se ek chhota message. Samay baad mein badal sakte ho.'),
          const Spacer(),
          FilledButton(
            onPressed: () => _finish(true),
            child: const Text('Haan, bhejo'),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => _finish(false),
              child: const Text('Abhi nahi'),
            ),
          ),
        ],
      );
}

class _Choice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;
  const _Choice({
    required this.icon,
    required this.title,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blushDeep,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.rose, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15.5, fontWeight: FontWeight.w700)),
                    Text(sub, style: const TextStyle(fontSize: 13)),
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
