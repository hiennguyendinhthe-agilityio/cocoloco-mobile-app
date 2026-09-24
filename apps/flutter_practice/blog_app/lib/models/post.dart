import 'category.dart';
import 'user_profile.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final String? excerpt;
  final String imageUrl;
  final UserProfile author;
  final List<Category> categories;
  final DateTime createdAt;
  final int readTimeMinutes;
  final int likesCount;
  final bool isFeatured;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    this.excerpt,
    required this.imageUrl,
    required this.author,
    required this.categories,
    required this.createdAt,
    this.readTimeMinutes = 4,
    this.likesCount = 0,
    this.isFeatured = false,
  });
}
