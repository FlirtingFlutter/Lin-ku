import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkuapp/screen/email_confirmation.dart';

class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({super.key});

  @override
  _EmailSignUpPageState createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  Future<void> _sendEmailVerification() async {
    try {
      List<String> methods =
          await _auth.fetchSignInMethodsForEmail(_emailController.text.trim());

      // 이미 가입된 사용자인 경우
      if (methods.isNotEmpty) {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: 'temporaryPassword', // 임시 비밀번호 사용
        );

        User? user = credential.user;

        if (user != null && !user.emailVerified) {
          // 이미 가입되었지만 인증되지 않은 경우
          await user.sendEmailVerification();
          setState(() {
            _errorMessage =
                'Verification email resent. Please check your inbox.';
          });

          // 이메일 확인 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmailConfirmationPage(email: _emailController.text.trim()),
            ),
          );
        } else if (user != null && user.emailVerified) {
          // 이미 이메일이 인증된 경우
          setState(() {
            _errorMessage = 'This email is already verified. Please log in.';
          });
        } else {
          setState(() {
            _errorMessage = 'An error occurred. Please try again.';
          });
        }
      } else {
        // 새 사용자 생성
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: 'temporaryPassword', // 임시 비밀번호 설정
        );

        User? user = userCredential.user;

        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmailConfirmationPage(email: _emailController.text.trim()),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send verification email. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: const Color(0xFF8A61FF),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.email, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Get going with email",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please enter your email address to start.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF8A61FF),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF8A61FF),
                    width: 2,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _sendEmailVerification, // 이메일 인증 요청
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A61FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
