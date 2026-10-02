import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Direct Firebase Connection (Bypasses Gradle)
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAvwtUeO9MKwDJ0orK_FQ_IdxaTcIUPsik', 
        appId: '1:304458629491:android:d9689f9dff2f0bafeb8506', 
        messagingSenderId: '304458629491', 
        projectId: 'hindu-wallpaper-app-61376',
      ),
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  
  runApp(const HinduWallpaperApp());
}

class HinduWallpaperApp extends StatelessWidget {
  const HinduWallpaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hindu Wallpaper App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            // User is signed in
            return const HomeScreen();
          }
          // User is not signed in
          return const LoginScreen();
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Om - Daily Darshan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
            },
          ),
        ],
      ),
      // StreamBuilder listens to your live database collection!
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('wallpapers').snapshots(),
        builder: (context, snapshot) {
          // Show a loading circle while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Show a message if there's an error
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          // Show a message if the database is empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No wallpapers found. Add some in Firebase!',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.55,
              ),
              itemBuilder: (context, index) {
                // Extract the specific 'url' field from your database document
                final data = docs[index].data() as Map<String, dynamic>;
                final imageUrl = data['url'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenScreen(imageUrl: imageUrl),
                      ),
                    );
                  },
                  child: Hero(
                    tag: imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isEmpty 
                        ? Container(color: Colors.grey[300])
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FullScreenScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.white)),
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 50)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download feature coming soon!')),
          );
        },
        label: const Text('Download'),
        icon: const Icon(Icons.download),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}