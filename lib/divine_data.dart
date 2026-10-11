class DivineWallpaper {
  final String id;
  final String title;
  final String deity;
  final String imageUrl;
  final String downloads;
  final bool isPremium;

  const DivineWallpaper({
    required this.id,
    required this.title,
    required this.deity,
    required this.imageUrl,
    required this.downloads,
    this.isPremium = false,
  });
}

class DivineClipData {
  final String id;
  final String title;
  final String deity;
  final String audioTrack;
  final String videoUrl;
  final String thumbnailUrl;
  final int likes;
  final int shares;

  const DivineClipData({
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

class DivineRepository {
  static const List<DivineWallpaper> allWallpapers = [
    // --- MAHADEV (6 Wallpapers) ---
    DivineWallpaper(
      id: 'm1',
      title: 'Adiyogi Shiva Dhyan Mudra',
      deity: 'Mahadev',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Adiyogi_Shiva_steel_burst_2018.jpg/1280px-Adiyogi_Shiva_steel_burst_2018.jpg',
      downloads: '48.5k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'm2',
      title: 'Kempfort Shiva Murti Bangalore',
      deity: 'Mahadev',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Bangalore_Shiva.jpg/1280px-Bangalore_Shiva.jpg',
      downloads: '32.1k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'm3',
      title: 'Kedarnath Dham Sacred Peaks',
      deity: 'Mahadev',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Kedarnath_Temple_in_Rainy_season.jpg/1280px-Kedarnath_Temple_in_Rainy_season.jpg',
      downloads: '64.2k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'm4',
      title: 'Murudeshwar Shiva Ocean Cliff',
      deity: 'Mahadev',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Murudeshwar_Shiva_Statue.jpg/1280px-Murudeshwar_Shiva_Statue.jpg',
      downloads: '41.3k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'm5',
      title: 'Somnath Jyotirlinga Mandir',
      deity: 'Mahadev',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Somanath_mandir_%28cropped%29.jpg/1280px-Somanath_mandir_%28cropped%29.jpg',
      downloads: '29.7k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'm6',
      title: 'Kashi Vishwanath Jyotirlinga',
      deity: 'Mahadev',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/ff/Kashi_Vishwanath.jpg',
      downloads: '53.0k',
      isPremium: false,
    ),

    // --- SHREE RAM (6 Wallpapers) ---
    DivineWallpaper(
      id: 'r1',
      title: 'Shri Ram Janmabhoomi Mandir Ayodhya',
      deity: 'Shree Ram',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Shri_Ram_Janambhoomi_Mandir%2C_Ayodhya_Dham.jpg/1280px-Shri_Ram_Janambhoomi_Mandir%2C_Ayodhya_Dham.jpg',
      downloads: '78.6k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'r2',
      title: 'Bhagwan Ram Adhyatma Swaroop',
      deity: 'Shree Ram',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Rama_in_Adhyatma_Ramayana.jpg/960px-Rama_in_Adhyatma_Ramayana.jpg',
      downloads: '39.4k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'r3',
      title: 'Coronation of Rama (Ram Darbar)',
      deity: 'Shree Ram',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Coronation_of_Rama%2C_National_Museum%2C_New_Delhi_%28cropped%29.jpg/1280px-Coronation_of_Rama%2C_National_Museum%2C_New_Delhi_%28cropped%29.jpg',
      downloads: '46.1k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'r4',
      title: 'Lord Rama Raj Tilak Ramayana',
      deity: 'Shree Ram',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Lord_Rama_Raj_Tilak_Ramayana.jpg/1280px-Lord_Rama_Raj_Tilak_Ramayana.jpg',
      downloads: '33.8k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'r5',
      title: 'Fresco of Ram Darbar Shimla',
      deity: 'Shree Ram',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Fresco_of_Ram_Durbar_from_Rangmahal%2C_Chamba_now_in_Himachal_State_Museum%2C_Shimla.jpg/1280px-Fresco_of_Ram_Durbar_from_Rangmahal%2C_Chamba_now_in_Himachal_State_Museum%2C_Shimla.jpg',
      downloads: '27.9k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'r6',
      title: 'Rama Sita & Lakshman Divine Grace',
      deity: 'Shree Ram',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/50_Rama_and_Sita_%289122928457%29.jpg/1280px-50_Rama_and_Sita_%289122928457%29.jpg',
      downloads: '36.2k',
      isPremium: false,
    ),

    // --- SHREE KRISHNA (6 Wallpapers) ---
    DivineWallpaper(
      id: 'k1',
      title: 'Krishna Govardhan Dharan Leela',
      deity: 'Krishna',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a9/Krishna_Holds_Up_Mount_Govardhan_%28MET_70694%29_cropped.png',
      downloads: '52.4k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'k2',
      title: 'Prem Mandir Vrindavan Glow',
      deity: 'Krishna',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8e/PremMandirSideViewFromCanteen.jpg',
      downloads: '61.8k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'k3',
      title: 'Dwarkadhish Jagat Mandir Shikhara',
      deity: 'Krishna',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/0c/Dwarakadheesh_Temple%2C_2014.jpg',
      downloads: '38.2k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'k4',
      title: 'Radha Krishna Flowering Grove',
      deity: 'Krishna',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/4a1_Radha_and_Krishna_Walk_in_a_Flowering_Grove._Kota%2C_1720%2C_Metmuseum.jpg/1280px-4a1_Radha_and_Krishna_Walk_in_a_Flowering_Grove._Kota%2C_1720%2C_Metmuseum.jpg',
      downloads: '44.9k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'k5',
      title: 'Krishna Radha & Gopis Holi Leela',
      deity: 'Krishna',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/A_Holi_Festival_-_Krishna_Radha_and_Gopis.jpg/1280px-A_Holi_Festival_-_Krishna_Radha_and_Gopis.jpg',
      downloads: '31.5k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'k6',
      title: 'Divine Vrindavan Garden Leela',
      deity: 'Krishna',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/%27Krishna_and_Radha_Playing_with_Gopis_in_a_Garden%27%2C_dated_1770%2C_Honolulu_Museum_of_Art%2C_10918.1.JPG/1280px-%27Krishna_and_Radha_Playing_with_Gopis_in_a_Garden%27%2C_dated_1770%2C_Honolulu_Museum_of_Art%2C_10918.1.JPG',
      downloads: '28.3k',
      isPremium: false,
    ),

    // --- HANUMAN JI (6 Wallpapers) ---
    DivineWallpaper(
      id: 'h1',
      title: 'Veer Hanuman Siddheshwar Murti',
      deity: 'Hanuman Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Hanuman_Statue_at_Sidhheshwar_Temple%2C_Chhindwara%2C_MP.jpg/960px-Hanuman_Statue_at_Sidhheshwar_Temple%2C_Chhindwara%2C_MP.jpg',
      downloads: '58.0k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'h2',
      title: 'Jakhu Temple 108ft Bajrangbali',
      deity: 'Hanuman Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Jakhoo_temple.jpg/1280px-Jakhoo_temple.jpg',
      downloads: '49.1k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'h3',
      title: 'God Hanuman Statue Jaipur',
      deity: 'Hanuman Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/God_hanuman_statue_jaipur.jpg/960px-God_hanuman_statue_jaipur.jpg',
      downloads: '37.8k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'h4',
      title: 'Shree Hanuman Maha Murti',
      deity: 'Hanuman Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Shree_Hanuman_Statue.jpg/960px-Shree_Hanuman_Statue.jpg',
      downloads: '42.5k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'h5',
      title: 'Sankat Mochan Veera Gada',
      deity: 'Hanuman Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/59_Rama_SIta_and_Hunuman_%289122682861%29.jpg/1280px-59_Rama_SIta_and_Hunuman_%289122682861%29.jpg',
      downloads: '34.2k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'h6',
      title: 'Kesari Nandan Balaji Swaroop',
      deity: 'Hanuman Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/God_hanuman_statue_jaipur.jpg/1280px-God_hanuman_statue_jaipur.jpg',
      downloads: '29.7k',
      isPremium: false,
    ),

    // --- GANESH JI (6 Wallpapers) ---
    DivineWallpaper(
      id: 'g1',
      title: 'Lalbaugcha Raja Divya Swaroop',
      deity: 'Ganesh Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/71/Bappa.jpg',
      downloads: '84.4k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'g2',
      title: 'Siddhivinayak Temple Mumbai',
      deity: 'Ganesh Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Shree_Siddhivinayak_Temple_Mumbai.jpg/960px-Shree_Siddhivinayak_Temple_Mumbai.jpg',
      downloads: '56.9k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'g3',
      title: 'Basohli Ganesha Miniature Art',
      deity: 'Ganesh Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Ganesha_Basohli_miniature_circa_1730_Dubost_p73.jpg/960px-Ganesha_Basohli_miniature_circa_1730_Dubost_p73.jpg',
      downloads: '31.2k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'g4',
      title: 'Lord Ganesha Golden Murti',
      deity: 'Ganesh Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Lord_Ganesha_statue.jpg/960px-Lord_Ganesha_statue.jpg',
      downloads: '45.8k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'g5',
      title: 'Vighnaharta Ganesha Statue',
      deity: 'Ganesh Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/6c/Ganesha_statue.jpg',
      downloads: '39.6k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'g6',
      title: 'Shubh Labh Vinayak Darshan',
      deity: 'Ganesh Ji',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Lord_Ganesha_statue.jpg/1280px-Lord_Ganesha_statue.jpg',
      downloads: '32.1k',
      isPremium: false,
    ),

    // --- MAA DURGA (6 Wallpapers) ---
    DivineWallpaper(
      id: 'd1',
      title: 'Mahishasura Mardini Shakti Roopa',
      deity: 'Maa Durga',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/65/Mahishasura-Mardini_Durga.jpg',
      downloads: '51.2k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'd2',
      title: 'Durga Puja Kolkata Maha Darshan',
      deity: 'Maa Durga',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Durga_Idol%2C_Kolkata-01.jpg/1280px-Durga_Idol%2C_Kolkata-01.jpg',
      downloads: '68.8k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'd3',
      title: 'Maa Kamakhya Shakti Peeth',
      deity: 'Maa Durga',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Kamakhya_Temple_-_DEV_8829.jpg/1280px-Kamakhya_Temple_-_DEV_8829.jpg',
      downloads: '34.5k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'd4',
      title: 'Maa Simhavahini Jagdamba',
      deity: 'Maa Durga',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Durga_Idol%2C_Kolkata-01.jpg/960px-Durga_Idol%2C_Kolkata-01.jpg',
      downloads: '42.3k',
      isPremium: false,
    ),
    DivineWallpaper(
      id: 'd5',
      title: 'Navdurga Sacred Aarti Roopa',
      deity: 'Maa Durga',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/6/65/Mahishasura-Mardini_Durga.jpg',
      downloads: '38.7k',
      isPremium: true,
    ),
    DivineWallpaper(
      id: 'd6',
      title: 'Navratri Akhand Jyoti Darshan',
      deity: 'Maa Durga',
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Durga_Idol%2C_Kolkata-01.jpg/1280px-Durga_Idol%2C_Kolkata-01.jpg',
      downloads: '35.0k',
      isPremium: false,
    ),
  ];

  static const List<DivineClipData> allClips = [
    DivineClipData(
      id: 'clip_mahadev',
      title: 'Har Har Mahadev | Kashi Vishwanath Aarti 🔱',
      deity: 'Mahadev',
      audioTrack: '♫ Shiv Tandav Stotram - Sacred Chants',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Adiyogi_Shiva_steel_burst_2018.jpg/1280px-Adiyogi_Shiva_steel_burst_2018.jpg',
      likes: 24500,
      shares: 6200,
    ),
    DivineClipData(
      id: 'clip_krishna',
      title: 'Radhe Krishna | Divine Vrindavan Sandhya 🦚',
      deity: 'Krishna',
      audioTrack: '♫ Madhurashtakam - Sacred Flute',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8e/PremMandirSideViewFromCanteen.jpg',
      likes: 31200,
      shares: 8900,
    ),
    DivineClipData(
      id: 'clip_ram',
      title: 'Jai Shree Ram | Ayodhya Dham Evening Darshan 🏹',
      deity: 'Shree Ram',
      audioTrack: '♫ Ram Siya Ram - Divine Melodies',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/Shri_Ram_Janambhoomi_Mandir%2C_Ayodhya_Dham.jpg/1280px-Shri_Ram_Janambhoomi_Mandir%2C_Ayodhya_Dham.jpg',
      likes: 45600,
      shares: 14200,
    ),
    DivineClipData(
      id: 'clip_hanuman',
      title: 'Shree Hanuman Chalisa | Sankat Mochan Darshan 🚩',
      deity: 'Hanuman Ji',
      audioTrack: '♫ Hanuman Chalisa - Hariharan',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Jakhoo_temple.jpg/1280px-Jakhoo_temple.jpg',
      likes: 28900,
      shares: 9300,
    ),
    DivineClipData(
      id: 'clip_ganesh',
      title: 'Lalbaugcha Raja | Ganpati Bappa Morya Aarti',
      deity: 'Ganesh Ji',
      audioTrack: '♫ Sukh Karta Dukh Harta - Sacred Aarti',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/7/71/Bappa.jpg',
      likes: 38100,
      shares: 11800,
    ),
    DivineClipData(
      id: 'clip_durga',
      title: 'Maa Durga | Kolkata Maha Aarti Darshan 🌸',
      deity: 'Maa Durga',
      audioTrack: '♫ Aigiri Nandini - Mahishasura Mardini Stotram',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      thumbnailUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/01/Durga_Idol%2C_Kolkata-01.jpg/1280px-Durga_Idol%2C_Kolkata-01.jpg',
      likes: 29400,
      shares: 7700,
    ),
  ];

  static List<DivineWallpaper> filterWallpapers({String? deity, String? searchQuery}) {
    return allWallpapers.where((w) {
      final matchesDeity = deity == null || deity == 'All' || w.deity.toLowerCase() == deity.toLowerCase();
      final matchesQuery = searchQuery == null ||
          searchQuery.trim().isEmpty ||
          w.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          w.deity.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesDeity && matchesQuery;
    }).toList();
  }

  static List<DivineClipData> filterClips({String? deity, String? searchQuery}) {
    return allClips.where((c) {
      final matchesDeity = deity == null || deity == 'All' || c.deity.toLowerCase() == deity.toLowerCase();
      final matchesQuery = searchQuery == null ||
          searchQuery.trim().isEmpty ||
          c.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          c.deity.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesDeity && matchesQuery;
    }).toList();
  }
}
