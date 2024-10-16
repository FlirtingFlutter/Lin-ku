import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordCreationPage extends StatefulWidget {
  const PasswordCreationPage({super.key});

  @override
  _PasswordCreationPageState createState() => _PasswordCreationPageState();
}

class _PasswordCreationPageState extends State<PasswordCreationPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool _isPasswordValid = false;

  // 각 조건을 만족하는지에 대한 상태
  bool _hasMinLength = false;
  bool _hasLowercase = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  // 조건을 검사하는 함수
  void _checkPassword(String password) {
    setState(() {
      _hasMinLength = password.length >= 8 && password.length <= 16;
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!?@#\$%^&*]'));
      _isPasswordValid = _hasMinLength &&
          _hasLowercase &&
          _hasUppercase &&
          _hasNumber &&
          _hasSpecialChar;
    });
  }

  // 비밀번호를 생성하려고 할 때의 함수
  Future<void> _submitPassword() async {
    if (_isPasswordValid) {
      try {
        User? user = _auth.currentUser; // 현재 사용자 가져오기

        if (user != null) {
          // 비밀번호 업데이트
          await user.updatePassword(_passwordController.text);
          print('Password updated successfully');

          // 비밀번호 업데이트 성공 후 다음 페이지로 이동하거나 필요한 작업 처리
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('비밀번호가 성공적으로 업데이트되었습니다.')),
          );

          // 원하는 페이지로 이동 (예: 홈 화면)
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        print('Error updating password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호 업데이트에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    } else {
      setState(() {}); // 조건에 맞지 않은 경우 글자를 빨간색으로 변경하기 위해 setState 호출
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
            const Text(
              "비밀번호 생성",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              onChanged: _checkPassword, // 비밀번호가 변경될 때마다 조건을 검사
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
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
            const Text(
              "Your password must include:",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            _buildPasswordCondition("8-16자 사이", _hasMinLength),
            _buildPasswordCondition("소문자 알파벳 (a-z)", _hasLowercase),
            _buildPasswordCondition("대문자 알파벳 (A-Z)", _hasUppercase),
            _buildPasswordCondition("숫자", _hasNumber),
            _buildPasswordCondition(
                "특수문자 (! ? @ # \$ % ^ & *)", _hasSpecialChar),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitPassword,
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
          ],
        ),
      ),
    );
  }

  // 비밀번호 조건을 만족할 때와 만족하지 않을 때 UI 변화
  Widget _buildPasswordCondition(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.clear,
          color: isValid ? Colors.black : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.black : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
