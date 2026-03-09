import 'package:flutter/material.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final Widget? appBarTitle;

  const AuthScaffold({
    super.key,
    required this.child,
    this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontal = width > 720 ? width * 0.2 : 20.0;

    return Scaffold(
      appBar: appBarTitle == null ? null : AppBar(title: appBarTitle),
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: child,
          ),
        ),
      ),
    );
  }
}
