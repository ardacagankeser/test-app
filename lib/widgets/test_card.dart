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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(80,100,130,1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              test.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(test.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Color.fromRGBO(80,100,130,1)),
                    const SizedBox(width: 6),
                    Text(
                      'Oluşturulma: ${test.createdAt.day}/${test.createdAt.month}/${test.createdAt.year}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.question_answer, size: 16, color: Color.fromRGBO(80,100,130,1)),
                    const SizedBox(width: 6),
                    Text(
                      '${test.questions.length} Soru',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  
                  children: [
                    ElevatedButton.icon(
                      onPressed: onSolve,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Çöz', style: TextStyle(color: Color.fromRGBO(80,100,130,1), fontWeight: FontWeight.bold),),
                    ),

                    if (isAdmin && onUpdate != null)
                      ElevatedButton.icon(
                        onPressed: onUpdate,
                        icon: const Icon(Icons.edit, color: Colors.white,),
                        label: const Text('Düzenle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                        ),
                      ),

                    if (isAdmin && onDelete != null)
                      ElevatedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.white,),
                        label: const Text('Sil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800],
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