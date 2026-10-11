import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'full_screen_image.dart';
import 'divine_data.dart';
import 'typewriter_search_hint.dart';
import 'app_localizations.dart';

class HomeTab extends StatefulWidget {
  final void Function(int index)? onTabSelected;

  const HomeTab({super.key, this.onTabSelected});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _selectedDeity => _categories[_selectedCategoryIndex]['title']!;

  List<DivineWallpaper> get _filteredWallpapers {
    return DivineRepository.filterWallpapers(
      deity: _selectedDeity,
      searchQuery: _searchQuery,
    );
  }

  List<DivineClipData> get _filteredClips {
    return DivineRepository.filterClips(
      deity: _selectedDeity,
      searchQuery: _searchQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallpapers = _filteredWallpapers;
    final clips = _filteredClips;
    final isFiltered = _selectedDeity != 'All' || _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Warm divine cream
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/ganesha.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.brightness_7, color: Colors.deepOrange),
            ),
            const SizedBox(width: 10),
            const Text(
              'Sanatani Astha',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepOrange,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          if (isFiltered)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedCategoryIndex = 0;
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              icon: const Icon(Icons.filter_alt_off, size: 16, color: Colors.deepOrange),
              label: const Text('Reset', style: TextStyle(color: Colors.deepOrange, fontSize: 12)),
            )
          else
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Daily notifications enabled!')),
                );
              },
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Animated Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    // Animated Typewriter Placeholder (shown only when text field is empty)
                    if (_searchController.text.isEmpty)
                      const Positioned(
                        left: 48,
                        child: TypewriterSearchHint(),
                      ),

                    // Actual Text Field Input
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Deity Category Chips (Horizontal Scroll)
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = index == _selectedCategoryIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      selected: isSelected,
                      showCheckmark: false,
                      avatar: cat['icon']!.isNotEmpty
                          ? Text(cat['icon']!, style: const TextStyle(fontSize: 16))
                          : null,
                      label: Text(
                        AppLanguage.tr(cat['key']!),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? Colors.deepOrange : Colors.grey.shade200,
                        ),
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 3. Featured Darshan Card (Hero Banner) - only when not actively searching
            if (!isFiltered) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 215,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -20,
                        child: Text(
                          'ॐ',
                          style: TextStyle(
                            fontSize: 180,
                            color: Colors.white.withOpacity(0.12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '✨ Aaj Ka Vishesh Darshan',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Shree Mahakal Ujjain Bhasma Aarti',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Daily Live Blessings & 4K Wallpapers',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (widget.onTabSelected != null) {
                                  widget.onTabSelected!(1); // Go to Wallpapers tab
                                }
                              },
                              icon: const Icon(Icons.explore, size: 16),
                              label: const Text('Explore Gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.deepOrange,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 4. Trending Divine Clips Header & Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        isFiltered ? 'Matching Clips (${clips.length})' : 'Trending Clips',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(width: 6),
                      const Text('🎬', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.onTabSelected != null) {
                        widget.onTabSelected!(2); // Go to Clips tab
                      }
                    },
                    child: const Text(
                      'Watch All →',
                      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            if (clips.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text('No clips match this filter. Try selecting "All".', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ),
              )
            else
              SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: clips.length,
                  itemBuilder: (context, index) {
                    final clip = clips[index];
                    return GestureDetector(
                      onTap: () {
                        if (widget.onTabSelected != null) {
                          widget.onTabSelected!(2); // Switch to full Clips player
                        }
                      },
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: clip.thumbnailUrl,
                                httpHeaders: const {'User-Agent': 'SanataniAstha/1.0 (Android)'},
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(color: Colors.grey[200]),
                                errorWidget: (context, url, error) => Container(color: Colors.grey[300]),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black.withOpacity(0.85), Colors.transparent],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    clip.deity,
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Center(
                                child: Icon(Icons.play_circle_filled, color: Colors.white70, size: 38),
                              ),
                              Positioned(
                                left: 8,
                                right: 8,
                                bottom: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      clip.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '❤️ ${(clip.likes / 1000).toStringAsFixed(1)}k',
                                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),

            // 5. Daily Mantra (Shown when not filtering)
            if (!isFiltered) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.amber.shade200, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'MANTRA OF THE DAY',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.deepOrange,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ॐ नमः शिवाय',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"I bow to Lord Shiva, the auspicious one and the inner self."',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // 6. Wallpapers Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        isFiltered ? 'Wallpapers (${wallpapers.length})' : 'Popular Wallpapers',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(width: 6),
                      const Text('🖼️', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (widget.onTabSelected != null) {
                        widget.onTabSelected!(1); // Go to Wallpapers tab
                      }
                    },
                    child: const Text(
                      'View All →',
                      style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Wallpapers Grid (Curated 5-6 per god + Instant filtering)
            if (wallpapers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.search_off, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        'No wallpapers found for "$_searchQuery".',
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
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                            // Subtle Gradient Overlay at bottom for readable title
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [Colors.black.withOpacity(0.75), Colors.transparent],
                                ),
                              ),
                            ),
                            // Deity Tag on Top-Left
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
                            // Premium Badge on Top-Right
                            if (item.isPremium)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.workspace_premium, size: 14, color: Colors.black87),
                                ),
                              ),
                            // Title & Download stats at bottom
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
                                  const SizedBox(height: 2),
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

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
