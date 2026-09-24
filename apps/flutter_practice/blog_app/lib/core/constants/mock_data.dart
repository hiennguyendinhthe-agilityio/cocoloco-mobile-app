import "../../models/category.dart";
import "../../models/post.dart";
import "../../models/user_profile.dart";

class MockData {
  static const currentUser = UserProfile(
    id: "user_1",
    email: "hien.nguyen@agilityio.com",
    fullName: "Hien Nguyen",
    avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80",
    bio: "Software Engineer & Mobile Specialist passionate about Clean Architecture and Flutter.",
    role: UserRole.admin,
    isActive: true,
  );

  static const sampleAuthor = UserProfile(
    id: "user_2",
    email: "clara.design@editorial.io",
    fullName: "Clara Delacroix",
    avatarUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80",
    bio: "Lead Editorial Writer & Lifestyle Columnist.",
    role: UserRole.user,
    isActive: true,
  );

  static final categories = [
    const Category(id: "cat_all", name: "All Stories", slug: "all"),
    const Category(id: "cat_1", name: "Coffee & Living", slug: "coffee-living"),
    const Category(id: "cat_2", name: "Artisan Food", slug: "artisan-food"),
    const Category(id: "cat_3", name: "Architecture", slug: "architecture"),
    const Category(id: "cat_4", name: "Productivity", slug: "productivity"),
    const Category(id: "cat_5", name: "Technology", slug: "technology"),
  ];

  static final samplePosts = [
    Post(
      id: "post_1",
      title: "The Alchemy of Morning Coffee: From Bean to Ceramic Cup",
      excerpt: "Discover the meticulous art of slow pour-overs and how ambient morning rituals shape our daily creative energy.",
      content:
          "Morning rituals are not merely habits; they are an intimate conversation between stillness and intention.\n\nWhen the kettle reaches that delicate whisper of a boil, roughly 94 degrees Celsius, the bloom of freshly roasted Ethiopian beans releases notes of bergamot and wild jasmine. In an era where digital urgency permeates every waking hour, dedicating six uninterrupted minutes to a slow pour-over is an act of quiet rebellion.\n\nThe tactile sensation of warm ceramic in hand grounds our thoughts before the cascade of notifications begins.",
      imageUrl: "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80",
      author: currentUser,
      categories: [categories[1], categories[4]],
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      readTimeMinutes: 5,
      likesCount: 142,
      isFeatured: true,
    ),
    Post(
      id: "post_2",
      title: "Minimalist Spaces: How Scandinavian Aesthetics Enhance Focus",
      excerpt: "A deep dive into natural light, organic woods, and decluttered environments designed for deep work.",
      content:
          "Space shapes consciousness. In Scandinavian design, light is treated not as an ambient byproduct, but as a prized material element.\n\nBy removing unnecessary ornament and inviting pale birch, untreated linen, and expansive negative space, the mind finds room to breathe and synthesize complex ideas.",
      imageUrl: "https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80",
      author: sampleAuthor,
      categories: [categories[3], categories[4]],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      readTimeMinutes: 4,
      likesCount: 98,
      isFeatured: true,
    ),
    Post(
      id: "post_3",
      title: "Handcrafted Pasta & The Philosophy of Slow Italian Living",
      excerpt: "Exploring rustic culinary traditions where three simple ingredients turn into unforgettable culinary poetry.",
      content:
          "Semolina, egg yolk, and sea salt. In the hills of Emilia-Romagna, time is measured not in stopwatch ticks, but in the patience of kneading dough until it yields like velvet under palms.\n\nCooking slowly reminds us that the best outcomes cannot be rushed by modern convenience.",
      imageUrl: "https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=1200&q=80",
      author: sampleAuthor,
      categories: [categories[2]],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      readTimeMinutes: 6,
      likesCount: 215,
      isFeatured: false,
    ),
    Post(
      id: "post_4",
      title: "Designing for Mobile: Micro-Interactions that Delight Users",
      excerpt: "Why the subtle haptic tap and smooth spring animation transform functional apps into memorable experiences.",
      content:
          "Great UI design is invisible; extraordinary interaction design is emotional.\n\nWhen a button compresses subtly under a finger and rebounds with a gentle haptic pulse, the digital glass disappears. Users do not merely execute tasks; they feel craft and care.",
      imageUrl: "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?auto=format&fit=crop&w=1200&q=80",
      author: currentUser,
      categories: [categories[5]],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      readTimeMinutes: 4,
      likesCount: 310,
      isFeatured: false,
    ),
  ];
}
