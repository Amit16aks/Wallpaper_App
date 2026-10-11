import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'login_screen.dart';
import 'divine_data.dart';
import 'full_screen_image.dart';
import 'app_localizations.dart';
import 'audio_helper.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  // Membership Plan: 'Free', 'Gold', or 'Diamond'
  String _currentPlan = 'Free';

  // Collection Segment: 0 -> Favorites, 1 -> Downloads
  int _selectedCollectionTab = 0;

  // Devotional Preferences
  String _selectedIshtadev = 'Mahadev 🔱';
  
  // Custom Darshan Reminder Times (Devotees can add multiple times)
  final List<String> _reminderTimes = [
    '06:00 AM (Brahma Muhurta)',
    '07:30 PM (Sandhya Aarti)',
  ];
  bool _morningDarshanNotification = true;
  bool _templeBellSound = true;
  String _selectedLanguage = 'English';

  final List<String> _ishtadevList = const [
    'Mahadev 🔱',
    'Shree Ram 🏹',
    'Krishna 🦚',
    'Hanuman Ji 🚩',
    'Ganesh Ji',
    'Maa Durga 🌸',
  ];

  final List<String> _languages = const [
    'English',
    'हिन्दी (Hindi)',
    'संस्कृत (Sanskrit)',
    'ગુજરાતી (Gujarati)',
  ];

  // Curated lists for user's collection
  late final List<DivineWallpaper> _favoriteWallpapers;
  late final List<DivineWallpaper> _downloadedWallpapers;

  @override
  void initState() {
    super.initState();
    _favoriteWallpapers = DivineRepository.allWallpapers.take(8).toList();
    _downloadedWallpapers = DivineRepository.allWallpapers.skip(8).take(6).toList();
    _selectedLanguage = AppLanguage.currentLanguage.value;
    _templeBellSound = AudioHelper.isBellSoundEnabled;
  }

  void _showUpgradeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 52),
              const SizedBox(height: 8),
              const Text(
                'Choose Your Bhakti Pass',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Unlock high-resolution divine darshans with zero watermarks',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Gold Plan Option (₹29/mo)
              InkWell(
                onTap: () {
                  setState(() => _currentPlan = 'Gold');
                  Navigator.pop(context);
                  _showPlanActivatedSnackBar('Gold');
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentPlan == 'Gold' ? Colors.amber : Colors.white24,
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade900.withValues(alpha: 0.6), Colors.deepOrange.shade800.withValues(alpha: 0.4)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library, color: Colors.amber, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Gold Plan',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Unlimited 4K Wallpapers & Clean Sharing',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '₹29/mo',
                        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Diamond Plan Option (₹99/mo)
              InkWell(
                onTap: () {
                  setState(() => _currentPlan = 'Diamond');
                  Navigator.pop(context);
                  _showPlanActivatedSnackBar('Diamond');
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentPlan == 'Diamond' ? Colors.deepOrange : Colors.white24,
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.deepOrange.shade900.withValues(alpha: 0.7), Colors.purple.shade900.withValues(alpha: 0.5)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.video_library, color: Colors.deepOrange, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Diamond VIP Pass',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'All 4K Wallpapers + All HD Divine Clips',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '₹99/mo',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Free Dev Tier Reset
              TextButton(
                onPressed: () {
                  setState(() => _currentPlan = 'Free');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switched back to Free Tier (Dev Mode)')),
                  );
                },
                child: const Text('Reset to Free Tier (Testing)', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPlanActivatedSnackBar(String plan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '🎉 Activated $plan Plan! All benefits unlocked.',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showIshtadevPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLanguage.tr('pref_ishtadev'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
                const SizedBox(height: 12),
                ..._ishtadevList.map((deity) {
                  final isSelected = deity == _selectedIshtadev;
                  return ListTile(
                    title: Text(deity, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    trailing: isSelected ? const Icon(Icons.check, color: Colors.deepOrange) : null,
                    onTap: () {
                      setState(() => _selectedIshtadev = deity);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLanguage.tr('pref_lang'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                ),
                const SizedBox(height: 12),
                ..._languages.map((lang) {
                  final isSelected = lang == _selectedLanguage;
                  return ListTile(
                    title: Text(lang, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    trailing: isSelected ? const Icon(Icons.check, color: Colors.deepOrange) : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = lang;
                        AppLanguage.setLanguage(lang);
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('App language changed to $lang'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Add Multiple Custom Reminder Times ---
  Future<void> _addNewReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select Darshan Reminder Time',
    );
    if (picked != null) {
      if (!mounted) return;
      final formattedTime = picked.format(context);
      setState(() {
        if (!_reminderTimes.contains(formattedTime)) {
          _reminderTimes.add(formattedTime);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added reminder time: $formattedTime'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // --- Suggest a Mandir Interactive Form ---
  void _showSuggestMandirForm() {
    final mandirNameController = TextEditingController();
    final deityController = TextEditingController();
    final locationController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.temple_hindu, color: Colors.deepOrange, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLanguage.tr('suggest_dialog_title'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppLanguage.tr('suggest_dialog_desc'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 18),

                TextField(
                  controller: mandirNameController,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr('suggest_name_label'),
                    hintText: 'e.g. Somnath Mahadev Mandir',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF4F4F6),
                    prefixIcon: const Icon(Icons.place, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: deityController,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr('suggest_deity_label'),
                    hintText: 'e.g. Mahadev / Shiva',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF4F4F6),
                    prefixIcon: const Icon(Icons.auto_awesome, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr('suggest_city_label'),
                    hintText: 'e.g. Prabhas Patan, Gujarat',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF4F4F6),
                    prefixIcon: const Icon(Icons.location_city, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: AppLanguage.tr('suggest_note_label'),
                    hintText: 'Any sacred history, aarti timing, or photo tip...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF4F4F6),
                    prefixIcon: const Icon(Icons.notes, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    final mandir = mandirNameController.text.trim();
                    if (mandir.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter the mandir name.')),
                      );
                      return;
                    }

                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: Row(
                          children: [
                            const Text('🪔', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLanguage.tr('suggest_success_title'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          '${AppLanguage.tr('suggest_success_msg')}\n\n📍 Mandir: $mandir',
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Dhanyawad 🙏', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    AppLanguage.tr('suggest_submit_btn'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.currentLanguage,
      builder: (context, _, child) {
        final user = FirebaseAuth.instance.currentUser;
        final userName = user?.displayName ?? AppLanguage.tr('devotee_title');
        final userEmail = user?.email ?? user?.phoneNumber ?? 'devotee@sanatani.app';

        return Scaffold(
          backgroundColor: const Color(0xFFFDFBF7),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppLanguage.tr('profile_title'),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.deepOrange),
                tooltip: 'Share App',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Blessings shared with family via WhatsApp!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 36),
            child: Column(
              children: [
                // 1. Profile Header & Devotee Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.deepOrange.withValues(alpha: 0.3), width: 2),
                                gradient: LinearGradient(
                                  colors: [Colors.orange.shade100, Colors.deepOrange.shade100],
                                ),
                              ),
                              child: Center(
                                child: user?.photoURL != null
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user!.photoURL!,
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Text('🕉️', style: TextStyle(fontSize: 34)),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Devotee Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userEmail,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Streak Chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.orange.shade200),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('🔥', style: TextStyle(fontSize: 12)),
                                        const SizedBox(width: 4),
                                        Text(
                                          AppLanguage.tr('streak_badge'),
                                          style: const TextStyle(
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Dynamic Membership Status Card (Free / Gold / Diamond)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildMembershipCard(),
                ),
                const SizedBox(height: 20),

                // 3. Bhakti Activity Counters (Favorites / Downloads / Shares)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          icon: Icons.favorite,
                          iconColor: Colors.red,
                          count: '${_favoriteWallpapers.length}',
                          label: AppLanguage.tr('stat_favorites'),
                          onTap: () => setState(() => _selectedCollectionTab = 0),
                          isSelected: _selectedCollectionTab == 0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          icon: Icons.download_done,
                          iconColor: Colors.deepOrange,
                          count: '${_downloadedWallpapers.length}',
                          label: AppLanguage.tr('stat_downloads'),
                          onTap: () => setState(() => _selectedCollectionTab = 1),
                          isSelected: _selectedCollectionTab == 1,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          icon: Icons.share,
                          iconColor: Colors.blue,
                          count: '38',
                          label: AppLanguage.tr('stat_shared'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('You have shared 38 divine blessings! 🙏')),
                            );
                          },
                          isSelected: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. "My Divine Sanctuary" (Tabbed Collection)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Segment Tabs Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildPillTab(
                                    label: '${AppLanguage.tr('collection_favorites')} (${_favoriteWallpapers.length})',
                                    isSelected: _selectedCollectionTab == 0,
                                    onTap: () => setState(() => _selectedCollectionTab = 0),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildPillTab(
                                    label: '${AppLanguage.tr('collection_downloaded')} (${_downloadedWallpapers.length})',
                                    isSelected: _selectedCollectionTab == 1,
                                    onTap: () => setState(() => _selectedCollectionTab = 1),
                                  ),
                                ],
                              ),
                              Text(
                                'All HD',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Wallpapers Horizontal Grid
                        SizedBox(
                          height: 170,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: _selectedCollectionTab == 0
                                ? _favoriteWallpapers.length
                                : _downloadedWallpapers.length,
                            itemBuilder: (context, index) {
                              final item = _selectedCollectionTab == 0
                                  ? _favoriteWallpapers[index]
                                  : _downloadedWallpapers[index];
                              return _buildCollectionItem(item);
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Devotional Settings Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                          child: Text(
                            AppLanguage.tr('prefs_title'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        // Primary Ishtadev
                        ListTile(
                          leading: const Icon(Icons.temple_hindu, color: Colors.deepOrange),
                          title: Text(AppLanguage.tr('pref_ishtadev'), style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(AppLanguage.tr('pref_ishtadev_sub'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_selectedIshtadev, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                          onTap: _showIshtadevPicker,
                        ),
                        const Divider(height: 1, indent: 56),

                        // Custom Darshan Reminder Times (Multiple times supported)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.alarm, color: Colors.deepOrange, size: 22),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppLanguage.tr('pref_reminder'), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                        Text(AppLanguage.tr('pref_reminder_sub'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _morningDarshanNotification,
                                    activeThumbColor: Colors.deepOrange,
                                    onChanged: (val) {
                                      setState(() => _morningDarshanNotification = val);
                                    },
                                  ),
                                ],
                              ),
                              if (_morningDarshanNotification) ...[
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    ..._reminderTimes.map((t) => Chip(
                                      backgroundColor: Colors.orange.shade50,
                                      label: Text(t, style: const TextStyle(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.bold)),
                                      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.deepOrange),
                                      onDeleted: _reminderTimes.length > 1
                                          ? () => setState(() => _reminderTimes.remove(t))
                                          : null,
                                      side: BorderSide(color: Colors.orange.shade200),
                                    )),
                                    ActionChip(
                                      avatar: const Icon(Icons.add, size: 16, color: Colors.white),
                                      backgroundColor: Colors.deepOrange,
                                      label: Text(
                                        AppLanguage.tr('pref_add_time'),
                                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: _addNewReminderTime,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Divider(height: 1, indent: 56),

                        // Temple Bell Sound
                        SwitchListTile(
                          secondary: const Icon(Icons.notifications_active, color: Colors.deepOrange),
                          title: Text(AppLanguage.tr('pref_bell'), style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(AppLanguage.tr('pref_bell_sub'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          value: _templeBellSound,
                          activeThumbColor: Colors.deepOrange,
                          onChanged: (val) {
                            setState(() {
                              _templeBellSound = val;
                              AudioHelper.isBellSoundEnabled = val;
                            });
                            if (val) {
                              AudioHelper.playTempleBell();
                            }
                          },
                        ),
                        const Divider(height: 1, indent: 56),

                        // App Language
                        ListTile(
                          leading: const Icon(Icons.language, color: Colors.deepOrange),
                          title: Text(AppLanguage.tr('pref_lang'), style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(AppLanguage.tr('pref_lang_sub'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_selectedLanguage, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                          onTap: _showLanguagePicker,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 6. Community & Support Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.volunteer_activism, color: Colors.deepOrange),
                          title: Text(AppLanguage.tr('suggest_mandir'), style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(AppLanguage.tr('suggest_mandir_sub'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: _showSuggestMandirForm,
                        ),
                        const Divider(height: 1, indent: 56),
                        ListTile(
                          leading: const Icon(Icons.rate_review_outlined, color: Colors.deepOrange),
                          title: Text(AppLanguage.tr('rate_app'), style: const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(AppLanguage.tr('rate_app_sub'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening Google Play Store review page...')),
                            );
                          },
                        ),
                        const Divider(height: 1, indent: 56),
                        ListTile(
                          leading: const Icon(Icons.security, color: Colors.deepOrange),
                          title: Text(AppLanguage.tr('privacy_terms'), style: const TextStyle(fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sanatani Astha 100% devotee privacy protected.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 7. Sign Out Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: OutlinedButton.icon(
                    onPressed: () => _showSignOutDialog(context),
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: Text(AppLanguage.tr('sign_out'), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Version Tag
                Text(
                  'Sanatani Astha • v1.0.0 (Devotional Edition)',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Dynamic Membership Card Builder ---
  Widget _buildMembershipCard() {
    if (_currentPlan == 'Free') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.deepOrange.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.deepOrange.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: Colors.deepOrange, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppLanguage.tr('free_tier_title'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _showUpgradeSheet,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    backgroundColor: Colors.deepOrange.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppLanguage.tr('upgrade_btn'), style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              AppLanguage.tr('free_tier_desc'),
              style: TextStyle(color: Colors.grey[600], fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _currentPlan = 'Gold');
                      _showPlanActivatedSnackBar('Gold');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLanguage.tr('upgrade_gold_btn'), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _currentPlan = 'Diamond');
                      _showPlanActivatedSnackBar('Diamond');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLanguage.tr('upgrade_diamond_btn'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (_currentPlan == 'Gold') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.amber.shade800, Colors.deepOrange.shade700],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.workspace_premium, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      AppLanguage.tr('gold_tier_title'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLanguage.tr('gold_tier_desc'),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showUpgradeSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange.shade800,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLanguage.tr('upgrade_clips_prompt'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Diamond Pass
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2A5298).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.diamond, color: Colors.lightBlueAccent, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      AppLanguage.tr('diamond_tier_title'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('FULL ACCESS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLanguage.tr('diamond_tier_desc'),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _showUpgradeSheet,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(AppLanguage.tr('manage_vip'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  // --- Bhakti Activity Counter Box ---
  Widget _buildStatBox({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.deepOrange, width: 1.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  // --- Pill Tab Selector ---
  Widget _buildPillTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // --- Collection Item Tile ---
  Widget _buildCollectionItem(DivineWallpaper wallpaper) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenScreen(
                imageUrl: wallpaper.imageUrl,
                title: wallpaper.title,
                deity: wallpaper.deity,
                isPremium: wallpaper.isPremium,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: wallpaper.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.orange.shade50,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.deepOrange, strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              wallpaper.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // --- Sign Out Dialog ---
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out of Sanatani Astha?'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();

                if (FirebaseAuth.instance.currentUser == null && context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
