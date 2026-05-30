class FillRateModel {
  final int total;
  final int filled;
  final List<String> missingPlayers;

  const FillRateModel({
    required this.total,
    required this.filled,
    required this.missingPlayers,
  });

  double get percentage => total == 0 ? 0 : (filled / total) * 100;
  int get missing => total - filled;
}
