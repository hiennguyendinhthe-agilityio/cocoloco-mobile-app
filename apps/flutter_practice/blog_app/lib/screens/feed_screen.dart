import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "../core/constants/mock_data.dart";
import "../core/theme/app_colors.dart";
import "../core/theme/app_typography.dart";
import "../models/post.dart";
import "../widgets/category_chip.dart";
import "../widgets/post_card_horizontal.dart";
import "../widgets/post_card_vertical.dart";
import "post_detail_screen.dart";

class FeedScreen extends StatefulWidget {
  final VoidCallback? onOpenCreatePost;

  const FeedScreen({super.key, this.onOpenCreatePost});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String selectedCategoryId = "cat_all";
  String searchQuery = "";

  List<Post> get filteredPosts {
    return MockData.samplePosts.where((post) {
      final matchesCategory = selectedCategoryId == "cat_all" ||
          post.categories.any((c) => c.id == selectedCategoryId);
      final matchesQuery = searchQuery.isEmpty ||
          post.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          post.content.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final featuredPosts = MockData.samplePosts.where((p) => p.isFeatured).toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar / Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "COCOLOCO",
                          style: AppTypography.labelSmall.copyWith(
                            letterSpacing: 2.0,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Daily Journal",
                          style: AppTypography.displayMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(
                          MockData.currentUser.avatarUrl!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() => searchQuery = val),
                          decoration: InputDecoration(
                            hintText: "Search stories, topics, authors...",
                            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Featured Carousel
            if (featuredPosts.isNotEmpty && searchQuery.isEmpty && selectedCategoryId == "cat_all") ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Editor Choice", style: AppTypography.displaySmall.copyWith(fontSize: 18)),
                      Text(
                        "View all",
                        style: AppTypography.labelSmall.copyWith(color: AppColors.accent),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: featuredPosts.length,
                    itemBuilder: (context, index) {
                      final post = featuredPosts[index];
                      return PostCardHorizontal(
                        post: post,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailScreen(post: post),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],

            // Category Chips Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: MockData.categories.length,
                    itemBuilder: (context, index) {
                      final category = MockData.categories[index];
                      final isSelected = category.id == selectedCategoryId;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          category: category,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              selectedCategoryId = category.id;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Feed Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Text("Latest Stories", style: AppTypography.displaySmall.copyWith(fontSize: 18)),
              ),
            ),

            // Vertical Posts List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = filteredPosts[index];
                    return PostCardVertical(
                      post: post,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailScreen(post: post),
                          ),
                        );
                      },
                    );
                  },
                  childCount: filteredPosts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
