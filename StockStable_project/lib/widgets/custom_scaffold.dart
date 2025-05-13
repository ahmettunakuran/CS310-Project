import 'package:flutter/material.dart';
import '../utils/theme_manager.dart';

// A themed scaffold that automatically applies the current theme
class CustomScaffold extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final FloatingActionButton? floatingActionButton;

  const CustomScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.floatingActionButton,
  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeManager.currentTheme,
      child: Scaffold(
        backgroundColor: widget.backgroundColor ?? _themeManager.backgroundColor,
        appBar: widget.appBar,
        drawer: widget.drawer,
        body: widget.body,
        bottomNavigationBar: widget.bottomNavigationBar != null
            ? Container(
          color: _themeManager.backgroundColor,
          child: widget.bottomNavigationBar,
        )
            : null,
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}