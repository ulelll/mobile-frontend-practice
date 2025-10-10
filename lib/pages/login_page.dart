import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers + focus nodes as fields (don't recreate in build)
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  // button hover / press states
  bool isBtnHover = false;
  bool isBtnPressed = false;

  // colors & durations
  final Color primaryDark = const Color.fromARGB(255, 52, 51, 51);
  final Color accentPurple = Colors.deepPurple;
  final Duration animDuration = const Duration(milliseconds: 230);

  @override
  void initState() {
    super.initState();
    // listen to focus changes so UI updates when field receives/loses focus
    usernameFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  // helper builder for animated textfields
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
          color: focused ? accentPurple : Colors.grey.shade300,
          width: focused ? 2 : 1,
        ),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: accentPurple.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                )
              ]
            : [],
      ),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        cursorColor: accentPurple,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: focused ? accentPurple : Colors.grey,
          ),
          // keep vertical sizing friendly
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  // custom animated button using MouseRegion + AnimatedContainer
  Widget _animatedButton({required VoidCallback onTap, required String text}) {
    final Color btnColor = isBtnHover ? accentPurple : primaryDark;
    final double scale = isBtnPressed ? 0.98 : (isBtnHover ? 1.03 : 1.0);
    final List<BoxShadow> shadow = isBtnHover
        ? [
            BoxShadow(
              color: accentPurple.withOpacity(0.30),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ]
        : [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ];

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
            boxShadow: shadow,
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: animDuration,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // keep sizing responsive
    final double topHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // RED TOP
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // you can adjust these to move the logo around inside the red box
                  Image.asset(
                    'assets/icon.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            // Title & subtitle between red and form
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
                color: const Color.fromARGB(255, 99, 96, 96).withOpacity(0.9),
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 24),

            // FORM
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
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
                  // Button
                  _animatedButton(
                    text: 'Login',
                    onTap: () {
                      // your login action here
                      // e.g. Navigator.pushNamed(context, '/home');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login pressed')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
