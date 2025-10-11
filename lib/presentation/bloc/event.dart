abstract class PostEvent {}

class FetchAllPosts extends PostEvent {}

class FetchPostDetail extends PostEvent {
  final int postId;
  FetchPostDetail(this.postId);
}

class MarkAsRead extends PostEvent {
  final int postId;
  MarkAsRead(this.postId);
}

class StartTimer extends PostEvent {
  final int postId;
  final int duration;
  StartTimer({required this.postId, required this.duration});
}

class TickTimer extends PostEvent {
  final int postId;
  TickTimer(this.postId);
}

class PauseTimer extends PostEvent {
  final int postId;
  PauseTimer(this.postId);
}
