import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Aksara_Literasi/common/colors.dart';

class NoConnectivity extends StatefulWidget {
  const NoConnectivity({super.key});

  @override
  State<NoConnectivity> createState() => _NoConnectivityState();
}

class _NoConnectivityState extends State<NoConnectivity> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.signal_wifi_off_rounded,
                size: 80,
                color: AppColors.black,
              ),
              Text(
                "Oops!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height * 0.020),
              Text(
                "Tidak ada sambungan internet. \n Silakan periksa koneksi internet Anda",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
