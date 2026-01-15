import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Displays a dismissible banner at the top of the screen when offline.
/// 
/// Automatically reappears if the user is still offline after dismissing.
/// Uses connectivity_plus package to monitor network status.
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      initialData: ConnectivityResult.wifi,
      builder: (context, snapshot) {
        final connectivityResult = snapshot.data ?? ConnectivityResult.wifi;
        final isOffline = connectivityResult == ConnectivityResult.none;

        // Reset dismiss state when connectivity changes
        if (!isOffline && _isDismissed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isDismissed = false;
              });
            }
          });
        }

        // Don't show if online or dismissed
        if (!isOffline || _isDismissed) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9500), Color(0xFFFFB84D)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                color: Colors.white,
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              const Expanded(
                child: Text(
                  'You\'re offline. Some features are disabled.',
                  style: TextStyle(
                    fontFamily: 'Feather',
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20.0,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _isDismissed = true;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
