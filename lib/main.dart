import 'dart:io';

import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Map Viewer',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Home')),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton.filled(
                child: Text('Open Maps Viewer'),
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => MapsPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  void _loadFiles() {
    final dir = Directory('maps');
    if (dir.existsSync()) {
      try {
        _files = dir.listSync().toList();
      } catch (_) {
        _files = [];
      }
    }
    setState(() {});
  }

  Future<void> _openWithSystem(String path) async {
    try {
      if (Platform.isMacOS) {
        await Process.run('open', [path]);
      } else if (Platform.isWindows) {
        await Process.run('cmd', ['/c', 'start', '', path]);
      } else {
        await Process.run('xdg-open', [path]);
      }
    } catch (e) {
      await showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Error opening file'),
          content: Text(e.toString()),
          actions: [CupertinoDialogAction(child: Text('OK'), onPressed: () => Navigator.pop(context))],
        ),
      );
    }
  }

  String _basename(String path) {
    return path.split(Platform.pathSeparator).last;
  }

  bool _isImage(String path) {
    final p = path.toLowerCase();
    return p.endsWith('.png') || p.endsWith('.jpg') || p.endsWith('.jpeg') || p.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Maps')),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: _files.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No files found in the maps/ directory.'),
                    SizedBox(height: 12),
                    CupertinoButton(child: Text('Refresh'), onPressed: _loadFiles),
                  ],
                )
              : ListView.builder(
                  itemCount: _files.length,
                  itemBuilder: (ctx, i) {
                    final f = _files[i];
                    final path = f.path;
                    final name = _basename(path);
                    if (_isImage(path)) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text(name)),
                          Image.file(File(path), width: double.infinity, height: 240, fit: BoxFit.cover),
                          SizedBox(height: 8),
                        ],
                      );
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: CupertinoTheme.of(context).textTheme.textStyle),
                                SizedBox(height: 4),
                                Text(
                                  path,
                                  style: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .copyWith(fontSize: 12, color: CupertinoColors.systemGrey),
                                ),
                              ],
                            ),
                          ),
                          CupertinoButton(child: Text('Open'), onPressed: () => _openWithSystem(path)),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
