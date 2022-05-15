import 'dart:convert';

GetCreatedIssue getCreatedIssueFromJson(String str) => GetCreatedIssue.fromJson(json.decode(str));

String getCreatedIssueToJson(GetCreatedIssue data) => json.encode(data.toJson());

class GetCreatedIssue {
  GetCreatedIssue({
    required this.id,
    required this.key,
    required this.self,
  });

  String id;
  String key;
  String self;

  factory GetCreatedIssue.fromJson(Map<String, dynamic> json) => GetCreatedIssue(
    id: json["id"],
    key: json["key"],
    self: json["self"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "self": self,
  };
}
