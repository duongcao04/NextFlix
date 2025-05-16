// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nextflix/login/auth/logic_firebase.dart';
import 'package:nextflix/login/screens/forgot_password.dart';
import 'package:nextflix/login/screens/register_screen.dart';
import 'package:nextflix/login/widgets/textfile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ignore: unused_field
  final TextEditingController _emailController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    final userCredential = await signInWithGoogle();
    if (userCredential != null) {
      print('User signed in: ${userCredential.user?.displayName}');
      // Xử lý chuyển trang, lưu thông tin, ...
    } else {
      print('Google sign-in aborted');
    }
  }

  // ignore: unused_element
  Future<void> _handleFacebookLogin() async {
    User? user = await signInWithFacebook();
    if (user != null) {
      print('Logged in successfully! User: ${user.displayName}');
      // Xử lý chuyển màn hình hoặc lưu user
    } else {
      print('Login failed or cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'Flix',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    const TextSpan(text: 'Xin chào bạn đến với '),
                    TextSpan(
                      text: 'Next',
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Flix',
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Container(
                child: Text(
                  'Email',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              TextFill(
                hintText: 'Nhập email của bạn',
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Text(
                  'Mật khẩu',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              TextFill(
                hintText: 'Nhập mật khẩu của bạn',
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xff1E4AE9),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                  ),
                  child: Text('Quên mật khẩu?'),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed:
                    () => signIn(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff313957),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Or sign in with",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  // Nút Google
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: Image.asset(
                        'assets/images/google.png',
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.dst,
                        filterQuality: FilterQuality.high,
                      ),
                      label: Text('Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF3F9FA),
                        foregroundColor: Colors.black,
                        splashFactory: NoSplash.splashFactory,
                        // side: BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nút Facebook
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleFacebookLogin,
                      icon: Icon(
                        Icons.facebook,
                        color: Color(0xff1877F2),
                        size: 30,
                      ),
                      label: Text('Facebook', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF3F9FA),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn chưa có tài khoản? ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(color: Color(0xff1E4AE9), fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
