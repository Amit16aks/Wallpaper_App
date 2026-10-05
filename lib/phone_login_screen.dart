import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart'; // To navigate to HomeScreen

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  
  bool _isLoading = false;
  bool _codeSent = false;
  String _verificationId = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (_phoneController.text.trim().isEmpty || _phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String phoneNumber = '+91${_phoneController.text.trim()}'; // Default to India

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution on Android devices
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Phone auth failed: ${e.message}");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Verification failed')),
            );
            setState(() {
              _isLoading = false;
            });
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (mounted) {
            setState(() {
              _verificationId = verificationId;
              _codeSent = true;
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP sent successfully!')),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().isEmpty || _otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit OTP')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("OTP Verification failed: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepOrange),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phone_android,
                  size: 80,
                  color: Colors.deepOrange,
                ),
                const SizedBox(height: 24),
                Text(
                  _codeSent ? 'Enter OTP' : 'Continue with Phone',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _codeSent
                      ? 'We have sent a 6-digit code to +91 ${_phoneController.text}'
                      : 'You will receive a 6-digit code to verify your number.',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (!_codeSent) ...[
                  // PHONE NUMBER INPUT
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      prefixStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      labelText: 'Phone Number',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.deepOrange)
                      : ElevatedButton(
                          onPressed: _sendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Send OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                ] else ...[
                  // OTP INPUT
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '------',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.deepOrange)
                      : ElevatedButton(
                          onPressed: _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Verify & Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _codeSent = false;
                        _otpController.clear();
                      });
                    },
                    child: const Text('Change Phone Number', style: TextStyle(color: Colors.deepOrange)),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
