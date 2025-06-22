import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextflix/screens/forgot_password_screen.dart';
import 'package:nextflix/screens/register_screen.dart';
import 'package:nextflix/widgets/textfield.dart';
import 'package:nextflix/blocs/authentication_bloc.dart';
import 'package:nextflix/routes/app_router.dart';
import 'package:nextflix/routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailPasswordSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authBloc = context.read<AuthenticationBloc>();
      await authBloc.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(_getErrorMessage(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    print('🔵 LoginScreen: Starting Google Sign-In...');
    setState(() => _isLoading = true);

    try {
      final authBloc = context.read<AuthenticationBloc>();
      print('🔵 LoginScreen: Got AuthBloc, calling signInWithGoogle...');

      final userCredential = await authBloc.signInWithGoogle();
      print(
        '🔵 LoginScreen: signInWithGoogle returned: ${userCredential != null}',
      );

      if (userCredential != null && mounted) {
        print('🟢 LoginScreen: User signed in successfully');
        // BlocListener sẽ handle navigation
      } else {
        print('🟡 LoginScreen: Sign-in cancelled or failed');
        if (mounted) {
          _showErrorSnackBar('Đăng nhập Google bị hủy');
        }
      }
    } catch (e) {
      print('🔴 LoginScreen: Google sign-in error: $e');
      if (mounted) {
        _showErrorSnackBar(
          'Đăng nhập Google thất bại: ${_getErrorMessage(e.toString())}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleFacebookLogin() async {
    setState(() => _isLoading = true);

    try {
      final authBloc = context.read<AuthenticationBloc>();
      final user = await authBloc.signInWithFacebook();

      if (user != null && mounted) {
        print('Logged in successfully! User: ${user.displayName}');
        // The AuthenticationBloc will automatically handle the navigation via listener
      } else {
        if (mounted) {
          _showErrorSnackBar('Đăng nhập Facebook bị hủy');
        }
        print('Facebook login failed or cancelled');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(
          'Đăng nhập Facebook thất bại: ${_getErrorMessage(e.toString())}',
        );
      }
      print('Facebook login error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getErrorMessage(String error) {
    // Convert technical error messages to user-friendly Vietnamese messages
    if (error.contains('user-not-found')) {
      return 'Không tìm thấy tài khoản với email này';
    } else if (error.contains('wrong-password')) {
      return 'Mật khẩu không chính xác';
    } else if (error.contains('invalid-email')) {
      return 'Email không hợp lệ';
    } else if (error.contains('user-disabled')) {
      return 'Tài khoản đã bị vô hiệu hóa';
    } else if (error.contains('too-many-requests')) {
      return 'Quá nhiều lần thử. Vui lòng thử lại sau';
    } else if (error.contains('network-request-failed')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra internet';
    } else if (error.contains('account-exists-with-different-credential')) {
      return 'Tài khoản đã tồn tại với phương thức đăng nhập khác';
    } else {
      return 'Đã xảy ra lỗi. Vui lòng thử lại';
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationAuthenticated) {
            _showSuccessSnackBar('Đăng nhập thành công!');
            AppRouter.appRouter.go(Routes.home);
          } else if (state is AuthenticationError) {
            _showErrorSnackBar(state.message);
          }

          // Update loading state based on authentication state
          if (state is AuthenticationLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  // Logo
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
                  // Welcome message
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

                  // Email field
                  Container(
                    child: Text(
                      'Email',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  TextFill(
                    hintText: 'Nhập email của bạn',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password field
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Forgot password
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
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

                  // Login button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleEmailPasswordSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff313957),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                  const SizedBox(height: 40),

                  // Divider
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Hoặc đăng nhập với",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Social login buttons
                  Row(
                    children: [
                      // Google button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          icon:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                  : Image.asset(
                                    'assets/images/google.png',
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.g_mobiledata,
                                        color: Colors.red,
                                        size: 24,
                                      );
                                    },
                                  ),
                          label: Text(
                            'Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffF3F9FA),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            elevation: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Facebook button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _handleFacebookLogin,
                          icon:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                  : Icon(
                                    Icons.facebook,
                                    color: Color(0xff1877F2),
                                    size: 28,
                                  ),
                          label: Text(
                            'Facebook',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffF3F9FA),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            elevation: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Register link
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
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                            color: Color(0xff1E4AE9),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
