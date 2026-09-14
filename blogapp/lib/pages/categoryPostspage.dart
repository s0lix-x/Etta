import 'dart:convert';

import 'package:blogapp/pages/detailpage.dart';
import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CategoryPostsPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryPostsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryPostsPage> createState() => _CategoryPostsPageState();
}

class _CategoryPostsPageState extends State<CategoryPostsPage> {
  List posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future<void> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:5000/api/v1/posts?categoryId=${widget.categoryId}',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          posts = responseData['data']['posts'];
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f5),
      appBar: const AppBarWidget(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.categoryName.toUpperCase(),
                        style: GoogleFonts.newsreader(
                          fontSize: 34,
                          color: const Color(0xff111111),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${posts.length} articles',
                        style: const TextStyle(color: Color(0xff666666)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: posts.isEmpty
                      ? const Center(
                          child: Text('Belum ada artikel di kategori ini.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(post: post),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xffddddda),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post['title'] ?? 'Tanpa judul',
                                            style: GoogleFonts.newsreader(
                                              fontSize: 23,
                                              color: const Color(0xff222222),
                                            ),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                            post['content'] ?? 'Tanpa isi',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xff666666),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            post['username'] ??
                                                'Unknown author',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xff777777),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                ),
              ],
            ),
    );
  }
}
