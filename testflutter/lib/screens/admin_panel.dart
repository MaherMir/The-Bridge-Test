import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart';
import '../models/course.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = screenWidth > 800 ? 3 : (screenWidth > 500 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCourseDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: StreamBuilder<List<Course>>(
          stream: _firebaseService.getCoursesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No courses available.'));
            }
            final courses = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          course.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Center(
                              child: Text('Failed to load image'),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${course.price}',
                          style: const TextStyle(color: Colors.pink),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showEditCourseDialog(context, course),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmDeleteCourse(context, course.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (imageUrlController.text.isNotEmpty) {
                  final newCourse = Course(
                    id: '',
                    title: titleController.text,
                    imageUrl: imageUrlController.text,
                    price: priceController.text,
                  );

                  _firebaseService.addCourse(newCourse).then((_) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Course added successfully!')),
                    );
                  }).catchError((e) {
                    print("Error adding course: $e");
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add course')),
                    );
                  });
                } else {
                  print('Image URL is required!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an image URL')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditCourseDialog(BuildContext context, Course course) {
    final titleController = TextEditingController(text: course.title);
    final priceController = TextEditingController(text: course.price);
    final imageController = TextEditingController(text: course.imageUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedCourse = Course(
                  id: course.id,
                  title: titleController.text,
                  imageUrl: imageController.text,
                  price: priceController.text,
                );
                _firebaseService
                    .updateCourse(course.id, updatedCourse)
                    .then((_) {
                  Navigator.pop(context);
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCourse(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Course'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _firebaseService.deleteCourse(courseId).then((_) {
                  Navigator.pop(context);
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
