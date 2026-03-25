import 'package:book_store_mobile_app/core/routes.dart';
import 'package:book_store_mobile_app/services/auth_service.dart';
import 'package:book_store_mobile_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  final AuthService _authService = AuthService();

  void _signup() async {
    // 1. Kiểm tra tính hợp lệ của Form
    if (!_formKey.currentState!.validate()) return;

    // 2. Bắt đầu trạng thái Loading
    setState(() => _isLoading = true);

    try {
      // 3. Gọi API đăng ký qua AuthService
      final result = await _authService.register(
        _usernameController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );

      // 4. Kiểm tra xem Widget còn trên màn hình không
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success']) {
        // 5. HIỂN THỊ SUCCESS DIALOG THEO THEME CỦA APP
        showDialog(
          context: context,
          barrierDismissible: false, // Bắt buộc tương tác với nút
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accent, // Sử dụng Emerald Green từ AppColors
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  "Account Created!",
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 20),
                ),
              ],
            ),
            content: Text(
              "Your account has been successfully created. \n\n"
              "Please log in and visit your profile to complete your personal information (Phone, Address, etc.).",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Nút này sẽ tự động ăn theo style của elevatedButtonTheme bạn đã định nghĩa
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng Dialog
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    ); // Về Login
                  },
                  child: const Text("GO TO LOGIN"),
                ),
              ),
            ],
          ),
        );
      } else {
        // 6. HIỂN THỊ LỖI NẾU ĐĂNG KÝ THẤT BẠI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? "Registration failed. Please try again.",
            ),
            backgroundColor:
                AppColors.error, // Sử dụng Alizarin Red từ AppColors
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      // 7. XỬ LÝ LỖI HỆ THỐNG / KẾT NỐI
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: ${e.toString()}"),
          backgroundColor:
              AppColors.price, // Dùng màu cam để cảnh báo lỗi hệ thống
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text("Create Account"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Join Us",
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge,
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) => (value == null || value.length < 3)
                      ? "Minimum 3 characters"
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? "Username is required"
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return "Minimum 6 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmController,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: Icon(Icons.check_circle_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text)
                      return "Passwords do not match";
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signup,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "REGISTER NOW",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
