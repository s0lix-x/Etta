import 'dart:convert';

import 'package:blogapp/pages/categoryPostspage.dart';
import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List categories = [];
  List posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final categoriesResponse = await http.get(
        Uri.parse('http://localhost:5000/api/v1/categories'),
      );
      final postsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/v1/posts'),
      );

      if (categoriesResponse.statusCode == 200 &&
          postsResponse.statusCode == 200) {
        setState(() {
          categories = jsonDecode(
            categoriesResponse.body,
          )['data']['categories'];
          posts = jsonDecode(postsResponse.body)['data']['posts'];
          isLoading = false;
        });
      }
    } catch (e) {
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
                        'CATEGORIES',
                        style: GoogleFonts.newsreader(
                          fontSize: 34,
                          color: const Color(0xff111111),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Curated archives organized by discipline and focus.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff555555),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final categoryName = category['name'];
                      final articleCount = posts
                          .where((post) => post['categoryId'] == category['id'])
                          .length;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryPostsPage(
                                categoryId: category['id'],
                                categoryName: categoryName,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xffddddda)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                (index + 1).toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff888888),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  categoryName,
                                  style: GoogleFonts.newsreader(
                                    fontSize: 25,
                                    color: const Color(0xff222222),
                                  ),
                                ),
                              ),
                              Text(
                                '$articleCount articles',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff666666),
                                ),
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
