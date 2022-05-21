// To parse this JSON data, do
//
//     final getIssues = getIssuesFromJson(jsonString);

import 'dart:convert';

GetIssues getIssuesFromJson(String str) => GetIssues.fromJson(json.decode(str));

String getIssuesToJson(GetIssues data) => json.encode(data.toJson());

class GetIssues {
  GetIssues({
    required this.expand,
    required this.startAt,
    required this.maxResults,
    required this.total,
    required this.issues,
  });

  String expand;
  int startAt;
  int maxResults;
  int total;
  List<Issue> issues;

  factory GetIssues.fromJson(Map<String, dynamic> json) => GetIssues(
    expand: json["expand"],
    startAt: json["startAt"],
    maxResults: json["maxResults"],
    total: json["total"],
    issues: List<Issue>.from(json["issues"].map((x) => Issue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "expand": expand,
    "startAt": startAt,
    "maxResults": maxResults,
    "total": total,
    "issues": List<dynamic>.from(issues.map((x) => x.toJson())),
  };
}

class Issue {
  Issue({
    required this.expand,
    required this.id,
    required this.self,
    required this.key,
    required this.fields,
  });

  String expand;
  String id;
  String self;
  String key;
  Fields fields;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
    expand: json["expand"],
    id: json["id"],
    self: json["self"],
    key: json["key"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "expand": expand,
    "id": id,
    "self": self,
    "key": key,
    "fields": fields.toJson(),
  };
}

class Fields {
  Fields({
    required this.statuscategorychangedate,
    required this.issuetype,
    required this.timespent,
    required this.project,
    required this.fixVersions,
    required this.aggregatetimespent,
    required this.resolution,
    required this.resolutiondate,
    required this.workratio,
    required this.watches,
    required this.lastViewed,
    required this.created,
    required this.customfield10020,
    required this.customfield10021,
    required this.customfield10022,
    required this.customfield10023,
    required this.priority,
    required this.customfield10024,
    required this.customfield10025,
    required this.labels,
    required this.customfield10016,
    required this.customfield10017,
    required this.customfield10018,
    required this.customfield10019,
    required this.timeestimate,
    required this.aggregatetimeoriginalestimate,
    required this.versions,
    required this.issuelinks,
    required this.assignee,
    required this.updated,
    required this.status,
    required this.components,
    required this.timeoriginalestimate,
    required this.description,
    required this.customfield10010,
    required this.customfield10014,
    required this.customfield10015,
    required this.customfield10005,
    required this.customfield10006,
    required this.customfield10007,
    required this.security,
    required this.customfield10008,
    required this.customfield10009,
    required this.aggregatetimeestimate,
    required this.summary,
    required this.creator,
    required this.subtasks,
    required this.reporter,
    required this.aggregateprogress,
    required this.customfield10000,
    required this.customfield10001,
    required this.customfield10002,
    required this.customfield10003,
    required this.customfield10004,
    required this.environment,
    required this.duedate,
    required this.progress,
    required this.votes,
  });

  String statuscategorychangedate;
  Issuetype issuetype;
  dynamic timespent;
  Project project;
  List<dynamic> fixVersions;
  dynamic aggregatetimespent;
  dynamic resolution;
  dynamic resolutiondate;
  int workratio;
  Watches watches;
  String lastViewed;
  String created;
  List<Customfield10020>? customfield10020;
  dynamic customfield10021;
  dynamic customfield10022;
  dynamic customfield10023;
  Priority priority;
  dynamic customfield10024;
  dynamic customfield10025;
  List<dynamic> labels;
  dynamic customfield10016;
  dynamic customfield10017;
  Customfield10018 customfield10018;
  String customfield10019;
  dynamic timeestimate;
  dynamic aggregatetimeoriginalestimate;
  List<dynamic> versions;
  List<dynamic> issuelinks;
  dynamic assignee;
  String updated;
  Status status;
  List<dynamic> components;
  dynamic timeoriginalestimate;
  String description;
  dynamic customfield10010;
  dynamic customfield10014;
  dynamic customfield10015;
  dynamic customfield10005;
  dynamic customfield10006;
  dynamic customfield10007;
  dynamic security;
  dynamic customfield10008;
  dynamic customfield10009;
  dynamic aggregatetimeestimate;
  String summary;
  Creator creator;
  List<dynamic> subtasks;
  Creator reporter;
  Progress aggregateprogress;
  Customfield10000? customfield10000;
  dynamic customfield10001;
  dynamic customfield10002;
  dynamic customfield10003;
  dynamic customfield10004;
  dynamic environment;
  dynamic duedate;
  Progress progress;
  Votes votes;

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    statuscategorychangedate: json["statuscategorychangedate"],
    issuetype: Issuetype.fromJson(json["issuetype"]),
    timespent: json["timespent"],
    project: Project.fromJson(json["project"]),
    fixVersions: List<dynamic>.from(json["fixVersions"].map((x) => x)),
    aggregatetimespent: json["aggregatetimespent"],
    resolution: json["resolution"],
    resolutiondate: json["resolutiondate"],
    workratio: json["workratio"],
    watches: Watches.fromJson(json["watches"]),
    lastViewed: json["lastViewed"] == null ? null : json["lastViewed"],
    created: json["created"],
    customfield10020: json["customfield_10020"] == null ? null : List<Customfield10020>.from(json["customfield_10020"].map((x) => Customfield10020.fromJson(x))),
    customfield10021: json["customfield_10021"],
    customfield10022: json["customfield_10022"],
    customfield10023: json["customfield_10023"],
    priority: Priority.fromJson(json["priority"]),
    customfield10024: json["customfield_10024"],
    customfield10025: json["customfield_10025"],
    labels: List<dynamic>.from(json["labels"].map((x) => x)),
    customfield10016: json["customfield_10016"],
    customfield10017: json["customfield_10017"],
    customfield10018: Customfield10018.fromJson(json["customfield_10018"]),
    customfield10019: json["customfield_10019"],
    timeestimate: json["timeestimate"],
    aggregatetimeoriginalestimate: json["aggregatetimeoriginalestimate"],
    versions: List<dynamic>.from(json["versions"].map((x) => x)),
    issuelinks: List<dynamic>.from(json["issuelinks"].map((x) => x)),
    assignee: json["assignee"],
    updated: json["updated"],
    status: Status.fromJson(json["status"]),
    components: List<dynamic>.from(json["components"].map((x) => x)),
    timeoriginalestimate: json["timeoriginalestimate"],
    description: json["description"] == null ? null : json["description"],
    customfield10010: json["customfield_10010"],
    customfield10014: json["customfield_10014"],
    customfield10015: json["customfield_10015"],
    customfield10005: json["customfield_10005"],
    customfield10006: json["customfield_10006"],
    customfield10007: json["customfield_10007"],
    security: json["security"],
    customfield10008: json["customfield_10008"],
    customfield10009: json["customfield_10009"],
    aggregatetimeestimate: json["aggregatetimeestimate"],
    summary: json["summary"],
    creator: Creator.fromJson(json["creator"]),
    subtasks: List<dynamic>.from(json["subtasks"].map((x) => x)),
    reporter: Creator.fromJson(json["reporter"]),
    aggregateprogress: Progress.fromJson(json["aggregateprogress"]),
    customfield10000: customfield10000Values.map[json["customfield_10000"]],
    customfield10001: json["customfield_10001"],
    customfield10002: json["customfield_10002"],
    customfield10003: json["customfield_10003"],
    customfield10004: json["customfield_10004"],
    environment: json["environment"],
    duedate: json["duedate"],
    progress: Progress.fromJson(json["progress"]),
    votes: Votes.fromJson(json["votes"]),
  );

  Map<String, dynamic> toJson() => {
    "statuscategorychangedate": statuscategorychangedate,
    "issuetype": issuetype.toJson(),
    "timespent": timespent,
    "project": project.toJson(),
    "fixVersions": List<dynamic>.from(fixVersions.map((x) => x)),
    "aggregatetimespent": aggregatetimespent,
    "resolution": resolution,
    "resolutiondate": resolutiondate,
    "workratio": workratio,
    "watches": watches.toJson(),
    "lastViewed": lastViewed == null ? null : lastViewed,
    "created": created,
    "customfield_10020": customfield10020 == null ? null : List<dynamic>.from(customfield10020!.map((x) => x.toJson())),
    "customfield_10021": customfield10021,
    "customfield_10022": customfield10022,
    "customfield_10023": customfield10023,
    "priority": priority.toJson(),
    "customfield_10024": customfield10024,
    "customfield_10025": customfield10025,
    "labels": List<dynamic>.from(labels.map((x) => x)),
    "customfield_10016": customfield10016,
    "customfield_10017": customfield10017,
    "customfield_10018": customfield10018.toJson(),
    "customfield_10019": customfield10019,
    "timeestimate": timeestimate,
    "aggregatetimeoriginalestimate": aggregatetimeoriginalestimate,
    "versions": List<dynamic>.from(versions.map((x) => x)),
    "issuelinks": List<dynamic>.from(issuelinks.map((x) => x)),
    "assignee": assignee,
    "updated": updated,
    "status": status.toJson(),
    "components": List<dynamic>.from(components.map((x) => x)),
    "timeoriginalestimate": timeoriginalestimate,
    "description": description == null ? null : description,
    "customfield_10010": customfield10010,
    "customfield_10014": customfield10014,
    "customfield_10015": customfield10015,
    "customfield_10005": customfield10005,
    "customfield_10006": customfield10006,
    "customfield_10007": customfield10007,
    "security": security,
    "customfield_10008": customfield10008,
    "customfield_10009": customfield10009,
    "aggregatetimeestimate": aggregatetimeestimate,
    "summary": summary,
    "creator": creator.toJson(),
    "subtasks": List<dynamic>.from(subtasks.map((x) => x)),
    "reporter": reporter.toJson(),
    "aggregateprogress": aggregateprogress.toJson(),
    "customfield_10000": customfield10000Values.reverse[customfield10000],
    "customfield_10001": customfield10001,
    "customfield_10002": customfield10002,
    "customfield_10003": customfield10003,
    "customfield_10004": customfield10004,
    "environment": environment,
    "duedate": duedate,
    "progress": progress.toJson(),
    "votes": votes.toJson(),
  };
}

class Progress {
  Progress({
    required this.progress,
    required this.total,
  });

