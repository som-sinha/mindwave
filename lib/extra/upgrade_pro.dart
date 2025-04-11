import 'package:flutter/material.dart';

class UpgradeProPage extends StatelessWidget {
  const UpgradeProPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upgrade to MindWave Pro')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unlock the Power of MindWave Pro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'With MindWave Pro, you get access to advanced features designed to supercharge your learning experience:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ...[
              '✅ Unlimited Quiz Generation for all uploaded material',
              '✅ Detailed Quiz Analytics (Strengths & Weaknesses)',
              '✅ Premium AI Summaries with Key Points',
              '✅ Personalized Study Resources & Suggestions',
              '✅ Early Access to New Features',
              '✅ Priority Feedback & Support',
              '✅ Study Buddy & Educator Matching (Beta)',
            ].map(
              (benefit) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.purple),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(benefit, style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text(
              'Subscribe Now for Just \$5/month!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'This is a demo. Subscription coming soon!',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Buy Subscription',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Not Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
