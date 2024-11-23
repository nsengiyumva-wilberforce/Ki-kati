import 'package:flutter/material.dart';
import 'package:ki_kati/components/post_component.dart';
import 'package:ki_kati/components/http_servive.dart';
import 'package:ki_kati/components/secureStorageServices.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  SecureStorageService storageService = SecureStorageService();

  Map<String, dynamic>? retrievedUserData;

  final HttpService httpService = HttpService("https://ki-kati.com/api/posts");
  bool _isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  void _resetFields() {
    setState(() {
      _titleController.text = "";
      _contentController.text = "";
      _imageUrlController.text = "";
    });
  }

  List<Post> posts = [];

  Future<void> getPosts() async {
    try {
      // Call the get API
      setState(() {
        _isLoading = true;
      });
      final response = await httpService.get('/');
      print(response);
      // Assuming response is a list of posts from the API
      final List<dynamic> data = List.from(response);

      // Create a list of Post objects by manually mapping the API response
      List<Post> loadedPosts = data.map((postData) {
        return Post(
          id: postData['_id'].toString(),
          userId: postData['author']['_id'],
          username: postData['author']['username'],
          userThumbnailUrl: postData['author']['profileImage'] ??
              'https://cdn-icons-png.flaticon.com/512/9131/9131529.png',
          text: postData['content'],
          imageUrl: postData['media'].isNotEmpty ? postData['media'][0] : null,
          timestamp: DateTime.parse(postData['createdAt']),
          likes: List<String>.from(postData['likes'] ?? []),
          //comments: List<String>.from(postData['comments'] ?? []),
          comments: List<Map<String, dynamic>>.from(
              postData['comments'] ?? []), // Fix comment structure
        );
      }).toList();

      // Update state with the fetched posts
      setState(() {
        posts = loadedPosts;
      });
    } catch (e) {
      setState(() {
        posts = [];
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load friends')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  void _likePost(String postId) async {
    //set loading to true

    setState(() {
      _isLoading = true;
    });
    print("Retrieved User ID: ${retrievedUserData?['user']['_id']}");

    //check for the post to like or unlike from the posts available
    final post = posts.firstWhere((post) => post.id == postId);

    print("Retrieved User ID Inside: ${retrievedUserData?['user']['_id']}");
    try {
      // Determine whether to like or unlike the post
      final String endpoint =
          post.likes.contains(retrievedUserData?['user']['_id'])
              ? '/$postId/unlike'
              : '/$postId/like';

      final response = await httpService.post(endpoint, {});
      print(response);

      if (response['statusCode'] == 200) {
        // Determine the background color based on the action
        Color? backgroundColor =
            endpoint.contains("unlike") ? Colors.red[400] : null;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['body']['message']),
            backgroundColor: backgroundColor,
          ),
        );
      } else {
        final String errorMessage =
            response['body']['message'] ?? 'Something went wrong';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false
      });
    }

    setState(() {
      post.toggleLike(retrievedUserData?['user'][
          '_id']); //toogle the current user add complete modifying the code at this point when you et to power source
    });

  }

  void _addComment(String postId, String comment) async {
    try {
      final response =
          await httpService.post('/$postId/comment', {'content': comment});
      print(response);
      if (response['statusCode'] == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['body']['message'])));
      } else {
        final String errorMessage =
            response['body']['message'] ?? 'Something went wrong';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red[400],
        ));
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here\
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false
      });
    }

    //add overall comment eventually
    setState(() {
      final post = posts.firstWhere((post) => post.id == postId);
      post.addComment({
        'content': comment, // Add the comment text here
        'author': post.userId, // Add the author's user ID or info
        'timestamp':
            DateTime.now().toIso8601String(), // Optionally add a timestamp
      });
    });
  }

  void _addPost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await httpService.post('/create', {
        'content': _contentController.text,
        'title': _titleController.text,
      });
      print(response);

      if (response['statusCode'] == 201) {
        // success
        var postData = response['body']['post'];

        // Create a new Post object from the response
        Post newPost = Post(
          id: postData['_id'].toString(),
          userId: postData['author'],
          username: retrievedUserData?['user']['username'],
          userThumbnailUrl: postData['profileImage'] ??
              'https://cdn-icons-png.flaticon.com/512/9131/9131529.png',
          text: postData['content'],
          imageUrl: postData['media'].isNotEmpty ? postData['media'][0] : null,
          timestamp: DateTime.parse(postData['createdAt']),
          likes: List<String>.from(postData['likes'] ?? []),
          comments: List<Map<String, dynamic>>.from(postData['comments'] ?? []),
        );

        // Add the newly created post to the posts list
        setState(() {
          posts.insert(0, newPost); // Insert at the top of the list
        });

        setState(() {
          _isLoading = false; // Set loading to false
          // Reset the input fields
        });
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here\
    } finally {
      _resetFields();
      setState(() {
        _isLoading = false; // Set loading to false
      });
      // Close the Bottom Sheet
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Future<void> _deletePost(String postId) async {
    try {
      final response = await httpService.delete('/$postId');
      print(response);
      if (response['statusCode'] == 200) {
        setState(() {
          posts.removeWhere((post) => post.id == postId);
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['body']['message']),
            backgroundColor: Colors.green[400],
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to delete post'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } catch (e) {
      print('Error: $e'); // Handle errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting post'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  // Function to show the Bottom Sheet and add a post
  void _showAddPostBottomSheet() {
    /*
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();
    final TextEditingController _imageUrlController = TextEditingController();
    */
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
                    onPressed: _addPost,
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

  Future<void> _fetchUserData() async {
    // Fetch user data from secure storage
    retrievedUserData = await storageService.retrieveData('user_data');
    setState(() {}); // Refresh the UI with the fetched user data
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    getPosts();
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
      body: Stack(
        children: [
          ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              // Check if the current user is the author of the post
              bool isPostOwner =
                  post.userId == retrievedUserData?['user']['_id'];
              return isPostOwner // Wrap in Dismissible only if user is the author of the post
                  ? Dismissible(
                      key: Key(post.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _deletePost(post.id);
                      },
                      background: Container(
                        color: Colors.red[400],
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: PostWidget(
                        post: post,
                        onLike: _likePost,
                        onComment: (comment) => _addComment(post.id, comment),
                      ),
                    )
                  : PostWidget(
                      post: post,
                      onLike: _likePost,
                      onComment: (comment) => _addComment(post.id, comment),
                    );
            },
          ),

          // If _isLoading is true, show the loading overlay
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color:
                    Colors.black.withOpacity(0.3), // Semi-transparent overlay
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
