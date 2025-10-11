import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_assignment/data/model.dart';
import 'package:practice_assignment/data/local_storage_service.dart';
import 'package:practice_assignment/presentation/bloc/state.dart';
import '../../repository/post_repo.dart';
import 'event.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final Repository repository;
  final Map<int, Timer> _activeTimers = {};
  
  PostBloc(this.repository) : super(PostState()) {
    on<FetchAllPosts>((event, emit) async {
      emit(PostState(isLoading: true));
      try {
        final posts = await repository.getPosts();
        final updatedPosts = posts.map((post) {
          post.timer = [10, 20, 25]..shuffle();
          return post;
        }).toList();

        emit(PostState(posts: updatedPosts, isLoading: false));

        for (var post in updatedPosts) {
          add(StartTimer(postId: post.id!, duration: post.timer!.first));
        }
      } catch (e) {
        emit(PostState(errorMessage: e.toString(), isLoading: false));
      }
    });
    on<FetchPostDetail>((event, emit) async {
      emit(PostState(isLoading: true));
      try {
        final post = await repository.getPostDetail(event.postId);
        emit(PostState(postDetail: post, isLoading: false));
      } catch (e) {
        emit(PostState(errorMessage: e.toString(), isLoading: false));
      }
    });
    on<MarkAsRead>((event, emit) async {
      if (state.posts != null) {
        final updatedPosts = state.posts!.map((post) {
          if (post.id == event.postId) {
            return DataModel(
              id: post.id,
              title: post.title,
              body: post.body,
              isRead: true,
              userId: post.userId,
              timer: post.timer,
            );
          }
          return post;
        }).toList();
        
        await LocalStorageService.savePosts(updatedPosts);
        emit(state.copyWith(posts: updatedPosts));
      }
    });
    on<StartTimer>((event, emit) {
      if (_activeTimers[event.postId] != null) return;

      _activeTimers[event.postId] = Timer.periodic(const Duration(seconds: 1), (_) {
        add(TickTimer(event.postId));
      });
    });
    on<TickTimer>((event, emit) {
      if (state.posts != null) {
        final updatedPosts = state.posts!.map((post) {
          if (post.id == event.postId && (post.timer?.first ?? 0) > 0) {
            post.timer![0] = post.timer![0] - 1;
          }
          return post;
        }).toList();
        emit(state.copyWith(posts: updatedPosts));
      }
    });
    on<PauseTimer>((event, emit) {
      _activeTimers[event.postId]?.cancel();
      _activeTimers.remove(event.postId);
    });
  }

  @override
  Future<void> close() {
    for (var timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
    return super.close();
  }
}
