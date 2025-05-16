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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Testler',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
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
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
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

                    icon: Icon(
                      Icons.add,
                      color: colorScheme.primary,
                    ),

                    label: Text(
                      'Yeni Test Oluştur',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer
                    ),
                  ),
              ],
            ),

            SizedBox(height: 16),

            Expanded(
              child: tests.isEmpty 
              ? Center(
                child: Text(
                  'Test yok. Test eklemek için yukarıdaki butona tıklayın.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                )
              )
              
              : ListView.builder(
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