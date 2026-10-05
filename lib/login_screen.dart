import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';
import 'phone_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // 40-second continuous rotation for the background mandalas
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User canceled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigation is handled automatically by the StreamBuilder in main.dart
    } catch (e) {
      debugPrint("Error signing in with Google: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      body: Stack(
        children: [
          // Animated Background Mandala 1 (Top Left)
          Positioned(
            top: -150,
            left: -150,
            child: RotationTransition(
              turns: _animationController,
              child: Icon(
                Icons.brightness_7, // Acts as a beautiful floral/mandala pattern
                size: 500,
                color: Colors.deepOrange.withOpacity(0.06),
              ),
            ),
          ),
          
          // Animated Background Mandala 2 (Bottom Right, rotating opposite direction)
          Positioned(
            bottom: -200,
            right: -200,
            child: RotationTransition(
              turns: Tween(begin: 1.0, end: 0.0).animate(_animationController),
              child: Icon(
                Icons.brightness_low,
                size: 600,
                color: Colors.deepOrange.withOpacity(0.08),
              ),
            ),
          ),
          
          // Original UI Layout
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Transparent Ganesha Logo
                    Image.asset(
                      'assets/images/ganesha.png',
                      height: 140,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome to Sanatani Astha',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Begin your spiritual journey with daily divine darshan.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.deepOrange)
                        : Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _signInWithGoogle,
                                icon: const Icon(Icons.login),
                                label: const Text(
                                  'Sign in with Google',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.deepOrange,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  elevation: 4,
                                  minimumSize: const Size(250, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
                                  );
                                },
                                icon: const Icon(Icons.phone),
                                label: const Text(
                                  'Continue with Phone',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.deepOrange,
                                  side: const BorderSide(color: Colors.deepOrange, width: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  minimumSize: const Size(250, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      child: const Text(
                        'Skip (Dev Mode)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
