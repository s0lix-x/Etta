import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  final Map post;

  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f5),
      appBar: AppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['category'] ?? 'ARTICLE',
              style: const TextStyle(
                color: Color(0xffb84a2a),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post['title'] ?? 'Tanpa judul',
              style: GoogleFonts.newsreader(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: const Color(0xff111111),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              post['username'] ?? 'Unknown author',
              style: const TextStyle(color: Color(0xff777777)),
            ),
            const SizedBox(height: 20),
            if (post['imageUrl'] != null)
              Image.network(
                post['imageUrl'],
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            Text(
              post['content'] ?? 'Tanpa isi',
              style: GoogleFonts.newsreader(
                fontSize: 19,
                height: 1.6,
                color: const Color(0xff333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
