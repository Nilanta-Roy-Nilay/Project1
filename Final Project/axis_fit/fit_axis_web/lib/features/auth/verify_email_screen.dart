import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
      // Email verified! Sign out and show login screen
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _showVerificationSuccess();
      }
    }
  }

  void _showVerificationSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        title: const Text('Email Verified!'),
        content: const Text(
          'Your email has been verified successfully.\n\n'
          'Please log in with your email and password to continue.',
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // Sign out the user so they have to log in again
              await Provider.of<AuthService>(context, listen: false).signOut();
              // The main.dart will automatically show login screen
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) setState(() => canResendEmail = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 100, color: Colors.white70),
            const SizedBox(height: 24),
            Text(
              'A verification email has been sent to your email address.',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Please click the link in the email to verify your account.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              isEmailVerified
                  ? '✅ Email Verified!'
                  : '⏳ Checking verification...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isEmailVerified ? Colors.green : Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.email, color: Colors.black),
              label: const Text('Resend Email'),
              onPressed: canResendEmail ? sendVerificationEmail : null,
            ),
            const SizedBox(height: 16),
            TextButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 20)),
              onPressed: () =>
                  Provider.of<AuthService>(context, listen: false).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}