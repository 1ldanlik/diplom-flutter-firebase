import 'dart:convert';

GetProjects getProjectsFromJson(String str) => GetProjects.fromJson(json.decode(str));

String getProjectsToJson(GetProjects data) => json.encode(data.toJson());

class GetProjects {
  GetProjects({
    required this.self,
    required this.maxResults,
    required this.startAt,
    required this.total,
    required this.isLast,
    required this.values,
  });

  String self;
  int maxResults;
  int startAt;
  int total;
  bool isLast;
  List<Value> values;

  factory GetProjects.fromJson(Map<String, dynamic> json) => GetProjects(
    self: json["self"],
    maxResults: json["maxResults"],
    startAt: json["startAt"],
    total: json["total"],
    isLast: json["isLast"],
    values: List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "maxResults": maxResults,
    "startAt": startAt,
    "total": total,
    "isLast": isLast,
    "values": List<dynamic>.from(values.map((x) => x.toJson())),
  };
}

class Value {
  Value({
    required this.expand,
    required this.self,
    required this.id,
    required this.key,
    required this.name,
    required this.avatarUrls,
    required this.projectTypeKey,
    required this.simplified,
    required this.style,
    required this.isPrivate,
    required this.properties,
    required this.entityId,
    required this.uuid,
  });

  String expand;
  String self;
  String id;
  String key;
  String name;
  AvatarUrls avatarUrls;
  String projectTypeKey;
  bool simplified;
  String style;
  bool isPrivate;
  Properties properties;
  String entityId;
  String uuid;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    expand: json["expand"],
    self: json["self"],
    id: json["id"],
    key: json["key"],
    name: json["name"],
    avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
    projectTypeKey: json["projectTypeKey"],
    simplified: json["simplified"],
    style: json["style"],
    isPrivate: json["isPrivate"],
    properties: Properties.fromJson(json["properties"]),
    entityId: json["entityId"],
    uuid: json["uuid"],
  );

  Map<String, dynamic> toJson() => {
    "expand": expand,
    "self": self,
    "id": id,
    "key": key,
    "name": name,
    "avatarUrls": avatarUrls.toJson(),
    "projectTypeKey": projectTypeKey,
    "simplified": simplified,
    "style": style,
    "isPrivate": isPrivate,
    "properties": properties.toJson(),
    "entityId": entityId,
    "uuid": uuid,
  };
}

class AvatarUrls {
  AvatarUrls({
    required this.the48X48,
    required this.the24X24,
    required this.the16X16,
    required this.the32X32,
  });

  String the48X48;
  String the24X24;
  String the16X16;
  String the32X32;

  factory AvatarUrls.fromJson(Map<String, dynamic> json) => AvatarUrls(
    the48X48: json["48x48"],
    the24X24: json["24x24"],
    the16X16: json["16x16"],
    the32X32: json["32x32"],
  );

  Map<String, dynamic> toJson() => {
    "48x48": the48X48,
    "24x24": the24X24,
    "16x16": the16X16,
    "32x32": the32X32,
  };
}

class Properties {
  Properties();

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
  );

  Map<String, dynamic> toJson() => {
  };
}
