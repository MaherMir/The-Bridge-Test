import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/course.dart';

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _firebaseService = FirebaseService();

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate() &&
        _imageUrlController.text.isNotEmpty) {
      final newCourse = Course(
        id: '',
        title: _titleController.text,
        imageUrl: _imageUrlController.text,
        price: _priceController.text,
      );
      await _firebaseService.addCourse(newCourse);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Course')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Course Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a course title' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter a price' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter an image URL' : null,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _saveCourse,
                child: Text('Save Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
