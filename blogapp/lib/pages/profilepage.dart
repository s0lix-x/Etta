import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:blogapp/pages/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/pages/loginpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  List posts = [];
  bool isLoading = true;

  Future<void> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/v1/users/$userId'),
        headers: {'Authorization': 'Bearer $authToken'},
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
          : posts.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada artikel.',
                    style: TextStyle(color: Color(0xff777777)),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
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
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['category'] ?? 'ARTICLE',
                              style: const TextStyle(
                                color: Color(0xffb84a2a),
                                fontSize: 11,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post['title'] ?? 'Tanpa judul',
                              style: GoogleFonts.newsreader(
                                fontSize: 24,
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
                                height: 1.45,
                                color: Color(0xff555555),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.edit_outlined, size: 18),
                                SizedBox(width: 6),
                                Text('Edit'),
                                SizedBox(width: 20),
                                Icon(Icons.delete_outline, size: 18),
                              ],
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