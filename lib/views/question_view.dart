import 'package:flutter/material.dart';
import '../utils/feedback_dialog.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz page'),
        actions: [
          IconButton(
            icon: Icon(Icons.workspace_premium_outlined),
            tooltip: 'Upgrade to Pro',
            onPressed: () {
              Navigator.pushNamed(context, '/upgrade');
            },
          ),
          IconButton(
            icon: Icon(Icons.feedback_outlined),
            onPressed: () => showFeedbackDialog(context),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 370,
              height: 220,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.purpleAccent[400],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Question 1',
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                  Spacer(),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam congue nisl quis elit rutrum, et posuere lacus vehicula. Proin iaculis nunc in justo placerat semper. Sed nequeipsum, volutpat ac ?',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370, 62),
                    backgroundColor: Color(
                      int.parse('#dc93ec'.replaceAll('#', '0xff')),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    'Option 1',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370, 62),
                    backgroundColor: Color(
                      int.parse('#dc93ec'.replaceAll('#', '0xff')),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    'Option 2',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370, 62),
                    backgroundColor: Color(
                      int.parse('#dc93ec'.replaceAll('#', '0xff')),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    'Option 3',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(370, 62),
                    backgroundColor: Color(
                      int.parse('#dc93ec'.replaceAll('#', '0xff')),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    'Option 4',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
