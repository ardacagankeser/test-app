import 'package:flutter/material.dart';
import "package:test_app_rev/models/medical_test.dart";

class TestCard extends StatelessWidget {
  final MedicalTest test;
  final bool isAdmin;
  final VoidCallback onSolve;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const TestCard({
    super.key,
    required this.test,
    required this.isAdmin,
    required this.onSolve,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: EdgeInsets.only(bottom: 16),

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),

      child: Column(
        children: [
          Container(
            width: double.infinity,

            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),

            decoration: BoxDecoration(
              color: colorScheme.primary,

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),

            child: Text(
              test.title,

              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  test.description, 
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today, 
                      size: 16, 
                      color: colorScheme.onSecondaryContainer,
                    ),

                    SizedBox(width: 6),

                    Text(
                      'Oluşturulma: ${test.createdAt.day}/${test.createdAt.month}/${test.createdAt.year}',

                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),

                    SizedBox(width: 16),

                    Icon(
                      Icons.question_answer, 
                      size: 16,
                      color: colorScheme.onSecondaryContainer,
                    ),

                    SizedBox(width: 6),

                    Text(
                      '${test.questions.length} Soru',

                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  
                  children: [
                    ElevatedButton.icon(
                      onPressed: onSolve,

                      icon: Icon(
                        Icons.play_arrow,
                        color: colorScheme.primary,
                      ),

                      label: Text(
                        'Çöz',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    ),

                    if (isAdmin && onUpdate != null)
                      ElevatedButton.icon(
                        onPressed: onUpdate,

                        icon: Icon(
                          Icons.edit, 
                          color: colorScheme.tertiary,
                        ),

                        label: Text(
                          'Düzenle', 
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.tertiary,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.tertiaryContainer,
                        ),
                      ),

                    if (isAdmin && onDelete != null)
                      ElevatedButton.icon(
                        onPressed: onDelete,

                        icon: Icon(
                          Icons.delete, 
                          color: colorScheme.error,
                        ),

                        label: Text(
                          'Sil', 
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.error,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.errorContainer,
                        ),
                      ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}