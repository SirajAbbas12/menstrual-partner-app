import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../cycle/providers/cycle_provider.dart';

class BabyPlanningCard extends StatelessWidget {
  final CycleSettings settings;
  const BabyPlanningCard({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final last = settings.lastPeriod;
    if (last == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Pehle Home par last period ki date chuno.'),
        ),
      );
    }
    final len = settings.cycleLength;
    final ov = len - 14;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start0 = DateTime(last.year, last.month, last.day);
    final cycles = today.difference(start0).inDays ~/ len;
    var cs = start0.add(Duration(days: cycles * len));
    var ovDate = cs.add(Duration(days: ov - 1));
    if (ovDate.isBefore(today)) {
      cs = cs.add(Duration(days: len));
      ovDate = cs.add(Duration(days: ov - 1));
    }
    final f = DateFormat('d MMM');
    final from = ovDate.subtract(const Duration(days: 5));
    final to = ovDate.add(const Duration(days: 1));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlanRow('Ovulation (andaza)', f.format(ovDate),
                AppColors.ovulation),
            _PlanRow('Zyada sambhavna wale din',
                '${f.format(from)} - ${f.format(to)}', AppColors.ovulation),
            const SizedBox(height: 6),
            const Divider(),
            const SizedBox(height: 6),

            const _Fact(
                'Anda ovulation ke baad lagbhag 24 ghante jeeta hai, aur sperm andar 5 din tak. Isliye koshish ovulation se 2-3 din pehle se shuru karte hain.'),
            const _Fact(
                'Ek achha tareeka: ovulation se 2-3 din pehle se uske agle din tak, roz ya ek din chhod kar.'),
            const _Fact(
                'Sanket: fertile window ke aas-paas cervical mucus anday ki safedi jaisa chipchipa aur khinchne wala ho jata hai.'),
            const _Fact(
                'Ovulation aam taur par agle period se 10 se 16 din pehle hota hai. Ye date sirf andaza hai.'),
            const _Fact(
                'Cycle irregular ya bahut lamba ho (jaise PCOS mein 45 se 60 din), to calendar ka andaza bharosemand nahi hota.'),
            const _Fact(
                'Period ke dauran pregnancy ka chance kam hota hai, par zero nahi, khaaskar chhote ya irregular cycle mein.'),
            const SizedBox(height: 8),
            const Text(
              'Ye general jaankari hai, doctor ki salah nahi. Cycle irregular ho, dard ya bleeding zyada ho, ya kaafi koshish ke baad bhi pregnancy na ho, to doctor se milo.',
              style: TextStyle(
                  fontSize: 12.5, fontStyle: FontStyle.italic, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PlanRow(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  final String text;
  const _Fact(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7, right: 10),
            child: Icon(Icons.circle, size: 6, color: AppColors.rose),
          ),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14.5, height: 1.4)),
          ),
        ],
      ),
    );
  }
}
