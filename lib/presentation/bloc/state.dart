import 'package:practice_assignment/data/model.dart';

class PostState {
  final bool isLoading;
  final List<DataModel>? posts;
  final DataModel? postDetail;
  final String? errorMessage;

  PostState({this.isLoading = false, this.posts, this.postDetail, this.errorMessage});

  PostState copyWith({bool? isLoading, List<DataModel>? posts, DataModel? postDetail, String? errorMessage}) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      postDetail: postDetail ?? this.postDetail,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
