import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/course.dart';

class EditCoursePage extends StatefulWidget {
  final Course course;

  EditCoursePage({required this.course});

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;

  final _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course.title);
    _priceController =
        TextEditingController(text: widget.course.price.toString());
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedCourse = Course(
        id: widget.course.id,
        title: _titleController.text,
        imageUrl: widget.course.imageUrl,
        price: _priceController.text,
      );
      await _firebaseService.updateCourse(widget.course.id, updatedCourse);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Course')),
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
              Spacer(),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
