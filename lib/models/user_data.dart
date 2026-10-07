class UserData {
  final DateTime quitDate;
  final int cigarettesPerDay;
  final double pricePerPack;
  final int cigarettesInPack;
  final bool isTakingCytisine;
  final DateTime? cytisineStartDate;

  UserData({
    required this.quitDate,
    required this.cigarettesPerDay,
    required this.pricePerPack,
    required this.cigarettesInPack,
    required this.isTakingCytisine,
    this.cytisineStartDate,
  });

  Map<String, dynamic> toJson() => {
        'quitDate': quitDate.toIso8601String(),
        'cigarettesPerDay': cigarettesPerDay,
        'pricePerPack': pricePerPack,
        'cigarettesInPack': cigarettesInPack,
        'isTakingCytisine': isTakingCytisine,
        'cytisineStartDate': cytisineStartDate?.toIso8601String(),
      };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        quitDate: DateTime.parse(json['quitDate']),
        cigarettesPerDay: json['cigarettesPerDay'],
        pricePerPack: json['pricePerPack'],
        cigarettesInPack: json['cigarettesInPack'],
        isTakingCytisine: json['isTakingCytisine'] ?? false,
        cytisineStartDate: json['cytisineStartDate'] != null
            ? DateTime.parse(json['cytisineStartDate'])
            : null,
      );
}
