import 'dart:io';

import 'package:blogapp/widgets/appbarwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/pages/loginpage.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatefulWidget {
  final VoidCallback? onPublished;

  const CreatePage({super.key, this.onPublished});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List categories = [];
  int selectedCategoryId = 0;
  File? imageFile;
  final ImagePicker picker = ImagePicker();

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

  Future<void> pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 1920);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> createPost() async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:5000/api/v1/posts'),
      );

      request.headers['Authorization'] = 'Bearer $authToken';
      request.fields['userId'] = userId.toString();
      request.fields['categoryId'] = selectedCategoryId.toString();
      request.fields['title'] = titleController.text.trim();
      request.fields['content'] = contentController.text.trim();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile!.path,
            contentType: http.MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await http.Response.fromStream(await request.send());

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        titleController.clear();
        contentController.clear();
        setState(() {
          imageFile = null;
          selectedCategoryId = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil dibuat')),
        );
        widget.onPublished?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Gagal membuat artikel'),
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
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf9f5),
      appBar: AppBarWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCategoryId == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pilih kategori dulu')),
                        );
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        createPost();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffb84a2a),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "PUBLISH",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xffe8e7e3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imageFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 26,
                              color: Color(0xff666666),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "ADD COVER IMAGE",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: Color(0xff222222),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "High-resolution architectural or editorial\nphotography",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff666666),
                              ),
                            ),
                          ],
                        )
                      : Image.file(
                          imageFile!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,

                        ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "SELECT CATEGORY",
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
                  children: categories
                      .map(
                        (category) => GestureDetector(
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
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 34),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
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
                  hintText: "Write your story, essay, or thoughts here...",
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
