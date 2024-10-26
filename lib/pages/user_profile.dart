// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gyanbuddy/services/user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:developer' as dev;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  final UserDataService _userDataService = UserDataService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Profile'),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<Map<String, dynamic>>(
                  future: _userDataService.getUserStats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    } else {
                      final stats = snapshot.data!;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _selectAndUploadImage(context),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: user?.photoURL != null
                                    ? NetworkImage(user!.photoURL!)
                                    : const AssetImage("assets/images/dp.png")
                                        as ImageProvider,
                                child: Icon(Icons.camera_alt,
                                    color: Colors.white70),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Welcome, ${user?.displayName ?? 'User'}!',
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Quiz Statistics',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            _buildStatCard('Total Quizzes Taken',
                                stats['totalQuizzesTaken'] ?? 0),
                            _buildStatCard('Total Correct Answers',
                                stats['totalCorrectAnswers'] ?? 0),
                            _buildStatCard('Total Quiz Questions',
                                stats['totalQuizQuestions'] ?? 0),
                            const SizedBox(height: 20),
                            Text(
                              'Performance',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 10),
                            _buildPerformanceCard(stats),
                          ],
                        ),
                      );
                    }
                  },
                ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, int value) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(Map<String, dynamic> stats) {
    final totalQuestions = stats['totalQuizQuestions'] ?? 0;
    final correctAnswers = stats['totalCorrectAnswers'] ?? 0;
    final performance = totalQuestions > 0
        ? (correctAnswers / totalQuestions * 100).toStringAsFixed(2)
        : '0';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Overall Performance',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            Text(
              '$performance%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndUploadImage(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File image = File(pickedFile.path);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('profile_images/$fileName');

        dev.log('Uploading image to Firebase Storage...');
        UploadTask uploadTask = firebaseStorageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        dev.log('Image uploaded successfully. Download URL: $downloadUrl');

        dev.log('Updating user profile...');
        await _userDataService.updateProfileImage(downloadUrl);
        dev.log('User profile updated successfully');

        // Refresh the current user
        await FirebaseAuth.instance.currentUser?.reload();
        dev.log('User reloaded');

        // Force a rebuild of the widget tree
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      dev.log('Error updating profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile picture: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
