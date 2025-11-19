// trade_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TradeCard extends StatelessWidget {
  final Map<String, String> trade;
  final VoidCallback? onTap;

  const TradeCard({Key? key, required this.trade, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWin = (trade['Win/Loss'] ?? '').toLowerCase() == 'win';
    final color = isWin ? Colors.greenAccent : Colors.redAccent;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(width: 6, height: 84, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trade['symbol for the pair'] ?? '',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text('Entry: ${trade['entry price level'] ?? '-'}', style: TextStyle(color: Colors.white70)),
                        SizedBox(width: 16),
                        Text('Exit: ${trade['exit price level'] ?? '-'}', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(trade['Strategy'] ?? '', style: TextStyle(color: Colors.black)),
                          backgroundColor: Colors.yellowAccent,
                        ),
                        Text(trade['Win/Loss'] ?? '', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
