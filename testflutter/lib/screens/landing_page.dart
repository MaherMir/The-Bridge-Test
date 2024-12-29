import 'package:flutter/material.dart';
import 'package:testflutter/screens/admin_panel.dart';
import '../components/course_card.dart';
import '../services/firebase_service.dart';
import '../models/course.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Course> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final fetchedCourses = await _firebaseService.fetchCourses();
    setState(() {
      courses = fetchedCourses;
      isLoading = false;
    });
  }

  void _refreshCourses() {
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.jpg',
              height: 40,
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPanel(),
                ),
              ).then((_) {
                _refreshCourses();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: const Text(
                'Discover Our Courses',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildCourseGrid(courses),
            _buildContactUsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/9antra.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 250,
          color: Colors.black.withOpacity(0.5),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Improve your skills on your own\nTo prepare for a better future",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD42A6B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text(
                      "Register Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseGrid(List<Course> courses) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return CourseCard(course: courses[index]);
                  },
                  childCount: courses.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactUsSection() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 24.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Color(0xFFFFB347),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildTextField('Name', 'Jara Martins'),
              const SizedBox(height: 12.0),
              _buildTextField('Email', 'hello@reallygreatsite.com'),
              const SizedBox(height: 12.0),
              _buildTextField('Message', 'Write your message here',
                  maxLines: 4),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD42A6B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text(
                    'Send the message',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
