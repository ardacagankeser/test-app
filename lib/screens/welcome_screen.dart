import 'package:flutter/material.dart';
import "package:test_app_rev/models/medical_test.dart";
import '../data/sample_tests.dart';
import 'create_test_screen.dart';
import 'take_test_screen.dart';
import '../widgets/test_card.dart';
import 'package:provider/provider.dart';
import '../theme_notifier.dart';

class WelcomeScreen extends StatefulWidget {
  final bool isAdmin;

  const WelcomeScreen({super.key, required this.isAdmin});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<MedicalTest> tests = sampleTests;

  void _addNewTest(MedicalTest newTest) {
    setState(() {
      tests.add(newTest);
    });
  }

  void _deleteTest(MedicalTest test) {
    setState(() {
      tests.removeWhere((t) => t.id == test.id);
    });
  }

  void _updateTest(MedicalTest t, index) {
    setState(() {
      tests[index] = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Testler',
            style: TextStyle(
            color: Color.fromRGBO(80,100,130,1),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: Icon(
              themeNotifier.brightness == Brightness.dark 
                ? Icons.nightlight_round_sharp 
                : Icons.sunny,
              color: themeNotifier.brightness == Brightness.dark 
                ? Colors.white 
                : Colors.yellow[800],
            ),
            onPressed: () {
              themeNotifier.toggleBrightness();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isAdmin ? 'Hoş Geldiniz, Admin' : 'Hoş Geldiniz',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),

                if (widget.isAdmin)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateTestScreen(onTestCreated: _addNewTest),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text('Yeni Test Oluştur'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromRGBO(80,100,130,1),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Mevcut Testler', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              )
            ),

            const SizedBox(height: 8),

            Expanded(
              child: tests.isEmpty ? const Center(child: Text('Henüz test yok.')) :
              
                ListView.builder(
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    return TestCard(
                      test: test,
                      isAdmin: widget.isAdmin,
                      onSolve: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TakeTestScreen(test: test)),
                        );
                      },
                      onDelete: widget.isAdmin ? () => _deleteTest(test) : null,

                      onUpdate: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTestScreen(
                              existingTest: test,
                              onTestCreated: (updatedTest) {
                                _updateTest(updatedTest, index); // index needs to be in scope
                              },
                            ),
                          ),
                        );
                      },
                      
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}