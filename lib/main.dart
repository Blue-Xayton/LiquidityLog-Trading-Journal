import 'dart:convert';
// ignore: unnecessary_import
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dashboard_widgets.dart'; // metrics strip & tradecard widgets
import 'trade_card.dart';
import 'profile_page.dart';
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(const TradingJournalApp());

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF0F1720),
  textTheme: TextTheme(
    headlineSmall: GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
  ),
);

class TradingJournalApp extends StatelessWidget {
  const TradingJournalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trading Journal',
      theme: appTheme,
      home: ProfilePage(),
    );
  }
}

Route createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class TradingJournalHomePage extends StatefulWidget {
  final String username;
  const TradingJournalHomePage({Key? key, required this.username})
    : super(key: key);

  @override
  _TradingJournalHomePageState createState() => _TradingJournalHomePageState();
}

class _TradingJournalHomePageState extends State<TradingJournalHomePage> {
  final List<Map<String, String>> recentTrades = [];
  @override
  void initState() {
    super.initState();
    _loadTrades();
  }

  Future<void> _loadTrades() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('trades_json');
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      setState(() {
        recentTrades.clear();
        recentTrades.addAll(decoded.map((e) => Map<String, String>.from(e)));
      });
    }
  }

  Future<void> _saveTrades() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('trades_json', jsonEncode(recentTrades));
  }

  int calculateStreak() {
    if (recentTrades.isEmpty) return 0;

    int streak = 0;
    String lastOutcome = recentTrades.first['Win/Loss']?.toLowerCase() ?? '';

    for (var trade in recentTrades) {
      String outcome = trade['Win/Loss']?.toLowerCase() ?? '';

      if (outcome == lastOutcome) {
        streak++;
      } else {}
    }
    //If its losses, return the negative streak
    return lastOutcome == 'loss' ? -streak : streak;
  }

  void _showAddTradeModal() {
    HapticFeedback.lightImpact();
    final _modalFormKey = GlobalKey<FormState>();
    String symbol = '', entry = '', exit = '', note = '', outcome = '', rr = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: controller,
                child: Form(
                  key: _modalFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Add Trade',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Symbol',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white),
                        onSaved: (v) => symbol = v ?? '',
                        validator:
                            (v) =>
                                (v == null || v.isEmpty)
                                    ? 'Enter symbol'
                                    : null,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Entry',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: TextStyle(color: Colors.white),
                              onSaved: (v) => entry = v ?? '',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Exit',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              style: TextStyle(color: Colors.white),
                              onSaved: (v) => exit = v ?? '',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'R:R (example 1.5)',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onSaved: (v) => rr = v ?? '',
                        validator:
                            (v) =>
                                (v == null || v.isEmpty) ? 'Enter R:R' : null,
                      ),

                      SizedBox(height: 8),

                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Strategy / Note',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white),
                        onSaved: (v) => note = v ?? '',
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.grey[850],
                        decoration: InputDecoration(
                          labelText: 'Outcome',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        items:
                            ['Win', 'Loss']
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(
                                      s,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => outcome = v ?? '',
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellowAccent,
                              ),
                              onPressed: () async {
                                if (_modalFormKey.currentState?.validate() ??
                                    false) {
                                  _modalFormKey.currentState?.save();
                                  setState(() {
                                    recentTrades.insert(0, {
                                      'symbol for the pair': symbol,
                                      'entry price level': entry,
                                      'exit price level': exit,
                                      'rr': rr,
                                      'Win/Loss': outcome,
                                      'Strategy': note,
                                    });
                                  });
                                  await _saveTrades();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAnalytics() {
    int totalTrades = recentTrades.length;
    int wins =
        recentTrades
            .where((t) => (t['Win/Loss'] ?? '').toLowerCase() == 'win')
            .length;
    int losses = totalTrades - wins;
    double winrate = totalTrades > 0 ? (wins / totalTrades) * 100 : 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (ctx) => Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Trade Analytics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: wins.toDouble(),
                          color: Colors.greenAccent,
                          radius: 60,
                          title: '',
                        ),
                        PieChartSectionData(
                          value: losses.toDouble(),
                          color: Colors.redAccent,
                          radius: 60,
                          title: '',
                        ),
                      ],
                      centerSpaceRadius: 40,
                      sectionsSpace: 4,
                    ),
                    swapAnimationDuration: Duration(milliseconds: 800),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${winrate.toStringAsFixed(1)}% Winrate',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('Total', style: TextStyle(color: Colors.white70)),
                        Text(
                          '$totalTrades',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Wins', style: TextStyle(color: Colors.white70)),
                        Text(
                          '$wins',
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Losses', style: TextStyle(color: Colors.white70)),
                        Text(
                          '$losses',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalTrades = recentTrades.length;
    int wins =
        recentTrades
            .where((t) => (t['Win/Loss'] ?? '').toLowerCase() == 'win')
            .length;
    double winrate = totalTrades > 0 ? (wins / totalTrades) * 100 : 0;

    double avgRR = 0;

    if (recentTrades.isNotEmpty) {
      double sumRR = 0;
      int count = 0;

      for (var t in recentTrades) {
        if (t['rr'] != null && t['rr']!.isNotEmpty) {
          sumRR += double.tryParse(t['rr']!) ?? 0;
          count++;
        }
      }

      if (count > 0) {
        avgRR = sumRR / count;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LiquidityLog',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Icon(Icons.stacked_bar_chart, color: Colors.yellow),
            SizedBox(width: 8),
          ],
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF081229), Color(0xFF073B4C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MetricsStrip(
              totalTrades: totalTrades,
              winrate: winrate,
              avgRR: avgRR.toStringAsFixed(2),
              streak: calculateStreak(),
            ),

            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddTradeModal,
                  icon: Icon(Icons.add),
                  label: Text('Add Trade'),
                ),
                ElevatedButton.icon(
                  onPressed: _showAnalytics,
                  icon: Icon(Icons.show_chart),
                  label: Text('View Analytics'),
                ),
              ],
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Trades',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: recentTrades.map((t) => TradeCard(trade: t)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
