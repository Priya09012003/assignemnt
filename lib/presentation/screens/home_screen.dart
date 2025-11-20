import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../../repository/post_repo.dart';
import '../widgets/item_card.dart';
import 'post_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(Repository())..add(FetchAllPosts()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        appBar: AppBar(
          title: const Text("Posts", style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),

        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<PostBloc>().add(FetchAllPosts());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            final posts = state.posts ?? [];

            if (posts.isEmpty) {
              return const Center(
                child: Text("No Posts Available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final p = posts[index];

                return Column(
                  children: [
                    PostCard(
                      title: p.title ?? "",
                      subtitle: p.body ?? "",
                      backgroundColor: p.hasBeenRead ? Colors.white : const Color(0xFFFFF5C6),

                      timerText: "${p.currentTimerValue}s",

                      onTap: () {
                        context.read<PostBloc>().add(MarkAsRead(p.id!));
                        context.read<PostBloc>().add(PauseTimer(p.id!));

                        Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailScreen(postId: p.id!)));
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