  int progress;
  int total;

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    progress: json["progress"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "progress": progress,
    "total": total,
  };
}

class Creator {
  Creator({
    required this.self,
    required this.accountId,
    required this.emailAddress,
    required this.avatarUrls,
    required this.displayName,
    required this.active,
    required this.timeZone,
    required this.accountType,
  });

  String self;
  AccountId? accountId;
  EmailAddress? emailAddress;
  AvatarUrls avatarUrls;
  DisplayName? displayName;
  bool active;
  TimeZone? timeZone;
  AccountType? accountType;

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
    self: json["self"],
    accountId: accountIdValues.map[json["accountId"]],
    emailAddress: emailAddressValues.map[json["emailAddress"]],
    avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
    displayName: displayNameValues.map[json["displayName"]],
    active: json["active"],
    timeZone: timeZoneValues.map[json["timeZone"]],
    accountType: accountTypeValues.map[json["accountType"]],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "accountId": accountIdValues.reverse[accountId],
    "emailAddress": emailAddressValues.reverse[emailAddress],
    "avatarUrls": avatarUrls.toJson(),
    "displayName": displayNameValues.reverse[displayName],
    "active": active,
    "timeZone": timeZoneValues.reverse[timeZone],
    "accountType": accountTypeValues.reverse[accountType],
  };
}

