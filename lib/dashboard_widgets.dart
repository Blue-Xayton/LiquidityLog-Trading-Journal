// dashboard_widgets.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetricsStrip extends StatelessWidget {
  final int totalTrades;
  final double winrate;
  final String avgRR;
  final int streak;

  const MetricsStrip({
    Key? key,
    required this.totalTrades,
    required this.winrate,
    required this.avgRR,
    required this.streak,
  }) : super(key: key);




  Widget _metricCard(String title, String value, IconData icon, Color accent) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.03), Colors.white.withOpacity(0.01)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: accent),
                    SizedBox(width: 8),
                    Text(title,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                        )),
                  ],
                ),
                SizedBox(height: 8),
                Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _metricCard('Trades', '$totalTrades', Icons.list_alt, Colors.blueAccent),
        SizedBox(width: 12),
        _metricCard('Winrate', '${winrate.toStringAsFixed(1)}%', Icons.show_chart, Colors.greenAccent),
        SizedBox(width: 12),
        _metricCard('Avg R:R', avgRR, Icons.stacked_bar_chart, Colors.orangeAccent),
        SizedBox(width: 12),
        _metricCard('Streak', '$streak', Icons.whatshot, Colors.pinkAccent),
      ],
    );
  }
}

class XPBar extends StatelessWidget {
  final double progress; // 0..1
  const XPBar({Key? key, required this.progress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consistency', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
          ),
        ),
      ],
    );
  }
}
