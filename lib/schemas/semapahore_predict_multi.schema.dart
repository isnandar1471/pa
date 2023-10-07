import 'dart:convert';

class SemaphorePredictMulti {
  List<Result> result;

  SemaphorePredictMulti({
    required this.result,
  });

  SemaphorePredictMulti copyWith({
    List<Result>? result,
  }) =>
      SemaphorePredictMulti(
        result: result ?? this.result,
      );

  factory SemaphorePredictMulti.fromJson(String str) => SemaphorePredictMulti.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SemaphorePredictMulti.fromMap(Map<String, dynamic> json) => SemaphorePredictMulti(
        result: List<Result>.from(json["result"].map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "result": List<dynamic>.from(result.map((x) => x.toMap())),
      };
}

class Result {
  String fileName;
  List<Ranking> ranking;

  Result({
    required this.fileName,
    required this.ranking,
  });

  Result copyWith({
    String? imageUrl,
    List<Ranking>? ranking,
  }) =>
      Result(
        fileName: imageUrl ?? this.fileName,
        ranking: ranking ?? this.ranking,
      );

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        fileName: json["filename"],
        ranking: List<Ranking>.from(json["ranking"].map((x) => Ranking.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "filename": fileName,
        "ranking": List<dynamic>.from(ranking.map((x) => x.toMap())),
      };
}

class Ranking {
  int rank;
  String value;
  double probability;

  Ranking({
    required this.rank,
    required this.value,
    required this.probability,
  });

  Ranking copyWith({
    int? rank,
    String? value,
    double? probability,
  }) =>
      Ranking(
        rank: rank ?? this.rank,
        value: value ?? this.value,
        probability: probability ?? this.probability,
      );

  factory Ranking.fromJson(String str) => Ranking.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ranking.fromMap(Map<String, dynamic> json) => Ranking(
        rank: json["rank"],
        value: json["value"],
        probability: json["probability"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "rank": rank,
        "value": value,
        "probability": probability,
      };
}
