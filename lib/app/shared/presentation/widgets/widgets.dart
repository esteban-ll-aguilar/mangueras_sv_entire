

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReusableWidgets {
  static Widget backButton(BuildContext context, {required String routeName}) {
    return IconButton(
      onPressed: () => context.goNamed(routeName),
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
    );
  }
}