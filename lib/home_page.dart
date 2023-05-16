import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled68/api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final phoneNumberController = TextEditingController();
  String _selectedStartDate = '';
  String _selectedEndDate = '';

  Future<void> _getMessageCount() async {
    try {
      final Data data = await fetchData();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageData(data: data),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = DateFormat('dd-MM-yyyy').format(picked.start);
        _selectedEndDate = DateFormat('dd-MM-yyyy').format(picked.end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '  Phone Number:',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: 'Enter phone number',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '  Date Range:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  onTap: () => _selectDateRange(context),
                  decoration: InputDecoration(
                    hintText: 'Select date range',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10000000),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    prefixIcon: const SizedBox(
                      height: 70,
                      width: 50,
                      child: IconTheme(
                        data: IconThemeData(
                          color:
                              Colors.purple, // set the color of the icon here
                        ),
                        child: Icon(Icons.calendar_month_sharp),
                      ),
                    ),
                  ),
                  controller: TextEditingController(
                    text: _selectedStartDate.isEmpty && _selectedEndDate.isEmpty
                        ? ''
                        : '$_selectedStartDate - $_selectedEndDate',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _getMessageCount,
              child: const Text('Get Message Count'),
            ),
          ],
        ),
      ),
    );
  }
}
