class DailyEntry {
  List<String> good;
  List<String> bad;
  DailyEntry({required this.good, required this.bad});

  // Convert to/from Map for Hive
  factory DailyEntry.fromMap(Map m) => DailyEntry(
    good: List<String>.from(m['good'] ?? []),
    bad: List<String>.from(m['bad'] ?? []),
  );
  Map<String, dynamic> toMap() => {'good': good, 'bad': bad};
}
