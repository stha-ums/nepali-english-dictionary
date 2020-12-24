import 'dart:convert';

class EnglishWord {
  EnglishWord({
    this.rowid,
    this.enWord,
    this.enDefinition,
    this.example,
    this.synonyms,
    this.antonyms,
  });

  int rowid;
  String enWord;
  String enDefinition;
  String example;
  String synonyms;
  String antonyms;

  factory EnglishWord.fromRawJson(String str) => EnglishWord.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EnglishWord.fromJson(Map<String, dynamic> json) => EnglishWord(
    rowid: json["rowid"],
    enWord: json["en_word"],
    enDefinition: json["en_definition"],
    example: json["example"],
    synonyms: json["synonyms"],
    antonyms: json["antonyms"],
  );

  Map<String, dynamic> toJson() => {
    "rowid": rowid,
    "en_word": enWord,
    "en_definition": enDefinition,
    "example": example,
    "synonyms": synonyms,
    "antonyms": antonyms,
  };
}
