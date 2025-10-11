import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_assignment/presentation/screens/post_detail_screen.dart';
import 'package:practice_assignment/repository/post_repo.dart';

import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../widgets/item_card.dart';
import '../widgets/network_status_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(Repository())..add(FetchAllPosts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          actions: const [
            NetworkStatusWidget(),
            SizedBox(width: 16),
          ],
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
                    Text('Loading posts...', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            } else if (state.posts != null) {
              return ListView.builder(
                itemCount: state.posts!.length,
                itemBuilder: (context, index) {
                  final post = state.posts![index];
                  final timerValue = post.currentTimerValue;
                  return PostCard(
                    title: post.title ?? 'No Title',
                    subtitle: post.body ?? '',
                    backgroundColor: post.hasBeenRead ? Colors.white : const Color(0xFFFFFACD),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("$timerValue s", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 6),
                        if (post.hasBeenRead)
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
                        context.read<PostBloc>().add(FetchAllPosts());
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
