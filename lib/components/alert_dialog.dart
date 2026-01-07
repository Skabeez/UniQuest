import 'package:flutter/material.dart';

class ModernAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final bool isPrimaryDanger;
  final Widget? customFooter;

  const ModernAlertDialog({
    super.key,
    required this.title,
    required this.description,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.isPrimaryDanger = false,
    this.customFooter,
  });

  @override
  Widget build(BuildContext context) {
    // Only show close button for informational dialogs (single button or no secondary button)
    final bool showCloseButton = secondaryButtonText == null;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with optional close button
            if (showCloseButton)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A3A3A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFFB0B0B0),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 32),
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 12.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Feather',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Description
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 32.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Feather',
                  fontSize: 14.0,
                  color: Color(0xFFB0B0B0),
                  height: 1.5,
                ),
              ),
            ),
            // Buttons
            if (primaryButtonText != null || secondaryButtonText != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                child: Column(
                  children: [
                    // Secondary button (danger/outlined)
                    if (secondaryButtonText != null)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: onSecondaryPressed ??
                              () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFFF5757),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          child: Text(
                            secondaryButtonText!,
                            style: const TextStyle(
                              fontFamily: 'Feather',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF5757),
                            ),
                          ),
                        ),
                      ),
                    if (secondaryButtonText != null &&
                        primaryButtonText != null)
                      const SizedBox(height: 12),
                    // Primary button (filled)
                    if (primaryButtonText != null)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed:
                              onPrimaryPressed ?? () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPrimaryDanger
                                ? const Color(0xFFFF5757)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            primaryButtonText!,
                            style: TextStyle(
                              fontFamily: 'Feather',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: isPrimaryDanger
                                  ? Colors.white
                                  : const Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            // Custom footer (like timer)
            if (customFooter != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 20.0),
                child: customFooter!,
              ),
          ],
        ),
      ),
    );
  }
}
