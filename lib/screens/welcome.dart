import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Aksara_Literasi/common/colors.dart';
import 'package:Aksara_Literasi/common/common.dart';
import 'package:Aksara_Literasi/common/widgets/no_connectivity.dart';
import 'package:Aksara_Literasi/screens/home/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    if (await getInternetStatus()) {
      Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()),
        );
      });
    } else {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => const NoConnectivity()))
          .then((value) => checkConnectivity());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.40),
              SizedBox(
                width: 130,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
