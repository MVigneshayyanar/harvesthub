import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Harvest Hub"),
        backgroundColor: Color(0xFF8BC928), // Set app bar color
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Logs out the user
              Navigator.pushReplacementNamed(context, '/login'); // Navigates to login page
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Set body background color to white
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('posts').snapshots(), // Fetch data from 'posts' collection
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show loading indicator
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}")); // Display error message
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No posts available")); // Show when no data
            }

            var posts = snapshot.data!.docs;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index].data() as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 5, // Add elevation for shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: ListTile(
                    title: Text(
                      post['title'] ?? "No Title",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description: ${post['description'] ?? "Unknown"}"),
                          SizedBox(height: 4), // Add spacing between lines
                          Text("Location: ${post['location'] ?? "Unknown"}"),
                        ],
                      ),
                    ),
                    trailing: Text(
                      post['contact'] ?? "No Contact",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8BC928), // Set FAB color
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddPostScreen())),
      ),
    );
  }
}