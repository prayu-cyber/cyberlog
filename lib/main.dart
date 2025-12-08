import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CheckEvenOdd(),
    );
  }
}

class CheckEvenOdd extends StatefulWidget {
  const CheckEvenOdd({super.key});

  @override
  State<CheckEvenOdd> createState() => _CheckEvenOddState();
}

class _CheckEvenOddState extends State<CheckEvenOdd> {
  final TextEditingController numberController = TextEditingController();

  // Variable to show result
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Even or Odd App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // Input box
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter a number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Button
            ElevatedButton(
              onPressed: () {
                String input = numberController.text;

                // Convert to int
                int num = int.tryParse(input) ?? 0;

                // Condition check
                if (num % 2 == 0) {
                  result = "The number $num is Even.";
                } else {
                  result = "The number $num is Odd.";
                }

                // Refresh UI
                setState(() {});
              },
              child: const Text("Check"),
            ),

            const SizedBox(height: 20),

            // Output
            Text(
              result,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
