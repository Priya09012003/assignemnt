import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({super.key});

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _initConnectivity();

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: isOnline ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(isOnline ? Icons.wifi : Icons.wifi_off, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(isOnline ? "Online" : "Offline", style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}
