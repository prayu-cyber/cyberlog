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
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ================= SECURE STORAGE =================
const secureStorage = FlutterSecureStorage();

/// ================= PROVIDER =================

class LogsProvider extends ChangeNotifier {
  int logCount = 0;
  bool darkMode = false;
  bool unlocked = false;

  LogsProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    logCount = prefs.getInt('logCount') ?? 0;
    darkMode = prefs.getBool('darkMode') ?? false;

    final pin = await secureStorage.read(key: "app_pin");
    unlocked = pin == null ? false : false; // always ask PIN
    notifyListeners();
  }

  Future<void> unlock() async {
    unlocked = true;
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

/// ================= MAIN =================

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
    final p = Provider.of<LogsProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: p.darkMode ? ThemeData.dark() : ThemeData.light(),
      home: p.unlocked ? const MainScreen() : const PinGate(),
    );
  }
}

/// ================= PIN GATE =================

class PinGate extends StatefulWidget {
  const PinGate({super.key});

  @override
  State<PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<PinGate> {
  final ctrl = TextEditingController();
  bool creating = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {
    final pin = await secureStorage.read(key: "app_pin");
    setState(() => creating = pin == null);
  }

  Future<void> _submit() async {
    final stored = await secureStorage.read(key: "app_pin");

    if (!mounted) return; // ✅ ADD THIS

    if (stored == null) {
      await secureStorage.write(key: "app_pin", value: ctrl.text);
      if (!mounted) return;
      Provider.of<LogsProvider>(context, listen: false).unlock();
    } else if (stored == ctrl.text) {
      Provider.of<LogsProvider>(context, listen: false).unlock();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  creating ? "🔐 Create App PIN" : "🔐 Enter App PIN",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: ctrl,
                  maxLength: 4,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(creating ? "Save PIN" : "Unlock"),
                ),
                if (error.isNotEmpty)
                  Text(error, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                const Text(
                  "PIN is securely stored on this device\n(Survives reinstall)",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= MAIN SCREEN =================

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
    SecurityChecklistPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: "Security"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

/// ================= INTERNET UTILS =================

Future<bool> hasRealInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// ================= HOME =================

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
      } else {
        if (!online) {
          await _fetchTip();
        }
        setState(() {
          online = true;
        }
      );
      }
    });
  }

  Future<void> _loadCachedTip() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => tip = prefs.getString("cachedTip") ?? tip);
  }

  Future<void> _fetchTip() async {
    try {
      final res = await http.get(Uri.parse("https://zenquotes.io/api/random"));
      final data = jsonDecode(res.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("cachedTip", data[0]['q']);
      setState(() => tip = data[0]['q']);
    } catch (_) {
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
                TextButton(onPressed: _fetchTip, child: const Text("Refresh")),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= LOGS =================

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
          ElevatedButton(onPressed: p.addLog, child: const Text("Add Log")),
        ],
      ),
    );
  }
}

/// ================= MEDIA =================
/// (zoom + delete preserved)

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
    if (src == ImageSource.camera &&
        !await Permission.camera.request().isGranted) return;
    if (src == ImageSource.gallery &&
        !await Permission.photos.request().isGranted) return;

    final picked = await picker.pickImage(source: src);
    if (picked != null) {
      final dir = await getApplicationDocumentsDirectory();
      final saved = await File(picked.path)
          .copy("${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
      setState(() => images.add(saved));
    }
  }

  void _open(File img) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageViewer(
          image: img,
          onDelete: () {
            img.deleteSync();
            setState(() => images.remove(img));
            Navigator.pop(context);
          },
        ),
      ),
    );
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
              onTap: () => _open(images[i]),
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

/// ================= IMAGE VIEWER =================

class ImageViewer extends StatelessWidget {
  final File image;
  final VoidCallback onDelete;

  const ImageViewer({super.key, required this.image, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Viewer"),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete)
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(child: Image.file(image)),
      ),
    );
  }
}

/// ================= PERMISSIONS =================

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
      builder: (_, snap) => snap.hasData
          ? ListView(children: snap.data!)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

/// ================= SECURITY CHECKLIST =================
class SecurityChecklistPage extends StatelessWidget {
  const SecurityChecklistPage({super.key});

  Widget _statusTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  Widget _tip(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "🔐 Security Awareness Dashboard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        /// ⚠️ Awareness banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Security risks detected. Review permissions and protect your data.",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// ✅ Security status cards
        _statusTile(
          icon: Icons.lock,
          color: Colors.green,
          title: "App Lock Enabled",
          subtitle: "Your data is protected using a custom PIN.",
        ),

        _statusTile(
          icon: Icons.camera_alt,
          color: Colors.red,
          title: "Camera Permission (High Risk)",
          subtitle:
          "Camera access can be misused. Grant only if absolutely required.",
        ),

        _statusTile(
          icon: Icons.folder,
          color: Colors.orange,
          title: "Storage Permission (Medium Risk)",
          subtitle:
          "Storage access may expose personal files if misused.",
        ),

        _statusTile(
          icon: Icons.developer_mode,
          color: Colors.orange,
          title: "Root / Emulator Check",
          subtitle: "Advanced detection not enabled (placeholder).",
        ),

        const SizedBox(height: 20),

        const Text(
          "🧠 Security Tips",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        _tip("Avoid granting unnecessary permissions to apps."),
        const SizedBox(height: 6),
        _tip("Use app locks to protect sensitive information."),
        const SizedBox(height: 6),
        _tip("Do not install apps from unknown or untrusted sources."),
        const SizedBox(height: 6),
        _tip("Keep your device OS and apps updated."),
      ],
    );
  }
}


/// ================= SETTINGS =================

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const platform = MethodChannel('device_info_channel');
  String model = "Loading...";
  String version = "Loading...";
  String manufacturer = "Loading...";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final Map info = await platform.invokeMethod('getDeviceInfo');
    setState(() {
      model = info['model'];
      version = info['version'];
      manufacturer = info['manufacturer'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Text("Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.phone_android),
          title: const Text("Device Model"),
          trailing: Text(model),
        ),
        ListTile(
          leading: const Icon(Icons.factory),
          title: const Text("Manufacturer"),
          trailing: Text(manufacturer),
        ),
        ListTile(
          leading: const Icon(Icons.android),
          title: const Text("Android Version"),
          trailing: Text(version),
        ),
      ],
    );
  }
}
