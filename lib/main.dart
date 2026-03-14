import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'iPhone Home',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  void _showDialog(BuildContext context, String title) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        actions: [
          CupertinoDialogAction(child: Text('OK'), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Home'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton.filled(
                child: Text('Profile'),
                onPressed: () => _showDialog(context, 'Profile tapped'),
              ),
              SizedBox(height: 12),
              CupertinoButton(
                child: Text('Settings'),
                onPressed: () => _showDialog(context, 'Settings tapped'),
              ),
              SizedBox(height: 12),
              CupertinoButton(
                color: CupertinoColors.destructiveRed,
                child: Text('Sign Out'),
                onPressed: () => _showDialog(context, 'Signed out'),
              ),
              SizedBox(height: 24),
              CupertinoButton(
                child: Text('Show Action Sheet'),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (ctx) => CupertinoActionSheet(
                      title: Text('Choose an option'),
                      actions: [
                        CupertinoActionSheetAction(
                          child: Text('Option 1'),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showDialog(context, 'Option 1');
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text('Option 2'),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showDialog(context, 'Option 2');
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
