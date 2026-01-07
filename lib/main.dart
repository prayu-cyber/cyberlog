import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

#PROVIDER

class LogsProvider extends ChangeNotifier {
  int logCount = 0;
  bool darkMode = false;

  LogsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    logCount = prefs.getInt('logCount') ?? 0;
    darkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  Future<void> addLog() async {
    logCount++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('logCount', logCount);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    darkMode = !darkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
    notifyListeners();
  }
}

#MAIN

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LogsProvider(),
      child: const CyberLogApp(),
    ),
  );
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LogsProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: provider.darkMode ? ThemeData.dark() : ThemeData.light(),
      home: const MainScreen(),
    );
  }
}

#MAIN SCREEN=

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final pages = const [
    HomePage(),
    LogsPage(),
    MediaPage(),
    PermissionPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CyberLog"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              Provider.of<LogsProvider>(context, listen: false).toggleTheme();
            },
          )
        ],
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Logs"),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Media"),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: "Permissions"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

#INTERNET UTILS

Future<bool> hasRealInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

#HOME

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String tip = "Checking internet...";
  bool online = true;
  StreamSubscription? sub;

  @override
  void initState() {
    super.initState();
    _loadCachedTip();
    _listenInternet();
  }

  void _listenInternet() {
    sub = Connectivity().onConnectivityChanged.listen((_) async {
      final ok = await hasRealInternet();
      if (!mounted) return;

      if (!ok) {
        setState(() {
          online = false;
          tip = "No Internet ❌";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please check your internet connection")),
        );
      } else {
        if (!online) {
          await _fetchTip();
        }
        setState(() => online = true);
      }
    });
  }

  Future<void> _loadCachedTip() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tip = prefs.getString("cachedTip") ?? tip;
    });
  }

  Future<void> _fetchTip() async {
    try {
      final res =
      await http.get(Uri.parse("https://zenquotes.io/api/random"));
      final data = jsonDecode(res.body);
      final newTip = data[0]['q'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("cachedTip", newTip);
      if (!mounted) return;
      setState(() => tip = newTip);
    } catch (_) {
      if (!mounted) return;
      setState(() => tip = "No Internet ❌");
    }
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("🛡 Cyber Tip",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(tip, textAlign: TextAlign.center),
              if (online)
                TextButton(
                  onPressed: _fetchTip,
                  child: const Text("Refresh"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

#LOGS

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<LogsProvider>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Total Logs: ${p.logCount}",
              style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: p.addLog,
            child: const Text("Add Log"),
          ),
        ],
      ),
    );
  }
}

#MEDIA

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final picker = ImagePicker();
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final dir = await getApplicationDocumentsDirectory();
    setState(() {
      images = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith(".jpg"))
          .toList();
    });
  }

  Future<void> _pick(ImageSource src) async {
    if (src == ImageSource.camera) {
      if (!await Permission.camera.request().isGranted) return;
    } else {
      if (!await Permission.photos.request().isGranted) return;
    }

    final picked = await picker.pickImage(source: src);
    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      final saved = await File(picked.path)
          .copy("${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
      setState(() => images.add(saved));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: images.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullImageViewer(
                      image: images[i],
                      onDelete: () {
                        images[i].deleteSync();
                        setState(() => images.removeAt(i));
                      },
                    ),
                  ),
                );
              },
              child: Image.file(images[i], fit: BoxFit.cover),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pick(ImageSource.camera),
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo),
                label: const Text("Gallery"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

#IMAGE VIEWER 

class FullImageViewer extends StatelessWidget {
  final File image;
  final VoidCallback onDelete;

  const FullImageViewer({
    super.key,
    required this.image,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
        )
      ]),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        child: Center(child: Image.file(image)),
      ),
    );
  }
}

#PERMISSIONS

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  Future<ListTile> _tile(String name, Permission p) async {
    final s = await p.status;
    return ListTile(
      title: Text(name),
      trailing: Text(
        s.isGranted ? "Granted" : "Denied",
        style: TextStyle(color: s.isGranted ? Colors.green : Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _tile("Camera", Permission.camera),
        _tile("Storage", Permission.photos),
      ]),
      builder: (_, snap) =>
      snap.hasData ? ListView(children: snap.data!) : const Center(child: CircularProgressIndicator()),
    );
  }
}

# SETTINGS 

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Dark mode\nCamera & Storage permissions\nImages saved permanently",
        textAlign: TextAlign.center,
      ),
    );
  }
}
