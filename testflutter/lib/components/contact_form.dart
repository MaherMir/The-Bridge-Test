import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Message: ${_messageController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.orange.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your email' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 4,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter your message' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
