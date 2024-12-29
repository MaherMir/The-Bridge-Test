import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.network(
              course.imageUrl,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 160,
                  child: Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              course.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              course.price,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFB3164),
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
