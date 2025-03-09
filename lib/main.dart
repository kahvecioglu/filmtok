import 'package:filmtok/screens/homepage.dart';
import 'package:filmtok/screens/signin.dart';
import 'package:filmtok/splash_and_onboarding/splash_screen.dart';
import 'package:filmtok/state_management/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase başarıyla başlatıldı!");
  } catch (e) {
    print("Firebase başlatma hatası: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteMoviesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AuthWrapper());
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Yükleme ekranı
          );
        }

        if (snapshot.hasData) {
          return HomeScreen(); // Kullanıcı giriş yapmışsa HomeScreen'e yönlendir
        } else {
          return SplashScreen(); // Kullanıcı giriş yapmamışsa giriş ekranına yönlendir
        }
      },
    );
  }
}
