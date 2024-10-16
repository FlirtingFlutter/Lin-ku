import 'package:firebase_core/firebase_core.dart';
import 'package:linkuapp/screen/email_confirmation.dart';
import 'package:linkuapp/screen/home_screen.dart';
import 'package:linkuapp/screen/password_creation.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'login/email_login.dart';

void main() async {
  //debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lin-ku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/email-login': (context) => const EmailLoginPage(), // 이메일 로그인 페이지
        '/password-creation': (context) =>
            const PasswordCreationPage(), // 비밀번호 생성 페이지
        '/email-confirmation': (context) =>
            const EmailConfirmationPage(email: ''), // 이메일 확인 페이지
        '/home': (context) => const HomeScreen(), // 임시 홈
      },
    );
  }
}
