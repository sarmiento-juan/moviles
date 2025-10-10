import 'package:flutter/material.dart';

/// Widget base para las vistas del Taller HTTP
/// Proporciona una estructura comun con AppBar y Drawer
class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
