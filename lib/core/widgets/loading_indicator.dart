import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  
  const LoadingIndicator({super.key, this.message, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C3A2A)),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5C6B5A),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  final String? message;
  
  const FullScreenLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C3A2A)),
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2C3A2A),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}