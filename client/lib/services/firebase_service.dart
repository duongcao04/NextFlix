import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nextflix/constants/routes.dart';

//cái này là đăng nhập tài khoản nha mấy ní
Future<void> signIn(BuildContext context, String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công!')));
    Navigator.pushNamed(context, Routes.homeScreen);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
  }
}

//cái này là đăng kí tài khoản nha mấy ní
Future<void> register(
  BuildContext context,
  String email,
  String password,
  String confirmPassword,
) async {
  final emailTrimmed = email.trim();
  final passwordTrimmed = password.trim();
  final confirmPasswordTrimmed = confirmPassword.trim();

  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  if (!emailRegex.hasMatch(emailTrimmed)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email không đúng định dạng.')),
    );
    return;
  }

  if (emailTrimmed.isEmpty ||
      passwordTrimmed.isEmpty ||
      confirmPasswordTrimmed.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
    );
    return;
  }

  if (passwordTrimmed != confirmPasswordTrimmed) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp.')));
    return;
  }

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailTrimmed,
      password: passwordTrimmed,
    );
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đăng kí thất bại: $e')));
  }
}

//cái này là đăng nhập bằng tài khoản google nha mấy ní
Future<UserCredential?> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // Người dùng hủy đăng nhập
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Error signing in with Google: $e');
    return null;
  }
}

//cái này là đăng nhập bằng tài khoản facebook nha mấy ní

// Hàm đăng nhập Facebook và Firebase
Future<User?> signInWithFacebook() async {
  try {
    // 1. Bắt đầu Facebook login
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // 2. Lấy access token từ Facebook
      final AccessToken accessToken = result.accessToken!;

      // 3. Tạo credential cho Firebase
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      // 4. Đăng nhập Firebase bằng credential Facebook
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      // 5. Trả về user Firebase
      return userCredential.user;
    } else if (result.status == LoginStatus.cancelled) {
      print('User cancelled Facebook login');
      return null;
    } else {
      print('Facebook login failed: ${result.message}');
      return null;
    }
  } catch (e) {
    print('Error signing in with Facebook: $e');
    return null;
  }
}
