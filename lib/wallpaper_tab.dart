import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'divine_data.dart';
import 'full_screen_image.dart';
import 'typewriter_search_hint.dart';
import 'app_localizations.dart';
import 'app_membership.dart';

class WallpaperTab extends StatefulWidget {
  const WallpaperTab({super.key});

  @override
  State<WallpaperTab> createState() => _WallpaperTabState();
}

class _WallpaperTabState extends State<WallpaperTab> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _categories = const [
    {'title': 'All', 'icon': '🕉️', 'key': 'cat_all'},
    {'title': 'Mahadev', 'icon': '🔱', 'key': 'cat_mahadev'},
    {'title': 'Shree Ram', 'icon': '🏹', 'key': 'cat_ram'},
    {'title': 'Krishna', 'icon': '🦚', 'key': 'cat_krishna'},
    {'title': 'Hanuman Ji', 'icon': '🚩', 'key': 'cat_hanuman'},
    {'title': 'Ganesh Ji', 'icon': '', 'key': 'cat_ganesh'},
    {'title': 'Maa Durga', 'icon': '🌸', 'key': 'cat_durga'},
  ];

  @override
  void initState() {
    super.initState();
    AppMembership.currentPlan.addListener(_onPlanChanged);
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      setState(() {
        _searchQuery = query;
        if (query.isNotEmpty && _selectedCategoryIndex != 0) {
          _selectedCategoryIndex = 0;
        }
      });
    });
  }

  void _onPlanChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppMembership.currentPlan.removeListener(_onPlanChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _categories[_selectedCategoryIndex]['title'];
    final wallpapers = DivineRepository.filterWallpapers(
      deity: selectedCategory,
      searchQuery: _searchQuery,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLanguage.tr('wallpapers_title'),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.photo_library, size: 16, color: Colors.deepOrange),
                const SizedBox(width: 4),
                Text(
                  '${wallpapers.length} HD',
                  style: const TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  if (_searchQuery.isEmpty)
                    const Positioned(
                      left: 48,
                      child: TypewriterSearchHint(),
                    ),
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Deity Category Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                final cat = _categories[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    showCheckmark: false,
                    avatar: cat['icon']!.isNotEmpty
                        ? Text(cat['icon']!, style: const TextStyle(fontSize: 14))
                        : null,
                    label: Text(
                      AppLanguage.tr(cat['key']!),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.deepOrange,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 3. Wallpapers Grid
          Expanded(
            child: wallpapers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_not_supported_outlined, size: 54, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          'No wallpapers found for "$_searchQuery"',
                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategoryIndex = 0;
                              _searchController.clear();
                            });
                          },
                          child: const Text('Show All Wallpapers', style: TextStyle(color: Colors.deepOrange)),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      itemCount: wallpapers.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final item = wallpapers[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenScreen(
                                  imageUrl: item.imageUrl,
                                  title: item.title,
                                  deity: item.deity,
                                  isPremium: item.isPremium,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: item.imageUrl,
                                  httpHeaders: const {'User-Agent': 'SanataniAstha/1.0 (Android)'},
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: Colors.grey[200]),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, color: Colors.grey),
                                  ),
                                ),
                                // Gradient Overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                                    ),
                                  ),
                                ),
                                // Deity Badge
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item.deity,
                                      style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                // Premium Badge
                                if (item.isPremium)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: AppMembership.isGold
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2E7D32),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.lock_open, size: 10, color: Colors.white),
                                                SizedBox(width: 3),
                                                Text('4K VIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.amber,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.workspace_premium, size: 14, color: Colors.black87),
                                          ),
                                  ),
                                // Title & Download Counter
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          const Icon(Icons.download, size: 11, color: Colors.white70),
                                          const SizedBox(width: 3),
                                          Text(
                                            item.downloads,
                                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
