import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/github_repo.dart';
import 'package:http/http.dart' as http;
import 'author_info.dart';
import 'github_repo.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repos',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(     
        brightness: Brightness.dark,
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GitHubRepos(),
    );
  }
}
