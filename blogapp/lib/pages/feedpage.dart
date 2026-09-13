import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:blogapp/pages/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  
  List posts = [];
  bool isLoading = true;

  Future<void> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/v1/posts'),
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = jsonDecode(response.body);
          posts = responseData['data']['posts'];
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f5),
      appBar: const AppBarWidget(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(post: post),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffe8e6df)),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
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
                              const SizedBox(height: 8),
                              Text(
                                post['title'] ?? 'Tanpa judul',
                                style: GoogleFonts.newsreader(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff111111),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post['content'] ?? 'Tanpa isi',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff555555),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                post['username'] ?? 'Unknown author',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (post['imageUrl'] != null)
                          Image.network(
                            post['imageUrl'],
                            width: 82,
                            height: 82,
                            fit: BoxFit.cover,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
