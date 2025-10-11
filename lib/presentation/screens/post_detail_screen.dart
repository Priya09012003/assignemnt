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
        appBar: AppBar(title: const Text('Post Detail')),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
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
              return Center(child: Text(state.errorMessage!));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
