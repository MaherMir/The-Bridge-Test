import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/course.dart';
import 'dart:io';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<List<Course>> fetchCourses() async {
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs
        .map((doc) => Course.fromMap(doc.data(), doc.id))
        .toList();
  }

  Stream<List<Course>> getCoursesStream() {
    return _firestore.collection('courses').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Course.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addCourse(Course course) async {
    try {
      await _firestore.collection('courses').add({
        'title': course.title,
        'imageUrl': course.imageUrl,
        'price': course.price,
      });

      print("Course added successfully.");
    } catch (e) {
      print('Error adding course: $e');
      throw e;
    }
  }

  Future<void> updateCourse(String id, Course updatedCourse) async {
    try {
      await _firestore.collection('courses').doc(id).update({
        'title': updatedCourse.title,
        'imageUrl': updatedCourse.imageUrl,
        'price': updatedCourse.price,
      });
      print("Course updated successfully.");
    } catch (e) {
      print('Error updating course: $e');
      throw e;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await _firestore.collection('courses').doc(id).delete();
      print("Course deleted successfully.");
    } catch (e) {
      print('Error deleting course: $e');
      throw e;
    }
  }

  Future<Course?> getCourseById(String id) async {
    try {
      final doc = await _firestore.collection('courses').doc(id).get();
      if (doc.exists) {
        return Course.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching course: $e');
      throw e;
    }
  }

  Future<String> uploadImage(String imagePath) async {
    try {
      final storageRef =
          _storage.ref().child('courses/${DateTime.now().toString()}');
      final uploadTask = await storageRef.putFile(File(imagePath));
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }
}
