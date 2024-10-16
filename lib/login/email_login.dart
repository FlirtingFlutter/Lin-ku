import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linkuapp/screen/email_confirmation.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isSubscribed = false;
  bool _isLogin = true; // 로그인 모드인지 회원가입 모드인지 체크하는 변수
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _errorMessage = '';

  // 이메일 로그인 로직
  Future<void> _loginWithEmailPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/home'); // 로그인 성공 시 메인 화면으로 이동
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed. Please try again.';
      });
    }
  }

 // 회원가입 로직 수정
Future<void> _registerWithEmailPassword() async {
  try {
    // 이메일과 임시 비밀번호로 사용자 생성
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: 'temporaryPassword123!',  // 임시 비밀번호 설정
    );
    
    // 생성된 사용자 객체 가져오기
    User? user = userCredential.user;

    // 사용자 객체가 존재하고 이메일 인증이 완료되지 않았으면 이메일 인증 링크 전송
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();  // 이메일 인증 링크 전송
      // 이메일 인증 확인 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailConfirmationPage(email: _emailController.text.trim()),
        ),
      );
    }
  } catch (e) {
    // 에러 발생 시 에러 메시지 출력
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
            Text(
              _isLogin ? "Login with Email" : "Sign up with Email",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isLogin
                  ? "Please enter your email and password to log in."
                  : "Please enter your email address to sign up.",
              style: const TextStyle(
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
            const SizedBox(height: 20),
            if (_isLogin) // 로그인 모드일 때만 비밀번호 필드를 보이도록 처리
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            if (_isLogin) const SizedBox(height: 20), // 비밀번호 필드와 로그인 모드 간격 조정

            if (_isLogin) // 로그인 모드일 때만 'Stay up to date' 체크박스를 표시
              Row(
                children: [
                  Checkbox(
                    value: isSubscribed,
                    onChanged: (value) {
                      setState(() {
                        isSubscribed = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Stay up to date with the latest news and resources delivered directly to your inbox",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLogin
                    ? _loginWithEmailPassword // 로그인 로직 호출
                    : _registerWithEmailPassword, // 회원가입 로직 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A61FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isLogin
                      ? 'Login'
                      : 'Continue', // 로그인 모드면 'Login', 회원가입 모드면 'Continue'
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin; // 로그인/회원가입 모드 전환
                });
              },
              child: Text(
                _isLogin
                    ? "Don't have an account? Sign up"
                    : "Already have an account? Log in",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8A61FF),
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
