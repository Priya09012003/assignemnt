import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_assignment/core/theme/colors.dart';
import '../../repository/post_repo.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../widgets/item_card.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;
  const PostDetailScreen({required this.postId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(Repository())..add(FetchPostDetail(postId)),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Post Detail'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading post details...', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            } else if (state.postDetail != null) {
              final post = state.postDetail!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: PostCard(
                  //title: post.title ?? "No Title",
                  subtitle: post.body ?? "No content available",
                  backgroundColor: AppColors.white,
                  onTap: () {
                    context.read<PostBloc>().add(MarkAsRead(post.id ?? 0));
                  },
                ),
              );
            } else if (state.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<PostBloc>().add(FetchPostDetail(postId));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
