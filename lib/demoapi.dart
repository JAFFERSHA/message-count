import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MessageData(),
    );
  }
}

class MessageData extends StatelessWidget {
  const MessageData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Count'),
      ),
      body: FutureBuilder<List<Data>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].id),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Start Date: ${data[index].startDate}'),
                      const SizedBox(height: 20),
                      Text('End Date: ${data[index].endDate}'),
                      const SizedBox(height: 20),
                      Text('Phone number: ${data[index].phoneNumber}'),
                      const SizedBox(height: 20),
                      Text('Message count: ${data[index].messageCount}'),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<List<Data>> fetchData() async {
  final response =
      await http.get(Uri.parse('http://172.20.10.5:3000/api/1.0/message'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((dataMap) => Data.fromJson(dataMap)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class Data {
  final String id;
  final int messageCount;
  final String startDate;
  final String endDate;
  final String phoneNumber;

  Data({
    required this.id,
    required this.messageCount,
    required this.startDate,
    required this.endDate,
    required this.phoneNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? '',
      messageCount: json['messageCount'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}