enum AccountId { THE_626_D357_A1_A4_EB30069_D32730 }

final accountIdValues = EnumValues({
  "626d357a1a4eb30069d32730": AccountId.THE_626_D357_A1_A4_EB30069_D32730
});

enum AccountType { ATLASSIAN }

final accountTypeValues = EnumValues({
  "atlassian": AccountType.ATLASSIAN
});

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

enum DisplayName { ILDAN }

final displayNameValues = EnumValues({
  "ildan": DisplayName.ILDAN
});

enum EmailAddress { DAWANI2016_MAIL_RU }

final emailAddressValues = EnumValues({
  "dawani2016@mail.ru": EmailAddress.DAWANI2016_MAIL_RU
});

enum TimeZone { ETC_GMT }

final timeZoneValues = EnumValues({
  "Etc/GMT": TimeZone.ETC_GMT
});

enum Customfield10000 { EMPTY }

final customfield10000Values = EnumValues({
  "{}": Customfield10000.EMPTY
});

class Customfield10018 {
  Customfield10018({
    required this.hasEpicLinkFieldDependency,
    required this.showField,
    required this.nonEditableReason,
  });

  bool hasEpicLinkFieldDependency;
  bool showField;
  NonEditableReason nonEditableReason;

  factory Customfield10018.fromJson(Map<String, dynamic> json) => Customfield10018(
    hasEpicLinkFieldDependency: json["hasEpicLinkFieldDependency"],
    showField: json["showField"],
    nonEditableReason: NonEditableReason.fromJson(json["nonEditableReason"]),
  );

