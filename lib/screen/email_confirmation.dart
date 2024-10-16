import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailConfirmationPage extends StatefulWidget {
  final String email;

  const EmailConfirmationPage({super.key, required this.email});

  @override
  _EmailConfirmationPageState createState() => _EmailConfirmationPageState();
}

class _EmailConfirmationPageState extends State<EmailConfirmationPage> {
  late Timer _timer;
  bool _isVerified = false;
  String _errorMessage = ''; // 에러 메시지 저장

  @override
  void initState() {
    super.initState();
    // 주기적으로 이메일 인증 여부를 확인
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // 타이머 해제
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;

    // 사용자 정보 갱신
    await user?.reload();

    // 인증 상태를 확인
    if (user != null && user.emailVerified) {
      _timer.cancel(); // 타이머 중지
      print("Email is verified!"); // 콘솔에 인증 완료 로그 출력
      setState(() {
        _isVerified = true;
      });

      // 인증이 완료되었으면 비밀번호 생성 페이지로 이동
      Navigator.pushReplacementNamed(context, '/password-creation');
    } else {
      print("Email is not yet verified"); // 콘솔에 인증 미완료 로그 출력
      setState(() {
        _errorMessage = 'Email not verified yet. Please check your inbox.';
      });
    }
  }

  // 이메일 인증 재전송 함수
  Future<void> _sendEmailVerification() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload(); // 사용자 정보 갱신

        // 이미 인증된 사용자 처리
        if (user.emailVerified) {
          setState(() {
            _errorMessage = 'This email is already verified. Please log in.';
          });
          return;
        }

        // 인증되지 않은 사용자에 대해서만 이메일 재전송
        await user.sendEmailVerification();
        setState(() {
          _errorMessage = 'Verification email resent. Please check your inbox.';
        });
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              "Confirm your email address",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Check your inbox and tap the link in the email we've just sent to:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.email,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  checkEmailVerified(); // 버튼을 눌러서도 확인 가능
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A61FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Open email app',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _sendEmailVerification, // 이메일 재전송 버튼
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(color: Color(0xFF8A61FF), width: 2),
                ),
                child: const Text(
                  'Resend verification email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A61FF),
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
            if (!_isVerified)
              const Text(
                "Waiting for email verification...",
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
