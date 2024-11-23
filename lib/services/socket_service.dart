import 'dart:async';
import 'package:ki_kati/components/secureStorageServices.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import 'package:ki_kati/components/http_servive.dart';

class SocketService with ChangeNotifier {
  static final SocketService _singleton = SocketService._internal();
  late IO.Socket socket;

  SecureStorageService storageService = SecureStorageService();

  // List to store active users
  //List<String> activeUsers = [];
  List<Map<String, dynamic>> activeUsers = [];
  List<Map<String, dynamic>> receivedMessages = [];

  // Map to track who is typing
  Map<String, bool> typingStatus = {};

  // Private constructor for Singleton pattern
  SocketService._internal();

  factory SocketService() {
    return _singleton;
  }

  final HttpService httpService = HttpService("https://ki-kati.com/api");
  //late Future<List<dynamic>> activeUsers;

  // Fetch active users from the API
  Future<void> fetchActiveUsers() async {
    try {
      // Call the GET method of HttpService
      final response = await httpService.get("/messages/active-users");
      print(response);

      // If response is valid, update the activeUsers list
      if (response != null) {
        activeUsers = List<Map<String, dynamic>>.from(response);
        notifyListeners(); // Notify listeners (e.g., UI) about the change
      }
    } catch (error) {
      print("Error fetching active users: $error");
      activeUsers = []; // Reset active users list on error
      notifyListeners(); // Notify listeners (e.g., UI) about the change
    }
  }

  Future<void> connect() async {
    print("attempting to connect to socket");
    Map<String, dynamic>? retrievedUserData =
        await storageService.retrieveData('user_data');
    String? username = retrievedUserData?['user']['username'];

    socket = IO.io('https://ki-kati.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'token': retrievedUserData?['token'],
      },
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to the server as $username');
      socket.emit('registerUser', username); // replace with actual username
    });

    socket.onDisconnect((_) {
      print("You have been disconnected from the server!");
      print('Disconnected from server');
    });

    // Handle connection errors
    socket.on('connect_error', (error) {
      print('Connection error: $error');
    });

    // Handle connection timeout
    socket.on('connect_timeout', (_) {
      print('Connection timed out');
    });

    // Optional: handle reconnection attempts
    socket.onReconnectAttempt((attempt) {
      print('Reconnection attempt #$attempt');
    });

    /* Listen for active users
    socket.on('activeUsers', (data) {
      // Convert the incoming data to a List<String> if necessary
      //activeUsers = List<String>.from(data);
      activeUsers = List<Map<String, dynamic>>.from(data);
      // Notify listeners (e.g., UI) about the change
      notifyListeners();
      // Handle active users data here
      print('Active Users: $data');
    });
    */

    // Listen for active users (server should emit the active users data)
    socket.on('activeUsers', (data) async {
      // When the 'activeUsers' event is received, fetch the active users from the API
      if (data != null) {
        print('Active Users event received: $data');
        // Call the fetchActiveUsers function to refresh the list
        await fetchActiveUsers();
      }
    });

    // Listen for incoming messages (directMessage)
    socket.on("directMessage", (data) {
      // When a message is received, add it to the list of received messages
      receivedMessages.add({
        'sender': data['sender'],
        'content': data['content'],
      });
      print("This is the recieved message from the socket class!");
      print(receivedMessages);

      // Notify listeners to update the UI
      notifyListeners();
    });

    socket.on('typing', (data) {
      // Handle incoming messages
      print('${data['username']} is typing');

      String typingUser = data['username'];
      typingStatus[typingUser] = true; // User is typing
      notifyListeners(); // Notify UI
    });

    socket.on('stop_typing', (data) {
      print('${data['username']} stopped typing');
      String typingUser = data['username'];
      typingStatus[typingUser] = false; // User stopped typing
      notifyListeners(); // Notify UI
    });
  }

  // Send a message via socketrecipientId: recipientId,
  void sendMessage(String recipient, String message, String from) {
    socket.emit('sendMessage',
        {'recipientId': recipient, 'content': message, 'from': from});
  }

  // emit typing for users connected,
  void sendTyping(String from, String recipientId) {
    socket.emit('typing', {'username': from, 'recipientId': recipientId});
  }

  // Emit stop typing event (after the user stops typing for a certain time)
  void sendStopTyping(String from, String recipientId) {
    //typingStatus[from] = false; // User stopped typing
    socket.emit('stop_typing', {'username': from, 'recipientId': recipientId});
    //notifyListeners(); // Notify UI
  }

  // Optional: Disconnect from the socket when done
  void disconnect() {
    socket.disconnect();
  }

  // Optional: Get the current socket instance
  IO.Socket getSocket() {
    return socket;
  }

  // Method to get active users list (if needed)
  List<Map<String, dynamic>> getActiveUsers() {
    return activeUsers;
  }

  Map<String, bool> getTypingStatus() {
    return typingStatus;
  }
}

/*
   // Send a message via socketrecipientId: recipientId,
  void sendMessage(String recipient, String message, String from) {
    // Prepare the payload for the message
    Map<String, dynamic> payload = {
      'recipientId': recipient,
      'content': message,
      'from': from,
    };
    
    socket.emit('sendMessage', payload);
  }






  import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

Future<void> sendMessage(String recipient, String message, String from, {File? file}) async {
  try {
    // Prepare the payload for the message
    var uri = Uri.parse('https://your-api-endpoint/sendMessage'); // Replace with your actual API endpoint
    
    var request = http.MultipartRequest('POST', uri);

    // Add message text to the request
    request.fields['recipientId'] = recipient;
    request.fields['content'] = message;
    request.fields['from'] = from;

    if (file != null) {
      // Add file to the request as a multipart file
      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'file', // Name of the field in your API
        fileStream,
        length,
        filename: file.uri.pathSegments.last,
        contentType: MediaType('application', 'octet-stream'), // Adjust the content type as necessary
      );

      request.files.add(multipartFile);
    }

    // Send the request to the server
    var response = await request.send();

    if (response.statusCode == 200) {
      // If the request is successful, handle the response
      print('Message sent successfully');
      // Handle the server's response, e.g., update the UI or show a success message
    } else {
      print('Failed to send message: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}
 */