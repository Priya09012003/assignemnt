class DataModel {
  int? userId;
  int? id;
  String? title;
  String? body;
  bool? isRead;
  List<int>? timer;

  DataModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    this.timer,
  });

  bool get hasBeenRead => isRead ?? false;
  int get currentTimerValue => timer?.first ?? 0;

  DataModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
    isRead = json['isRead'] ?? false;
    timer = json['timer'] != null ? List<int>.from(json['timer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['isRead'] = isRead;
    data['timer'] = timer;

    return data;
  }
}
