import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/app_pallete.dart';
import 'package:pomogrow/features/home/presentation/screens/home_screen.dart';
import 'package:pomogrow/features/home/presentation/widgets/home_sidebar.dart';
import 'package:pomogrow/features/home/presentation/widgets/sidebar_button.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  bool isSideMenuClosed = true;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            setState(() {});
          });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: Sidebar(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 255, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: Stack(
                  children: [
                    const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      child: HomeScreen(),
                    ),

                    // Blur overlay
                    if (animation.value > 0)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10 * animation.value,
                            sigmaY: 10 * animation.value,
                          ),
                          child: Container(color: AppPallete.blackShadow),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            top: 6,
            left: isSideMenuClosed ? 0 : 210,
            child: SidebarButton(
              onPressed: () {
                if (isSideMenuClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                setState(() {
                  isSideMenuClosed = !isSideMenuClosed;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
