import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:newtronic_app/resources/colors.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.init();
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            "assets/logo-newtronic.png",
            width: MediaQuery.of(context).size.width * 0.6,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
