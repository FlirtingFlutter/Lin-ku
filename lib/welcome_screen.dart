//welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:linkuapp/login/google_login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          // 이미지 부분
          Expanded(
            flex: 4,
            child: Container(
              color: Color(0xFFCEE3FF), // 이미지 배경색
              child: Center(
                child: Image.asset('assets/logo.png', height: 200), // 로고 이미지
              ),
            ),
          ),
          // 텍스트 부분
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
                children: [
                  SizedBox(height: 20), // 텍스트를 아래로 내리기 위한 SizedBox
                  Text(
                    'Welcome to App',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Here's a good place for a brief overview \n of the app or its key features.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 4.5,
                        backgroundColor: Color(0xFF8A61FF),
                      ),
                      SizedBox(width: 5),
                      CircleAvatar(radius: 4.5, backgroundColor: Colors.grey),
                      SizedBox(width: 5),
                      CircleAvatar(radius: 4.5, backgroundColor: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 버튼 부분
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 400, // 버튼의 너비를 조정
                height: 50, // 버튼의 높이를 적절히 조정
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 1, // 바텀 시트 높이를 화면 높이의 75%로 설정
                          child: LoginSignUpSheet(),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A61FF), // 버튼 색상 변경
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 하단 여백 조정
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class LoginSignUpSheet extends StatelessWidget {
  const LoginSignUpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Center(
            child: Text(
              'Login or sign up',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Please select your preferred method\n to continue setting up your account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8A61FF),
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text(
              'Continue with Email',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text(
              'Continue with Phone',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () async {
                  await signInWithGoogle();
                },
                style: OutlinedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(0), // 패딩을 줄여서 이미지가 버튼 안에서 커지도록 설정
                ),
                child: Image.asset(
                  'assets/google2.png',
                  height: 52, // 이미지 크기 조정
                  width: 52,
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  side: BorderSide(
                    color: Color.fromARGB(255, 110, 110, 110),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  Icons.apple,
                  size: 32,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'If you are creating a new account.\nTerms & Conditions and Privacy Policy will apply.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
