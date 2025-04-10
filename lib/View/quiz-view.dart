import 'package:flutter/material.dart';
import '../utils/feedback_dialog.dart';

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz page'),
        actions: [
          IconButton(
            icon: Icon(Icons.feedback_outlined),
            onPressed: () => showFeedbackDialog(context),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 40.0,
          children: <Widget>[
            // First Box with Text and Button
            Container(
              width: 400,
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
                    'Generated Quiz',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    'A quiz generated using AI with question we think would help you best revise for this specific topic. Click on the refresh button to re-generate.',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  OverflowBar(
                    alignment: MainAxisAlignment.end,
                    spacing: 8.0,
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('View')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/quiz');
                        },
                        child: Text('Start'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 400,
              height: 220,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Revision Quiz',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    'All the questions that you have got wrong and or have flagged to review.',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  OverflowBar(
                    alignment: MainAxisAlignment.end,
                    spacing: 8.0,
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('View')),
                      ElevatedButton(onPressed: () {}, child: Text('Start')),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 400,
              height: 220,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Quiz 1',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    'Custom Quiz made by the user...',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  OverflowBar(
                    alignment: MainAxisAlignment.end,
                    spacing: 8.0,
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('View')),
                      ElevatedButton(onPressed: () {}, child: Text('Start')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