  Map<String, dynamic> toJson() => {
    "hasEpicLinkFieldDependency": hasEpicLinkFieldDependency,
    "showField": showField,
    "nonEditableReason": nonEditableReason.toJson(),
  };
}

class NonEditableReason {
  NonEditableReason({
    required this.reason,
    required this.message,
  });

  Reason? reason;
  Message? message;

  factory NonEditableReason.fromJson(Map<String, dynamic> json) => NonEditableReason(
    reason: reasonValues.map[json["reason"]],
    message: messageValues.map[json["message"]],
  );

  Map<String, dynamic> toJson() => {
    "reason": reasonValues.reverse[reason],
    "message": messageValues.reverse[message],
  };
}

enum Message { THE_PARENT_LINK_IS_ONLY_AVAILABLE_TO_JIRA_PREMIUM_USERS }

final messageValues = EnumValues({
  "The Parent Link is only available to Jira Premium users.": Message.THE_PARENT_LINK_IS_ONLY_AVAILABLE_TO_JIRA_PREMIUM_USERS
});

enum Reason { PLUGIN_LICENSE_ERROR }

final reasonValues = EnumValues({
  "PLUGIN_LICENSE_ERROR": Reason.PLUGIN_LICENSE_ERROR
});

class Customfield10020 {
  Customfield10020({
    required this.id,
    required this.name,
    required this.state,
    required this.boardId,
    required this.goal,
    required this.startDate,
    required this.endDate,
  });

  int id;
  String name;
  String state;
  int boardId;
  String goal;
  DateTime startDate;
  DateTime endDate;

  factory Customfield10020.fromJson(Map<String, dynamic> json) => Customfield10020(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    boardId: json["boardId"],
    goal: json["goal"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "boardId": boardId,
    "goal": goal,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
  };
}

class Issuetype {
  Issuetype({
    required this.self,
    required this.id,
    required this.description,
    required this.iconUrl,
    required this.name,
    required this.subtask,
    required this.avatarId,
    required this.entityId,
    required this.hierarchyLevel,
  });

  String self;
  String id;
  Description? description;
  String iconUrl;
  IssuetypeName? name;
  bool subtask;
  int avatarId;
  String entityId;
  int hierarchyLevel;

  factory Issuetype.fromJson(Map<String, dynamic> json) => Issuetype(
    self: json["self"],
    id: json["id"],
    description: descriptionValues.map[json["description"]],
    iconUrl: json["iconUrl"],
    name: issuetypeNameValues.map[json["name"]],
    subtask: json["subtask"],
    avatarId: json["avatarId"],
    entityId: json["entityId"],
    hierarchyLevel: json["hierarchyLevel"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "id": id,
    "description": descriptionValues.reverse[description],
    "iconUrl": iconUrl,
    "name": issuetypeNameValues.reverse[name],
    "subtask": subtask,
    "avatarId": avatarId,
    "entityId": entityId,
    "hierarchyLevel": hierarchyLevel,
  };
}

enum Description { TASKS_TRACK_SMALL_DISTINCT_PIECES_OF_WORK }

final descriptionValues = EnumValues({
  "Tasks track small, distinct pieces of work.": Description.TASKS_TRACK_SMALL_DISTINCT_PIECES_OF_WORK
});

enum IssuetypeName { TASK }

final issuetypeNameValues = EnumValues({
  "Task": IssuetypeName.TASK
});

class Priority {
  Priority({
    required this.self,
    required this.iconUrl,
    required this.name,
    required this.id,
  });

  String self;
  String iconUrl;
  PriorityName? name;
  String id;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
    self: json["self"],
    iconUrl: json["iconUrl"],
    name: priorityNameValues.map[json["name"]],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "iconUrl": iconUrl,
    "name": priorityNameValues.reverse[name],
    "id": id,
  };
}

enum PriorityName {HIGHEST, HIGH, MEDIUM, LOW, LOWEST }

final priorityNameValues = EnumValues({
  "Highest": PriorityName.HIGHEST,
  "High": PriorityName.HIGH,
  "Medium": PriorityName.MEDIUM,
  "Low": PriorityName.LOW,
  "Lowest": PriorityName.LOWEST
});

class Project {
  Project({
    required this.self,
    required this.id,
    required this.key,
    required this.name,
    required this.projectTypeKey,
    required this.simplified,
    required this.avatarUrls,
  });

