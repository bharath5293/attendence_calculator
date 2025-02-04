import 'package:flutter/material.dart';

void main() {
  runApp(AttendanceCalculator());
}

class AttendanceCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Controllers
  final TextEditingController _presentController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  // Dropdown for percentage required
  double _percentageRequired = 75.0;

  // Result variables
  int _bunkableDays = 0;
  double _currentAttendance = 0.0;
  double _attendanceThen = 0.0;

  void calculateAttendance() {
    final int present = int.tryParse(_presentController.text) ?? 0;
    final int total = int.tryParse(_totalController.text) ?? 0;

    if (total == 0 || total < present) {
      // Invalid input handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid input! Check Present and Total days.")),
      );
      return;
    }

    setState(() {
      // Current attendance
      _currentAttendance = (present / total) * 100;

      // Max days user can bunk while maintaining required percentage
      int requiredTotal = present * 100 ~/ _percentageRequired;
      _bunkableDays = requiredTotal - total;

      // Attendance after bunking
      int newTotal = total + _bunkableDays;
      _attendanceThen = (present / newTotal) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for percentage required
            Text("Percentage Required"),
            DropdownButtonFormField<double>(
              value: _percentageRequired,
              items: [75.0, 80.0, 85.0]
                  .map((e) => DropdownMenuItem<double>(
                        value: e,
                        child: Text("${e.toInt()}%"),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _percentageRequired = value!;
                });
              },
            ),
            SizedBox(height: 16),

            // Input: Present Days
            Text("Present"),
            TextField(
              controller: _presentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Present Days',
              ),
            ),
            SizedBox(height: 16),

            // Input: Total Days
            Text("Total"),
            TextField(
              controller: _totalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Total Days',
              ),
            ),
            SizedBox(height: 16),

            // Calculate Button
            Center(
              child: ElevatedButton(
                onPressed: calculateAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text("Calculate", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 16),

            // Results Display under the Calculate button
            if (_bunkableDays > 0) ...[
              SizedBox(height: 16),
              Text(
                "You can bunk for $_bunkableDays more days.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Current Attendance: ${_currentAttendance.toStringAsFixed(2)}%",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Attendance Then: ${_attendanceThen.toStringAsFixed(2)}%",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
