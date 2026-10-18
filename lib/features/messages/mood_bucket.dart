enum MoodBucket {
  periodHeavy,
  periodEase,
  fresh,
  ovulation,
  pmsEarly,
  pmsPeak,
}

MoodBucket bucketFor(int day, int len) {
  final ov = len - 14;
  if (day <= 2) return MoodBucket.periodHeavy;
  if (day <= 5) return MoodBucket.periodEase;
  if (day >= ov - 1 && day <= ov + 1) return MoodBucket.ovulation;
  if (day < ov - 1) return MoodBucket.fresh;
  final peakStart = (len - 6) > (ov + 2) ? (len - 6) : (ov + 2);
  return day >= peakStart ? MoodBucket.pmsPeak : MoodBucket.pmsEarly;
}
