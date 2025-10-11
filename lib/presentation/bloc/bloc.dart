import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_assignment/data/model.dart';
import 'package:practice_assignment/presentation/bloc/state.dart';
import '../../repository/post_repo.dart';
import 'event.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final Repository repository;
  final Map<int, Timer> _timers = {}; // Timer per post
  PostBloc(this.repository) : super(PostState()) {
    // Fetch all posts
    on<FetchAllPosts>((event, emit) async {
      emit(PostState(isLoading: true));
      try {
        final posts = await repository.getPosts();

        // Initialize random timer durations for each post
        final updatedPosts = posts.map((post) {
          post.timer = [10, 20, 25]..shuffle(); // Random timer in seconds
          return post;
        }).toList();

        emit(PostState(posts: updatedPosts, isLoading: false));

        // Start timers
        for (var post in updatedPosts) {
          add(StartTimer(postId: post.id!, duration: post.timer!.first));
        }
      } catch (e) {
        emit(PostState(errorMessage: e.toString(), isLoading: false));
      }
    });

    // Fetch single post details
    on<FetchPostDetail>((event, emit) async {
      emit(PostState(isLoading: true));
      try {
        final post = await repository.getPostDetail(event.postId);
        emit(PostState(postDetail: post, isLoading: false));
      } catch (e) {
        emit(PostState(errorMessage: e.toString(), isLoading: false));
      }
    });

    // Mark post as read
    on<MarkAsRead>((event, emit) {
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
        emit(state.copyWith(posts: updatedPosts));
      }
    });

    // Start timer
    on<StartTimer>((event, emit) {
      if (_timers[event.postId] != null) return;

      _timers[event.postId] = Timer.periodic(const Duration(seconds: 1), (_) {
        add(TickTimer(event.postId));
      });
    });

    // Tick timer
    on<TickTimer>((event, emit) {
      if (state.posts != null) {
        final updatedPosts = state.posts!.map((post) {
          if (post.id == event.postId && (post.timer?.first ?? 0) > 0) {
            post.timer![0] = post.timer![0] - 1; // Decrease timer
          }
          return post;
        }).toList();
        emit(state.copyWith(posts: updatedPosts));
      }
    });

    // Pause timer
    on<PauseTimer>((event, emit) {
      _timers[event.postId]?.cancel();
      _timers.remove(event.postId);
    });
  }

  @override
  Future<void> close() {
    for (var t in _timers.values) t.cancel();
    return super.close();
  }
}
