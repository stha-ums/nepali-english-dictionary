import 'dart:convert';

class Definition {
  Definition({
    this.id,
    this.wordId,
    this.value,
  });

  int id;
  int wordId;
  String value;

  factory Definition.fromRawJson(String str) => Definition.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
    id: json["id"],
    wordId: json["word_id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "word_id": wordId,
    "value": value,
  };
}
