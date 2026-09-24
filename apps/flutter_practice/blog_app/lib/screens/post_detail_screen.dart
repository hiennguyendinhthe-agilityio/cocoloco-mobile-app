import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/post.dart';
import '../widgets/app_button.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late int likes;
  bool isLiked = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    likes = widget.post.likesCount;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final dateStr = DateFormat('MMMM d, yyyy').format(post.createdAt);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Image Header
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.background,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    child: IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isBookmarked ? AppColors.primary : AppColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => isBookmarked = !isBookmarked),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                              AppColors.background,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Article Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tags & Date
                      Row(
                        children: [
                          if (post.categories.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.accentSoft,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                post.categories.first.name.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),
                          Text(
                            dateStr,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                          ),
                          const Spacer(),
                          Text(
                            '${post.readTimeMinutes} min read',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Article Title
                      Text(
                        post.title,
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Author Profile Row
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: post.author.avatarUrl != null
                                  ? CachedNetworkImageProvider(post.author.avatarUrl!)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.author.fullName,
                                    style: AppTypography.labelLarge.copyWith(fontSize: 15),
                                  ),
                                  Text(
                                    post.author.bio ?? 'Editorial Contributor',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            AppButton(
                              label: 'Follow',
                              isOutlined: true,
                              height: 36,
                              width: 80,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Article Body
                      Text(
                        post.content,
                        style: AppTypography.bodyLarge.copyWith(
                          fontSize: 17,
                          height: 1.75,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Interaction Footer (Likes & Share)
                      Divider(color: AppColors.divider),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isLiked ? Colors.red : AppColors.textSecondary,
                                  size: 24,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isLiked = !isLiked;
                                    likes += isLiked ? 1 : -1;
                                  });
                                },
                              ),
                              Text('$likes claps', style: AppTypography.bodyMedium),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Story link copied to clipboard!')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
