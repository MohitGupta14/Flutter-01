import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'author_info.dart';

class GitHubRepos extends StatefulWidget {
  const GitHubRepos({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GitHubReposState createState() => _GitHubReposState();
}

class _GitHubReposState extends State<GitHubRepos> {
  List<dynamic> repos = [];
  Map<String, dynamic> lastCommits = {};
static const token = 'YOUR_GITHUB_TOKEN_HERE';

  @override
  void initState() {
    super.initState();
    fetchRepos();
  }

  Future<void> fetchRepos() async {
    final response = await http.get(
      Uri.parse('https://api.github.com/users/freeCodeCamp/repos'),
      headers: {'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        repos = json.decode(response.body);
      });
      await fetchLastCommits();
    } else {
      throw Exception('Failed to load repos');
    }
  }
Map<String, dynamic>? authorDetail; // Declare authorDetail in the broader scope

  Future<void> fetchLastCommits() async {
    for (var repo in repos) {
      final repoName = repo['name'];
      final response = await http.get(Uri.parse('https://api.github.com/repos/freeCodeCamp/$repoName/commits'),
      headers: {'Authorization': 'token $token'});
      if (response.statusCode == 200) {
        final commits = json.decode(response.body);
         authorDetail = commits.first['author'];
        if (commits.isNotEmpty) {
          setState(() {
            lastCommits[repoName] = commits.first;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'freeCodeCamp Repos',
          style: TextStyle(
            fontSize: 20.0,               
            fontFamily: 'Roboto',         
            fontWeight: FontWeight.bold,   
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: repos.length,
        itemBuilder: (BuildContext context, int index) {
          final repo = repos[index];
          final repoName = repo['name'];
          final lastCommit = lastCommits[repoName];
          return ListTile(
            title: Text(repoName),
            subtitle: lastCommit != null
                ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 7, 26, 68),   // Change the border color to black
                width: 1.0,            // Set the border width
              ),
              borderRadius: BorderRadius.circular(8.0),  // Set border radius for rounded corners
            ),
            padding: const EdgeInsets.all(8.0), // Add padding to the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last commit by: ${lastCommit['commit']['author']['name']}',
                  style: const TextStyle(
                    color: Colors.blue,           
                    fontSize: 16.0,                
                    fontFamily: 'Roboto',        
                    fontWeight: FontWeight.bold,    
                  ),
                ),
                Text(
                  'Commit message: ${lastCommit['commit']['message']}',
                  style: const TextStyle(
                    fontSize: 14.0,              
                    fontStyle: FontStyle.italic,  
                  ),
                ),
              ],
            ),
          )

                : const Text('Loading last commit...'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RepositoryDetailsScreen(
                  repoName: repoName,
                  description: repo['description'] ?? 'No description', author: authorDetail,
                  // author: authorDetail // Add null check
                ),
              ),
            );
          },

          );
        },
      ),
    );
  }
}
