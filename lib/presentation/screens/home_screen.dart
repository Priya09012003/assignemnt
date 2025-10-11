import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_assignment/presentation/screens/post_detail_screen.dart';
import 'package:practice_assignment/repository/post_repo.dart';

import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../widgets/item_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(Repository())..add(FetchAllPosts()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.posts != null) {
              return ListView.builder(
                itemCount: state.posts!.length,
                itemBuilder: (context, index) {
                  final post = state.posts![index];
                  final timerValue = post.timer?.first ?? 0;
                  return PostCard(
                    title: post.title ?? 'No Title',
                    subtitle: post.body ?? '',
                    backgroundColor: (post?.isRead ?? false) ? Colors.white : const Color(0xFFFFFACD),
                    // trailing: post?.isRead ?? false
                    //     ? Container(
                    //         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    //         decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                    //         child: const Text('Read', style: TextStyle(color: Colors.white, fontSize: 12)),
                    //       )
                    //     : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("$timerValue s", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 6),
                        if (post?.isRead ?? false)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                            child: const Text('Read', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                      ],
                    ),
                    onTap: () {
                      context.read<PostBloc>().add(MarkAsRead(post.id ?? 0));
                      context.read<PostBloc>().add(PauseTimer(post.id ?? 0));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PostDetailScreen(postId: post.id ?? 0)),
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
