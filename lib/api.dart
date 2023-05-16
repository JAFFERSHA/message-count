import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageData extends StatelessWidget {
  final Data data;

  const MessageData({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Count'),
      ),
      body: Center(
        child: ListTile(
          title: Text(data.id),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Start Date: ${data.startDate}'),
              const SizedBox(height: 20),
              Text('End Date: ${data.endDate}'),
              const SizedBox(height: 20),
              Text('Message count: ${data.messageCount}'),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Data> fetchData() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:3000/api/1.0/message'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    final Map<String, dynamic> dataMap = jsonResponse.first;
    return Data.fromJson(dataMap);
  } else {
    throw Exception('Failed to load data');
  }
}

class Data {
  final String id;
  final int messageCount;
  final String startDate;
  final String endDate;

  Data({
    required this.id,
    required this.messageCount,
    required this.startDate,
    required this.endDate,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? '',
      messageCount: json['messageCount'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}
