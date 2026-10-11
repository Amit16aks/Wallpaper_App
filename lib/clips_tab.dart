import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'divine_data.dart';
import 'app_localizations.dart';
import 'app_membership.dart';

class ClipItem {
  final String id;
  final String title;
  final String deity;
  final String audioTrack;
  final String videoUrl;
  final String thumbnailUrl;
  final int likes;
  final int shares;

  const ClipItem({
    required this.id,
    required this.title,
    required this.deity,
    required this.audioTrack,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.likes,
    required this.shares,
  });
}

class ClipsTab extends StatefulWidget {
  const ClipsTab({super.key});

  @override
  State<ClipsTab> createState() => _ClipsTabState();
}

class _ClipsTabState extends State<ClipsTab> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  late final List<ClipItem> _clips;

  @override
  void initState() {
    super.initState();
    _clips = DivineRepository.allClips.map((c) => ClipItem(
      id: c.id,
      title: c.title,
      deity: c.deity,
      audioTrack: c.audioTrack,
      videoUrl: c.videoUrl,
      thumbnailUrl: c.thumbnailUrl,
      likes: c.likes,
      shares: c.shares,
    )).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _clips.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return ClipPlayerItem(
            clip: _clips[index],
            isActive: index == _currentIndex,
          );
        },
      ),
    );
  }
}

class ClipPlayerItem extends StatefulWidget {
  final ClipItem clip;
  final bool isActive;

  const ClipPlayerItem({
    super.key,
    required this.clip,
    required this.isActive,
  });

  @override
  State<ClipPlayerItem> createState() => _ClipPlayerItemState();
}

class _ClipPlayerItemState extends State<ClipPlayerItem> {
  VideoPlayerController? _controller;
  bool _isLiked = false;
  late int _likeCount;
  bool _showPlayIcon = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.clip.likes;
    _initController();
  }

  void _initController() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.clip.videoUrl),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {});
          if (widget.isActive) {
            _controller?.setLooping(true);
            _controller?.play();
          }
        }
      });
  }

  @override
  void didUpdateWidget(covariant ClipPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _showPlayIcon = true;
      } else {
        _controller!.play();
        _showPlayIcon = true;
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) setState(() => _showPlayIcon = false);
        });
      }
    });
  }

  void _showSubscriptionPaywall(String feature) {
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
              const SizedBox(height: 20),
              const Icon(Icons.workspace_premium, color: Colors.amber, size: 56),
              const SizedBox(height: 12),
              const Text(
                'Unlock Diamond Subscription',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upgrade to download and share high-resolution divine status clips with no watermark.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[300], fontSize: 14),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange.shade800, Colors.deepOrange.shade600],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Diamond Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text('Full Access to All 4K Wallpapers & Clips', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    Text('₹99/mo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  AppMembership.setPlan('Diamond');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Congratulations! You have unlocked Diamond VIP Plan!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Upgrade for ₹99/month', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Video Player or Thumbnail
          if (_controller != null && _controller!.value.isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            CachedNetworkImage(
              imageUrl: widget.clip.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.deepOrange),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.play_circle_outline, color: Colors.white54, size: 64),
              ),
            ),

          // 2. Play/Pause Animated Icon
          if (_showPlayIcon)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _controller?.value.isPlaying == true ? Icons.pause : Icons.play_arrow,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),

          // 3. Top Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
          ),

          // Top Title Bar
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('ॐ', style: TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(
                          AppLanguage.tr('clips_title'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text('Daily Darshan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom Gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                ),
              ),
            ),
          ),

          // 5. Right Action Bar (Reels Style)
          Positioned(
            right: 16,
            bottom: 40,
            child: Column(
              children: [
                // Like Button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _likeCount += _isLiked ? 1 : -1;
                    });
                  },
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? Colors.red : Colors.white,
                    size: 32,
                  ),
                ),
                Text(
                  '${(_likeCount / 1000).toStringAsFixed(1)}k',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),

                // Share Button (With Watermark for Free users, Clean for VIP)
                IconButton(
                  onPressed: () {
                    if (AppMembership.isDiamond) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Sharing HD Divine Clip in full bitrate with clean audio! (Diamond VIP Benefit) 🙏'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing with "Sanatani Astha" watermark for free users! Upgrade to Diamond VIP for clean HD sharing.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.share, color: Colors.white, size: 30),
                ),
                Text(
                  '${(widget.clip.shares / 1000).toStringAsFixed(1)}k',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),

                // Download Button (Diamond VIP Unlocked vs Paywall)
                ValueListenableBuilder<String>(
                  valueListenable: AppMembership.currentPlan,
                  builder: (context, plan, _) {
                    final isVip = AppMembership.isDiamond;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isVip) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('📥 Downloading HD Divine Clip without watermark! (Diamond VIP Benefit) 🙏'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          _showSubscriptionPaywall('download');
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isVip ? const Color(0xFF00B4D8) : Colors.amber,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (isVip ? const Color(0xFF00B4D8) : Colors.amber).withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(isVip ? Icons.download_done : Icons.download, color: isVip ? Colors.white : Colors.black87, size: 24),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(isVip ? Icons.diamond : Icons.workspace_premium, color: isVip ? const Color(0xFF00B4D8) : Colors.amber, size: 12),
                              const SizedBox(width: 2),
                              Text(
                                isVip ? 'VIP HD' : 'Diamond',
                                style: TextStyle(color: isVip ? const Color(0xFF00B4D8) : Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 6. Bottom Details (Title, Soundtrack)
          Positioned(
            left: 16,
            right: 80,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Deity Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.clip.deity,
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),

                // Title
                Text(
                  widget.clip.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Audio Track
                Row(
                  children: [
                    const Icon(Icons.music_note, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.clip.audioTrack,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 7. Video Progress Indicator
          if (_controller != null && _controller!.value.isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller!,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.deepOrange,
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
