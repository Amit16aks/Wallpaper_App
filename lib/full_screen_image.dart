import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'app_membership.dart';

class FullScreenScreen extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? deity;
  final bool isPremium;

  const FullScreenScreen({
    super.key,
    required this.imageUrl,
    this.title,
    this.deity,
    this.isPremium = false,
  });

  void _showGoldSubscriptionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              const SizedBox(height: 18),
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 54),
              const SizedBox(height: 10),
              const Text(
                'Unlock Gold Subscription',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Download and share high-resolution divine 4K wallpapers without watermarks.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[300], fontSize: 13),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade800, Colors.deepOrange.shade600],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gold Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('Unlimited 4K Downloads & Shares', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    Text('₹29/mo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: () {
                  AppMembership.setPlan('Gold');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Congratulations! You have unlocked the Gold Plan.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Upgrade for ₹29/month', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Maybe Later', style: TextStyle(color: Colors.white60)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppMembership.currentPlan,
      builder: (context, plan, _) {
        final isUnlocked = !isPremium || AppMembership.isGold;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Wallpaper Image
              Hero(
                tag: imageUrl,
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    httpHeaders: const {'User-Agent': 'SanataniAstha/1.0 (Android)'},
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.deepOrange),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white, size: 50),
                    ),
                  ),
                ),
              ),

              // 2. Top Bar with Back Button & Deity Tag
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (deity != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            deity!,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      const Spacer(),
                      if (isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppMembership.isGold ? const Color(0xFF2E7D32) : Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                AppMembership.isGold ? Icons.lock_open : Icons.workspace_premium,
                                size: 14,
                                color: AppMembership.isGold ? Colors.white : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppMembership.isGold ? 'UNLOCKED' : 'Gold',
                                style: TextStyle(
                                  color: AppMembership.isGold ? Colors.white : Colors.black,
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
              ),

              // 3. Bottom Bar with Title & Action Buttons
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    top: 24,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null) ...[
                        Text(
                          title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          // Share Button
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                if (AppMembership.isGold) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('🎉 Sharing pristine 4K wallpaper with no watermarks! (Gold Pass Benefit) 🙏'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sharing wallpaper with "Sanatani Astha" watermark! Upgrade to Gold for clean sharing.'),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.share, color: Colors.white),
                              label: const Text('Share', style: TextStyle(color: Colors.white)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white30),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Download / Gold Paywall Button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (isUnlocked) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppMembership.isGold
                                            ? '🎉 4K Divine Wallpaper downloaded in original resolution without watermark! (Gold Pass Benefit) 🙏'
                                            : '📥 Divine Wallpaper downloaded successfully! 🙏',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  _showGoldSubscriptionSheet(context);
                                }
                              },
                              icon: Icon(
                                isUnlocked ? Icons.download_done : Icons.workspace_premium,
                                color: Colors.white,
                              ),
                              label: Text(
                                isUnlocked ? 'Download 4K' : 'Unlock 4K (₹29)',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isUnlocked ? Colors.deepOrange : Colors.amber.shade800,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
