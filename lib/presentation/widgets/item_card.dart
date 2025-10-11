import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String? title;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const PostCard({
    super.key,
    this.title,
    required this.subtitle,
    this.backgroundColor = const Color(0xFFFFFACD),
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16, 
                          color: Colors.black87
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      subtitle, 
                      style: const TextStyle(
                        fontSize: 14, 
                        color: Colors.black87, 
                        height: 1.4
                      )
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10), 
                trailing!
              ],
            ],
          ),
        ),
      ),
    );
  }
}
