import 'package:flutter/material.dart';

void showFeedbackDialog(BuildContext context) {
  TextEditingController _controller = TextEditingController();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('Send Feedback'),
          content: TextField(
            controller: _controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your feedback...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String feedback = _controller.text;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Thanks for your feedback!')),
                );
                print(
                  "Feedback submitted: $feedback",
                ); // Replace with Firebase/API if needed
              },
              child: Text('Send'),
            ),
          ],
        ),
  );
}
