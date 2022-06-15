import 'dart:convert';

GetIssueTypes getIssueTypesFromJson(String str) => GetIssueTypes.fromJson(json.decode(str));

String getIssueTypesToJson(GetIssueTypes data) => json.encode(data.toJson());

class GetIssueTypes {
  GetIssueTypes({
    required this.expand,
    required this.self,
    required this.id,
    required this.key,
    required this.description,
    required this.lead,
    required this.components,
    required this.issueTypes,
    required this.assigneeType,
    required this.versions,
    required this.name,
    required this.roles,
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
  String description;
  Lead lead;
  List<dynamic> components;
  List<IssueType> issueTypes;
  String assigneeType;
  List<dynamic> versions;
  String name;
  Roles roles;
  AvatarUrls avatarUrls;
  String projectTypeKey;
  bool simplified;
  String style;
  bool isPrivate;
  Properties properties;
  String entityId;
  String uuid;

  factory GetIssueTypes.fromJson(Map<String, dynamic> json) => GetIssueTypes(
    expand: json["expand"],
    self: json["self"],
    id: json["id"],
    key: json["key"],
    description: json["description"],
    lead: Lead.fromJson(json["lead"]),
    components: List<dynamic>.from(json["components"].map((x) => x)),
    issueTypes: List<IssueType>.from(json["issueTypes"].map((x) => IssueType.fromJson(x))),
    assigneeType: json["assigneeType"],
    versions: List<dynamic>.from(json["versions"].map((x) => x)),
    name: json["name"],
    roles: Roles.fromJson(json["roles"]),
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
    "description": description,
    "lead": lead.toJson(),
    "components": List<dynamic>.from(components.map((x) => x)),
    "issueTypes": List<dynamic>.from(issueTypes.map((x) => x.toJson())),
    "assigneeType": assigneeType,
    "versions": List<dynamic>.from(versions.map((x) => x)),
    "name": name,
    "roles": roles.toJson(),
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

class IssueType {
  IssueType({
    required this.self,
    required this.id,
    required this.description,
    required this.iconUrl,
    required this.name,
    required this.subtask,
    required this.avatarId,
    required this.hierarchyLevel,
  });

  String self;
  String id;
  String description;
  String iconUrl;
  String name;
  bool subtask;
  int avatarId;
  int hierarchyLevel;

  factory IssueType.fromJson(Map<String, dynamic> json) => IssueType(
    self: json["self"],
    id: json["id"],
    description: json["description"],
    iconUrl: json["iconUrl"],
    name: json["name"],
    subtask: json["subtask"],
    avatarId: json["avatarId"],
    hierarchyLevel: json["hierarchyLevel"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "id": id,
    "description": description,
    "iconUrl": iconUrl,
    "name": name,
    "subtask": subtask,
    "avatarId": avatarId,
    "hierarchyLevel": hierarchyLevel,
  };
}

class Lead {
  Lead({
    required this.self,
    required this.accountId,
    required this.avatarUrls,
    required this.displayName,
    required this.active,
  });

  String self;
  String accountId;
  AvatarUrls avatarUrls;
  String displayName;
  bool active;

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    self: json["self"],
    accountId: json["accountId"],
    avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
    displayName: json["displayName"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "accountId": accountId,
    "avatarUrls": avatarUrls.toJson(),
    "displayName": displayName,
    "active": active,
  };
}

class Properties {
  Properties();

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Roles {
  Roles({
    required this.atlassianAddonsProjectAccess,
    required this.administrator,
    required this.viewer,
    required this.member,
  });

  String atlassianAddonsProjectAccess;
  String administrator;
  String viewer;
  String member;

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
    atlassianAddonsProjectAccess: json["atlassian-addons-project-access"],
    administrator: json["Administrator"],
    viewer: json["Viewer"],
    member: json["Member"],
  );

  Map<String, dynamic> toJson() => {
    "atlassian-addons-project-access": atlassianAddonsProjectAccess,
    "Administrator": administrator,
    "Viewer": viewer,
    "Member": member,
  };
}
