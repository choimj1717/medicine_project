import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MedicineScheduleScreen extends StatefulWidget {
  const MedicineScheduleScreen({super.key});

  @override
  State<MedicineScheduleScreen> createState() => _MedicineScheduleScreenState();
}

class _MedicineScheduleScreenState extends State<MedicineScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('복용 일정'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 날짜 선택 헤더
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.subtract(const Duration(days: 1));
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('yyyy년 MM월 dd일').format(selectedDate),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE', 'ko_KR').format(selectedDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 1));
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          
          // 시간대별 복용 일정
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildTimeSlot('아침', '08:00', Icons.wb_sunny, Colors.orange),
                const SizedBox(height: 16),
                _buildTimeSlot('점심', '12:00', Icons.wb_sunny_outlined, Colors.blue),
                const SizedBox(height: 16),
                _buildTimeSlot('저녁', '18:00', Icons.nights_stay, Colors.indigo),
                const SizedBox(height: 16),
                _buildTimeSlot('취침 전', '22:00', Icons.bedtime, Colors.purple),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddScheduleDialog(),
        icon: const Icon(Icons.add_alarm),
        label: const Text('알림 추가'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTimeSlot(String timeLabel, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: color,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 해당 시간대 약물 목록
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('medicines')
                .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '이 시간대에 복용할 약이 없습니다',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }

              return Column(
                children: snapshot.data!.docs.take(2).map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.medication, color: color, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${data['name']} - ${data['dosage']}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _markAsTaken(doc.id, data['name']),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            minimumSize: const Size(60, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('복용', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void _markAsTaken(String medicineId, String medicineName) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 복용 기록 저장
      FirebaseFirestore.instance.collection('medicine_records').add({
        'userId': user.uid,
        'medicineId': medicineId,
        'medicineName': medicineName,
        'takenAt': FieldValue.serverTimestamp(),
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$medicineName 복용 완료!'),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.blue[600]),
              title: const Text('복용 시간 설정'),
              subtitle: const Text('08:00'),
              onTap: () {
                // 시간 선택 다이얼로그
              },
            ),
            ListTile(
              leading: Icon(Icons.repeat, color: Colors.green[600]),
              title: const Text('반복 설정'),
              subtitle: const Text('매일'),
              onTap: () {
                // 반복 설정 다이얼로그
              },
            ),
            ListTile(
              leading: Icon(Icons.volume_up, color: Colors.orange[600]),
              title: const Text('알림 소리'),
              subtitle: const Text('기본 알림음'),
              onTap: () {
                // 알림음 선택
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림이 설정되었습니다!')),
              );
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}