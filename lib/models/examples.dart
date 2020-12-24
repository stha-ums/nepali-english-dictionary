import 'dart:convert';

class Example {
  Example({
    this.id,
    this.definitionId,
    this.value,
  });

  int id;
  int definitionId;
  String value;

  factory Example.fromRawJson(String str) => Example.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Example.fromJson(Map<String, dynamic> json) => Example(
    id: json["id"],
    definitionId: json["definition_id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "definition_id": definitionId,
    "value": value,
  };
}
