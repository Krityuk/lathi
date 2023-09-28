import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/Companion/screens/add_companion_screen.dart';

class PermissionsPage extends ConsumerStatefulWidget {
  static const routeName = '/permissions';
  const PermissionsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends ConsumerState<PermissionsPage> {
  final Map<Permission, bool> _permissionStatuses = {
    Permission.locationWhenInUse: false,
    Permission.contacts: false,
    Permission.microphone: false,
  };

  void jumpToAddCompanionScreen() {
    Navigator.pushReplacementNamed(context, AddCompanionScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kHeader1,
        elevation: 15.0,
        shadowColor: Colors.black,
        title: Text(
          'Laathi',
          style: TextStyle(
            shadows: const <Shadow>[
              Shadow(
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
                color: Colors.black26,
              ),
            ],
            fontSize: 33,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 40.0),
              child: Text(
                'Permissions',
                style: TextStyle(
                  color: kHeader1,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PermissionToggleSwitch(
              permission: Permission.locationWhenInUse,
              title: 'Location Permission (While in use)',
              onChanged: (value) {
                _togglePermissionStatus(Permission.locationWhenInUse, value);
              },
            ),
            PermissionToggleSwitch(
              permission: Permission.contacts,
              title: 'Contacts Permission',
              onChanged: (value) {
                _togglePermissionStatus(Permission.contacts, value);
              },
            ),
            PermissionToggleSwitch(
              permission: Permission.microphone,
              title: 'Microphone Permission',
              onChanged: (value) {
                _togglePermissionStatus(Permission.microphone, value);
              },
            ),
            PermissionToggleSwitch(
              permission: Permission.camera,
              title: 'Camera Permission',
              onChanged: (value) {
                _togglePermissionStatus(Permission.camera, value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _allPermissionsGranted() ? _navigateToHome : null,
              child: const Text('Next'),
            ),
            ElevatedButton(
              onPressed: jumpToAddCompanionScreen,
              child: const Text('Skip'),
            )
          ],
        ),
      ),
    );
  }

  void _togglePermissionStatus(Permission permission, bool value) {
    setState(() async {
      PermissionStatus deviceStatus = await permission.request();
      if (deviceStatus == PermissionStatus.granted) {
      } else if (deviceStatus == PermissionStatus.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This Permission is recommended.')));
      } else if (deviceStatus == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }
      _permissionStatuses[permission] = value;
    });
  }

  bool _allPermissionsGranted() {
    for (var status in _permissionStatuses.values) {
      if (!status) {
        return false;
      }
    }
    return true;
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, AddCompanionScreen.routeName);
  }
}

class PermissionToggleSwitch extends StatefulWidget {
  final Permission permission;
  final String title;
  final ValueChanged<bool> onChanged;

  const PermissionToggleSwitch({
    super.key,
    required this.permission,
    required this.title,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PermissionToggleSwitchState createState() => _PermissionToggleSwitchState();
}

class _PermissionToggleSwitchState extends State<PermissionToggleSwitch> {
  bool _status = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  void _checkPermissionStatus() async {
    var status = await widget.permission.status;
    setState(() {
      _status = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _status
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                    key: ValueKey<bool>(true),
                  )
                : const Icon(
                    Icons.check_circle_outline,
                    color: Colors.grey,
                    size: 24,
                    key: ValueKey<bool>(false),
                  ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _status = !_status;
                widget.onChanged(_status);
              });
            },
            child: Container(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: _status ? Colors.green : Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: AnimatedAlign(
                  alignment:
                      _status ? Alignment.centerRight : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
