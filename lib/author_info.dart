import 'package:flutter/material.dart';

class RepositoryDetailsScreen extends StatelessWidget {
  final String repoName;
  final String description;
  final Map<String, dynamic>? author; // Declare author information as nullable

  const RepositoryDetailsScreen({super.key, 
    required this.repoName,
    required this.author, // Accept author information as nullable parameter
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repoName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          if (author != null) // Null check for author
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(author!['avatar_url']),
              ),
              title: Text(author!['login']),
              subtitle: Text(author!['html_url']),
              onTap: () {
                // Open author's GitHub profile
              },
            ),
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
