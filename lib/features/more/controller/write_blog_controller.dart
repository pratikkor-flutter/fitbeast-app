import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WriteBlogController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserName();
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    authorController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }

  void loadUserName() {
    final user = _auth.currentUser;
    authorController.text = user?.displayName ?? '';
  }

  Future<void> uploadBlog(Map<String, dynamic> blogData) async {
    try {
      await _firestore.collection('blogs').doc(blogData['id']).set(blogData);
      debugPrint('Blog uploaded successfully: ${blogData['id']}');
    } catch (e) {
      debugPrint('Error uploading blog: $e');
      rethrow;
    }
  }

  Future<void> submitBlog() async {
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      errorMessage.value = 'Title and description are required';
      return;
    }

    isLoading.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Create blog data
      final newBlog = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': titleController.text,
        'desc': descController.text,
        'author': authorController.text.isNotEmpty
            ? authorController.text
            : 'Anonymous',
        'date': DateTime.now().toString(),
        'likes': 0,
        'imageUrl': imageUrlController.text.trim().isNotEmpty
            ? imageUrlController.text.trim()
            : 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500', // Default image
      };

      // Upload the blog
      await uploadBlog(newBlog);

      Get.back(); // Close loading dialog
      Get.back(); // Close the write blog view

      showFitSnackbar('Blog published successfully');
    } catch (e) {
      Get.back(); // Close loading dialog
      errorMessage.value = 'Failed to publish blog: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
