import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/home_controller.dart';
import '../theme_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: controller.getSampleData().length,
        itemBuilder: (context, index) {
          final item = controller.getSampleData()[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
          );
        },
      ),
    );
  }
}
