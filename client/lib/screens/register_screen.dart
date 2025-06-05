import 'package:flutter/material.dart';
import 'package:nextflix/blocs/authentication_bloc.dart';
import 'package:nextflix/widgets/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Đăng ký',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              Text(
                'Vui lòng đăng ký',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Tên tài khoản',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 5),
              TextFill(
                hintText: 'Nhập tên của bạn',
                controller: nameController,
              ),
              const SizedBox(height: 10),
              Text(
                'Email',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 5),
              TextFill(
                hintText: 'Nhập email của bạn',
                controller: emailController,
              ),
              const SizedBox(height: 10),
              Text(
                'Mật khẩu',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 5),
              TextFill(
                hintText: 'Nhập mật khẩu của bạn',
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              Text(
                'Xác nhận mật khẩu',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 5),
              TextFill(
                hintText: 'Nhập lại mật khẩu của bạn',
                isPassword: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    () => (
                      context,
                      emailController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff313957),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bạn đã có tài khoản? ',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 16, color: Color(0xff1E4AE9)),
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
