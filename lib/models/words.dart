import 'dart:convert';

class Word {
  Word({
    this.id,
    this.value,
    this.partOfSpeech,
  });

  int id;
  String value;
  String partOfSpeech;

  factory Word.fromRawJson(String str) => Word.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        id: json["id"],
        value: json["value"],
        partOfSpeech: json["part_of_speech"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "part_of_speech": partOfSpeech,
      };
}
