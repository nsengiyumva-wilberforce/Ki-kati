import 'package:flutter/material.dart';
import 'package:ki_kati/components/post_component.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> posts = [
    Post(
      id: '1',
      userId: 'u1',
      username: 'engdave',
      userThumbnailUrl:
          'https://cdn-icons-png.flaticon.com/512/9131/9131529.png',
      text:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. I",
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/12/08/11/53/event-party-3005668_1280.jpg',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Post(
      id: '2',
      userId: 'u2',
      username: 'mercy',
      userThumbnailUrl:
          'https://cdn-icons-png.flaticon.com/512/9131/9131529.png',
      text:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. I",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Post(
      id: '3',
      userId: 'u3',
      username: 'daniles',
      userThumbnailUrl:
          'https://cdn-icons-png.flaticon.com/512/9131/9131529.png',
      imageUrl:
          "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
      text:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. I",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  void _likePost(String postId) {
    setState(() {
      final post = posts.firstWhere((post) => post.id == postId);
      post.toggleLike();
    });
  }

  void _addComment(String postId, String comment) {
    setState(() {
      final post = posts.firstWhere((post) => post.id == postId);
      post.addComment(comment);
    });
  }

  // Function to show the Bottom Sheet and add a post
  void _showAddPostBottomSheet() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();
    final TextEditingController _imageUrlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // To make the height configurable
      isDismissible: false,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Post',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),

              // Title input
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Post Title',
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),

              // Content input
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Post Content',
                ),
                style: const TextStyle(fontSize: 14),
                maxLines: 4,
              ),
              const SizedBox(height: 10),

              // Image URL input (optional)
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Submit and cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      backgroundColor: Colors.blue, // Set the background color
                      foregroundColor:
                          Colors.white, // Set the text color (foreground color)
                    ),
                    onPressed: () {
                      // Add post to the list of posts
                      final newPost = Post(
                        id: DateTime.now().toString(),
                        userId: 'u3', // Assuming a new user
                        username: 'New User', // Username for the new user
                        userThumbnailUrl:
                            'https://cdn-icons-png.flaticon.com/512/9131/9131529.png',
                        text: _contentController.text,
                        imageUrl: _imageUrlController.text.isNotEmpty
                            ? _imageUrlController.text
                            : null,
                        timestamp: DateTime.now(),
                      );

                      setState(() {
                        posts.add(newPost);
                      });

                      // Close the Bottom Sheet
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create Post'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Close the Bottom Sheet without doing anything
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text(
          'Posts Feed',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          // Using CircleAvatar for the circular button with a red background and white icon
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20, // Size of the circle
              backgroundColor: Colors.red, // Red background
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white), // White icon
                onPressed: _showAddPostBottomSheet, // Show the bottom sheet
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostWidget(
            post: posts[index],
            onLike: _likePost,
            onComment: (comment) => _addComment(posts[index].id, comment),
          );
        },
      ),
    );
  }
}
