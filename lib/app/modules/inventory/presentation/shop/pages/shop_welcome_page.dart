import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/initHomePage.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/settingPage.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/widgets/buttonNavigatorBar.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/widgets/navbar.dart';
import 'package:mangueras_sv_entire/app/modules/inventory/presentation/shop/widgets/shop_navbar.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

class ShopWelcomePage extends ConsumerStatefulWidget {
  const ShopWelcomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  ConsumerState<ShopWelcomePage> createState() => _ShopWelcomePageState();
}

class _ShopWelcomePageState extends ConsumerState<ShopWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ShopNavbar(
        backgroundColor: Colors.white,
        logoPath: 'assets/logo.png',
      ),
      body: SafeArea(child: Container()),
    );
  }
}
