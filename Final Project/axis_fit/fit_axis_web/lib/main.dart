import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/core/app_theme.dart';
import 'package:fitness/core/theme_provider.dart';
import 'package:fitness/features/auth/login_screen.dart';
import 'package:fitness/features/auth/verify_email_screen.dart';
import 'package:fitness/features/home/dashboard_screen.dart';
import 'package:fitness/services/auth_service.dart';
import 'package:fitness/services/firestore_service.dart';
import 'package:fitness/services/gemini_service.dart';
import 'package:fitness/services/notification_service.dart';
import 'package:fitness/services/step_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Robust Firebase Initialization
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Firebase initialization info: $e");
  }

  // Initialize notifications safely
  try {
    final notificationService = NotificationService();
    await notificationService.init();
    await notificationService.scheduleDailyNotification();
  } catch (e) {
    debugPrint("Notification service initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<GeminiService>(create: (_) => GeminiService()),
        ProxyProvider2<AuthService, FirestoreService, StepService?>(
          update: (_, auth, firestore, previous) {
            final user = auth.currentUser;
            if (user != null) {
              return previous ?? StepService(firestore, user.uid);
            } else {
              previous?.dispose();
              return null;
            }
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fit Axis',
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Handle loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Once we have a connection (active or done), check for user
        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        } else if (user.emailVerified) {
          return const DashboardScreen();
        } else {
          return const VerifyEmailScreen();
        }
      },
    );
  }
}
