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
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search_outlined,
            size: 24,
            color: Color(0xff111111),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person,
              size: 24,
              color: Color(0xff111111),
            ),
          ),
        ),
      ],
    );
  }
}
