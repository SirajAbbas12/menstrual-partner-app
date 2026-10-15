import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  static const _moods = <(String, IconData)>[
    ('Happy', Icons.sentiment_very_satisfied),
    ('Calm', Icons.sentiment_satisfied),
    ('Low', Icons.sentiment_dissatisfied),
    ('Angry', Icons.sentiment_very_dissatisfied),
  ];

  static const _symptoms = [
    'Cramps',
    'Headache',
    'Bloating',
    'Cravings',
    'Nausea',
    'Low energy',
    'Irritable',
    'Back pain',
    'Acne',
    'Tender breasts',
  ];

  int? _mood;
  final Set<String> _selected = {};
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Aaj ka log save ho gaya')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text('Aaj ka log', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text('Mood kaisa hai?', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < _moods.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mood = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _mood == i
                            ? AppColors.rose
                            : AppColors.rose.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(_moods[i].$2,
                              size: 28,
                              color: _mood == i
                                  ? Colors.white
                                  : AppColors.rose),
                          const SizedBox(height: 4),
                          Text(
                            _moods[i].$1,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _mood == i
                                  ? Colors.white
                                  : AppColors.plum,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Symptoms', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in _symptoms)
                FilterChip(
                  label: Text(s),
                  selected: _selected.contains(s),
                  showCheckmark: false,
                  selectedColor: AppColors.rose,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selected.contains(s)
                        ? Colors.white
                        : AppColors.plum,
                  ),
                  side: const BorderSide(color: Color(0xFFF0DDD9)),
                  onSelected: (v) => setState(() {
                    v ? _selected.add(s) : _selected.remove(s);
                  }),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Notes', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          TextField(
            controller: _notes,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Aaj kaisa feel hua? Kuch khaas likhna ho to yahan likho',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFF0DDD9)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFF0DDD9)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: const Text('Save karo')),
        ],
      ),
    );
  }
}
