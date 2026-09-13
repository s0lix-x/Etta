import 'dart:convert';

import 'package:blogapp/pages/detailpage.dart';
import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final searchController = TextEditingController();
  List posts = [];
  bool isLoading = false;
  bool hasSearched = false;

  Future<void> getPosts() async {
    final search = searchController.text.trim();
    if (search.isEmpty) {
      setState(() {
        posts = [];
        hasSearched = false;
        isLoading = false;
      });
      return;
    }

    setState(() => isLoading = true);
    try {
      final uri = Uri.parse(
        'http://localhost:5000/api/v1/posts',
      ).replace(queryParameters: {'search': search});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final allPosts = data['data']['posts'] as List;
        final matchingPosts = allPosts.where((post) {
          final title = (post['title'] ?? '').toString().toLowerCase();
          return title.contains(search.toLowerCase());
        }).toList();

        setState(() {
          posts = matchingPosts;
          hasSearched = true;
          isLoading = false;
        });
      } else {
        setState(() {
          posts = [];
          hasSearched = true;
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        posts = [];
        hasSearched = true;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[
      Text(
        'DISCOVER',
        style: GoogleFonts.newsreader(
          fontSize: 34,
          color: const Color(0xff111111),
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Explore ideas, essays, and perspectives from the community.',
        style: TextStyle(fontSize: 16, height: 1.4, color: Color(0xff555555)),
      ),
      const SizedBox(height: 22),
      TextField(
        controller: searchController,
        onSubmitted: (_) => getPosts(),
        decoration: InputDecoration(
          hintText: 'Search articles',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {
                posts = [];
                hasSearched = false;
              });
            },
            icon: const Icon(Icons.close),
          ),
          filled: true,
          fillColor: const Color(0xfff1f1ed),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      const SizedBox(height: 24),
    ];

    if (isLoading) {
      content.add(const Center(child: CircularProgressIndicator()));
    } else if (hasSearched && posts.isEmpty) {
      content.add(
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Center(child: Text('Artikel tidak ditemukan.')),
        ),
      );
    } else {
      for (final post in posts) {
        content.add(_postCard(context, post));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xfffaf9f5),
      appBar: AppBarWidget(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
        children: content,
      ),
    );
  }

  Widget _postCard(BuildContext context, Map post) {
    final cardChildren = <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (post['category'] ?? 'ARTICLE').toString().toUpperCase(),
              style: const TextStyle(
                color: Color(0xff9c4934),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post['title'] ?? 'Tanpa judul',
              style: GoogleFonts.newsreader(
                fontSize: 23,
                color: const Color(0xff222222),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post['content'] ?? 'Tanpa isi',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                height: 1.35,
                color: Color(0xff666666),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              post['username'] ?? 'Unknown author',
              style: const TextStyle(fontSize: 13, color: Color(0xff555555)),
            ),
          ],
        ),
      ),
    ];

    if (post['imageUrl'] != null) {
      cardChildren.add(const SizedBox(width: 12));
      cardChildren.add(
        Image.network(
          post['imageUrl'],
          width: 92,
          height: 92,
          fit: BoxFit.cover,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(post: post)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cardChildren,
        ),
      ),
    );
  }
}
