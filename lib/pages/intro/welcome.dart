import 'package:flutter/material.dart';
import 'package:flutterwaka/widgets/typewriter.dart';
import 'package:go_router/go_router.dart';

class WelcomeIntroPage extends StatefulWidget {
  const WelcomeIntroPage({super.key});

  @override
  State<WelcomeIntroPage> createState() => _WelcomeIntroPageState();
}

class _WelcomeIntroPageState extends State<WelcomeIntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome in",
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Typewriter(
              anim: controller,
              text: "WakaBoard",
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: "monospace",
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FilledButton(
        child: const Text("Login"),
        onPressed: () => context.go("/login"),
      ),
    );
  }
}
