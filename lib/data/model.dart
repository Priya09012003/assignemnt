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

  DataModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
    isRead = false;
    timer = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;

    return data;
  }
}
