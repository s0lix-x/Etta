import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xfffaf9f5),
      titleSpacing: 20,
      title: Row(
        children: [
          Text(
            "ETTA",
            style: GoogleFonts.newsreader(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: const Color(0xff111111),
            ),
          ),
        ],
      ),
    );
  }
}
