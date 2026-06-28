import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/initHomePage.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/pages/settingPage.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/widgets/buttonNavigatorBar.dart';
import 'package:mangueras_sv_entire/app/modules/home/presentation/widgets/navbar.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIncex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const InitHomePage(),
      const Center(child: Text('Appointments Page')),
      const SettingsPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ModernNavBar(
        backgroundColor: Colors.white,
        logoPath: 'assets/logo.png',
      ),
      body: SafeArea(child: _pages[_currentIncex]),
      bottomNavigationBar: ButtonNavigatorBar(
        iconsList: [
          Icons.home,
          Icons.shopping_cart,
          Icons.settings,
        ],

        onTap: (indexSelect) {
          setState(() {
            _currentIncex = indexSelect;
            logging.i('Current index change to $_currentIncex');
          });
        },
      ),
    );
  }
}
