import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:note_app/views/shop_screen.dart';

import '../views/shop_screen.dart';

class FrontBottomAppBar extends StatefulWidget {
  const FrontBottomAppBar({super.key});

  @override
  State<FrontBottomAppBar> createState() => _FrontBottomAppBarState();
}

class _FrontBottomAppBarState extends State<FrontBottomAppBar> {
  // Bottom appbar
  Widget? _child;

  @override
  void initState() {
    super.initState();

    _child = ShopScreen();
  }

  void _handleNavigationChange(int index) {
    setState(() {
      // switch (index) {
      //   case 0:
      //     _child = HomeContent();
      //     break;
      //   case 1:
      //     _child = AccountContent();
      //     break;
      //   case 2:
      //     _child = SettingsContent();
      //     break;
      // }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FluidNavBar(
      icons: [
        FluidNavBarIcon(
            icon: Icons.settings,
            backgroundColor: Colors.green,
            extras: {"label": "shope"}),
        FluidNavBarIcon(
            icon: Icons.home,
            backgroundColor: Colors.green,
            extras: {"label": "home"}),
        FluidNavBarIcon(
            icon: Icons.account_circle,
            backgroundColor: Colors.green,
            extras: {"label": "cart"}),
      ],
      onChange: _handleNavigationChange,
      style: FluidNavBarStyle(
          barBackgroundColor: Colors.green,
          iconSelectedForegroundColor: Colors.white,
          iconUnselectedForegroundColor: Colors.white60),
      scaleFactor: 1.5,
      defaultIndex: 0,
      itemBuilder: (icon, item) => Semantics(
        label: icon.extras!["label"],
        child: item,
      ),
    );
  }
}