  String self;
  String id;
  NameEnum? key;
  NameEnum? name;
  ProjectTypeKey? projectTypeKey;
  bool simplified;
  AvatarUrls avatarUrls;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    self: json["self"],
    id: json["id"],
    key: nameEnumValues.map[json["key"]],
    name: nameEnumValues.map[json["name"]],
    projectTypeKey: projectTypeKeyValues.map[json["projectTypeKey"]],
    simplified: json["simplified"],
    avatarUrls: AvatarUrls.fromJson(json["avatarUrls"]),
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "id": id,
    "key": nameEnumValues.reverse[key],
    "name": nameEnumValues.reverse[name],
    "projectTypeKey": projectTypeKeyValues.reverse[projectTypeKey],
    "simplified": simplified,
    "avatarUrls": avatarUrls.toJson(),
  };
}

enum NameEnum { GEEK }

final nameEnumValues = EnumValues({
  "GEEK": NameEnum.GEEK
});

enum ProjectTypeKey { SOFTWARE }

final projectTypeKeyValues = EnumValues({
  "software": ProjectTypeKey.SOFTWARE
});

class Status {
  Status({
    required this.self,
    required this.description,
    required this.iconUrl,
    required this.name,
    required this.id,
    required this.statusCategory,
  });

  String self;
  String description;
  String iconUrl;
  StatusName? name;
  String id;
  StatusCategory statusCategory;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    self: json["self"],
    description: json["description"],
    iconUrl: json["iconUrl"],
    name: statusNameValues.map[json["name"]],
    id: json["id"],
    statusCategory: StatusCategory.fromJson(json["statusCategory"]),
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "description": description,
    "iconUrl": iconUrl,
    "name": statusNameValues.reverse[name],
    "id": id,
    "statusCategory": statusCategory.toJson(),
  };
}

enum StatusName { TO_DO, IN_PROGRESS }

final statusNameValues = EnumValues({
  "In Progress": StatusName.IN_PROGRESS,
  "To Do": StatusName.TO_DO
});

class StatusCategory {
  StatusCategory({
    required this.self,
    required this.id,
    required this.key,
    required this.colorName,
    required this.name,
  });

  String self;
  int id;
  StatusCategoryKey? key;
  ColorName? colorName;
  StatusName? name;

  factory StatusCategory.fromJson(Map<String, dynamic> json) => StatusCategory(
    self: json["self"],
    id: json["id"],
    key: statusCategoryKeyValues.map[json["key"]],
    colorName: colorNameValues.map[json["colorName"]],
    name: statusNameValues.map[json["name"]],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "id": id,
    "key": statusCategoryKeyValues.reverse[key],
    "colorName": colorNameValues.reverse[colorName],
    "name": statusNameValues.reverse[name],
  };
}

enum ColorName { BLUE_GRAY, YELLOW }

final colorNameValues = EnumValues({
  "blue-gray": ColorName.BLUE_GRAY,
  "yellow": ColorName.YELLOW
});

enum StatusCategoryKey { NEW, INDETERMINATE }

final statusCategoryKeyValues = EnumValues({
  "indeterminate": StatusCategoryKey.INDETERMINATE,
  "new": StatusCategoryKey.NEW
});

class Votes {
  Votes({
    required this.self,
    required this.votes,
    required this.hasVoted,
  });

  String self;
  int votes;
  bool hasVoted;

  factory Votes.fromJson(Map<String, dynamic> json) => Votes(
    self: json["self"],
    votes: json["votes"],
    hasVoted: json["hasVoted"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "votes": votes,
    "hasVoted": hasVoted,
  };
}

class Watches {
  Watches({
    required this.self,
    required this.watchCount,
    required this.isWatching,
  });

  String self;
  int watchCount;
  bool isWatching;

  factory Watches.fromJson(Map<String, dynamic> json) => Watches(
    self: json["self"],
    watchCount: json["watchCount"],
    isWatching: json["isWatching"],
  );

  Map<String, dynamic> toJson() => {
    "self": self,
    "watchCount": watchCount,
    "isWatching": isWatching,
  };
}

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
