import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/pages/loginpage.dart';

class EditPage extends StatefulWidget {
  final Map post;

  const EditPage({super.key, required this.post});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final formKey = GlobalKey<FormState>();

  late final titleController = TextEditingController(
    text: widget.post['title'],
  );

  late final contentController = TextEditingController(
    text: widget.post['content'],
  );

  List categories = [];
  int selectedCategoryId = 0;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    selectedCategoryId = widget.post['categoryId'] ?? 0;

    getCategories();
  }

  Future<void> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/v1/categories'),
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = jsonDecode(response.body);
          categories = responseData['data']['categories'];
        });
      }
    } catch (error) {
      setState(() {
        categories = [];
      });
    }
  }

  Future<void> updatePost() async {
    if (selectedCategoryId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih kategori dulu')));
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final response = await http.patch(
        Uri.parse('http://localhost:5000/api/v1/posts/${widget.post['id']}'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': titleController.text.trim(),
          'content': contentController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil diupdate')),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Gagal mengupdate artikel',
            ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f5),

      appBar: AppBar(
        backgroundColor: const Color(0xfffaf9f5),
        titleSpacing: 20,
        title: Text(
          'ETTA',
          style: GoogleFonts.newsreader(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: const Color(0xff111111),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ElevatedButton(
                onPressed: isSaving ? null : updatePost,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff111111),
                  foregroundColor: const Color(0xfffaf9f5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),

                child: isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'PUBLISH UPDATE',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              const Text(
                'SELECT CATEGORY',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: Color(0xff555555),
                ),
              ),

              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(
                  children: categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategoryId = category['id'];
                        });
                      },

                      child: Container(
                        margin: const EdgeInsets.only(right: 10),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),

                        decoration: BoxDecoration(
                          color: selectedCategoryId == category['id']
                              ? const Color(0xffb84a2a)
                              : const Color(0xffe8e7e3),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          category['name'],

                          style: TextStyle(
                            fontSize: 12,
                            color: selectedCategoryId == category['id']
                                ? Colors.white
                                : const Color(0xff555555),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 34),

              TextFormField(
                controller: titleController,

                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),

                style: GoogleFonts.newsreader(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff111111),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title wajib diisi';
                  }

                  if (value.trim().length < 3) {
                    return 'Title minimal 3 karakter';
                  }

                  return null;
                },
              ),

              const Divider(color: Color(0xffe8e6df)),

              TextFormField(
                controller: contentController,

                maxLines: 12,

                decoration: const InputDecoration(
                  hintText: 'Write your story, essay, or thoughts here...',
                  border: InputBorder.none,
                ),

                style: const TextStyle(
                  fontSize: 17,
                  height: 1.6,
                  color: Color(0xff111111),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Content wajib diisi';
                  }

                  if (value.trim().length < 10) {
                    return 'Content minimal 10 karakter';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
