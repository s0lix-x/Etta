import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:blogapp/pages/detailpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/pages/loginpage.dart';
import 'package:blogapp/pages/editpage.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onPostsChanged;

  const ProfilePage({super.key, this.onPostsChanged});

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

  Future<bool> showDeleteDialog(Map post) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xfffaf9f5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xff8f4530),
                size: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                'Delete this article?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xff777777),
                fontSize: 16,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'This will permanently remove '),
                TextSpan(
                  text: '“${post['title']}”',
                  style: const TextStyle(
                    color: Color(0xff333333),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text:
                      ' from your published stories and the Folio network. '
                      'This action cannot be undone.',
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffeeeae7),
                foregroundColor: const Color(0xff666666),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffb51f24),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Delete Article',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> deletePost(Map post) async {
    if (!await showDeleteDialog(post)) {
      return;
    }
    if (!mounted) {
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:5000/api/v1/posts/${post['id']}'),
        headers: {'Authorization': 'Bearer $authToken'},
      );
      final responseData = jsonDecode(response.body);

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        setState(() {
          posts.remove(post);
        });
        widget.onPostsChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil dihapus')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Gagal menghapus artikel'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server')),
      );
    }
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(post: post),
                                  ),
                                );

                                if (result == true) {
                                  getPosts();
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18),
                                  SizedBox(width: 6),
                                  Text('Edit'),
                                ],
                              ),
                            ),

                            SizedBox(width: 20),

                            GestureDetector(
                              onTap: () => deletePost(post),
                              child: const Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 18),
                                  SizedBox(width: 6),
                                  Text('Delete'),
                                ],
                              ),
                            ),
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
