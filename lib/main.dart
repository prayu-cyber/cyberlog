import 'package:flutter/material.dart';

void main() {
  runApp(const CyberLogApp());
}

class Log {
  String action;
  DateTime timestamp;
  String status;

  Log(this.action, this.timestamp, this.status);
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  String formatDateTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
        '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  @override
  Widget build(BuildContext context) {
    List<Log> logs = [
      Log("User Logged In", DateTime.now().subtract(const Duration(minutes: 2)), "Success"),
      Log("Attempted Password Change", DateTime.now().subtract(const Duration(minutes: 1)), "Failed"),
      Log("Data Synced", DateTime.now(), "Success"),
      Log("User Logged Out", DateTime.now().add(const Duration(minutes: 1)), "Success"),
    ];

    return MaterialApp(
      title: 'CyberLog',
      home: Scaffold(
        appBar: AppBar(title: const Text('CyberLog Activity Logs')),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: logs.map((log) {
              String formatted = formatDateTime(log.timestamp);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    log.status.toLowerCase() == 'success' ? Icons.check_circle : Icons.error,
                    color: log.status.toLowerCase() == 'success' ? Colors.green : Colors.red,
                  ),
                  title: Text(log.action, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('$formatted • ${log.status}'),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
