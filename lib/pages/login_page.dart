import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final AuthController authController = Get.put(AuthController());

  bool isBtnHover = false;
  bool isBtnPressed = false;

  final Color primaryDark = const Color.fromARGB(255, 52, 51, 51);
  final Color accentRed = const Color.fromARGB(255, 52, 51, 51);
  final Duration animDuration = const Duration(milliseconds: 230);

  @override
  Widget build(BuildContext context) {
    final double topHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section
            Container(
              height: topHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFD84336),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icon.png',
                  width: 140,
                  height: 140,
                ),
              ),
            ),

            const SizedBox(height: 18),
            const Text(
              "SIGMA APP",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 52, 51, 51),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Login Untuk Melanjutkan",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
              child: Column(
                children: [
                  _animatedTextField(
                    controller: usernameController,
                    focusNode: usernameFocus,
                    hint: 'Username',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _animatedTextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 24),

                  // The button with API call
                  Obx(() => _animatedButton(
                        text: authController.isLoading.value ? 'Loading...' : 'Login',
                        onTap: authController.isLoading.value
                            ? () {}
                            : () async {
                                bool success = await authController.login(
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
                                );

                                if (success) {
                                  Get.snackbar("Success", "Login successful!");
                                  Get.offNamed('/dashboard');
                                } else {
                                  Get.snackbar("Error", "Invalid username or password");
                                }
                              },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
  }) {
    final bool focused = focusNode.hasFocus;
    return AnimatedContainer(
      duration: animDuration,
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: focused ? accentRed : Colors.grey.shade300,
          width: focused ? 2 : 1,
        ),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        cursorColor: accentRed,
        obscureText: hint.toLowerCase().contains('password'),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: focused ? accentRed : Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _animatedButton({required VoidCallback onTap, required String text}) {
    final Color btnColor = isBtnHover ? accentRed : primaryDark;
    final double scale = isBtnPressed ? 0.98 : (isBtnHover ? 1.03 : 1.0);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isBtnHover = true),
      onExit: (_) => setState(() => isBtnHover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isBtnPressed = true),
        onTapUp: (_) {
          setState(() => isBtnPressed = false);
          onTap();
        },
        onTapCancel: () => setState(() => isBtnPressed = false),
        child: AnimatedContainer(
          duration: animDuration,
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(scale),
          height: 48,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
