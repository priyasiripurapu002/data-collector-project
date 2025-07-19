library data_sdk;

import 'dart:convert';
import 'package:http/http.dart' as http;

class DataSDK {
  final String apiUrl;
  final List<Map<String, dynamic>> _buffer = [];

  DataSDK({required this.apiUrl});

  Future<void> trackSMSEvent(Map<String, dynamic> event) async {
    final body = event['body']?.toString().toLowerCase() ?? '';
    if (_isTransactional(body)) {
      await _sendToServer([event]);
    } else {
      _addToBuffer(event);
    }
  }

  Future<void> trackCallEvent(Map<String, dynamic> event) async {
    print("Adding call log event: $event");
    _addToBuffer(event);
  }

  bool _isTransactional(String body) {
    const keywords = ['otp', 'transaction', 'debited', 'credited', 'spent'];
    return keywords.any((k) => body.contains(k));
  }

  void _addToBuffer(Map<String, dynamic> event) {
    print("Adding to buffer: $event");
    _buffer.add(event);
    _flushBuffer();
  }

  Future<void> _flushBuffer() async {
    final eventsToSend = List<Map<String, dynamic>>.from(_buffer);
    _buffer.clear();
    await _sendToServer(eventsToSend);
  }

  Future<void> _sendToServer(List<Map<String, dynamic>> events) async {
    print("Sending events to server: $events");  // Debug print
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/v1/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(events),
      );
      print("Sent ${events.length} events. Status: ${response.statusCode}");
    } catch (e) {
      print("Failed to send data: $e");
    }
  }

}
