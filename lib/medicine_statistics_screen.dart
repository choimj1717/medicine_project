import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MedicineStatisticsScreen extends StatefulWidget {
  const MedicineStatisticsScreen({super.key});

  @override
  State<MedicineStatisticsScreen> createState() => _MedicineStatisticsScreenState();
}

class _MedicineStatisticsScreenState extends State<MedicineStatisticsScreen> {
  String selectedPeriod = '주간';
  
  String _getPeriodRecords(List<QueryDocumentSnapshot> records) {
    final now = DateTime.now();
    int count = 0;
    
    switch (selectedPeriod) {
      case '주간':
        final weekStart = now.subtract(Duration(days: 6));
        count = records.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final recordDate = data['date'] as String?;
          if (recordDate == null) return false;
          final date = DateTime.parse(recordDate);
          return date.isAfter(weekStart.subtract(Duration(days: 1)));
        }).length;
        break;
      case '월간':
        final monthStart = DateTime(now.year, now.month, 1);
        count = records.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final recordDate = data['date'] as String?;
          if (recordDate == null) return false;
          final date = DateTime.parse(recordDate);
          return date.isAfter(monthStart.subtract(Duration(days: 1)));
        }).length;
        break;
      case '연간':
        final yearStart = DateTime(now.year, 1, 1);
        count = records.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final recordDate = data['date'] as String?;
          if (recordDate == null) return false;
          final date = DateTime.parse(recordDate);
          return date.isAfter(yearStart.subtract(Duration(days: 1)));
        }).length;
        break;
    }
    return '$count회';
  }
  
  String _getPeriodAverage(List<QueryDocumentSnapshot> records, List<QueryDocumentSnapshot> medicines) {
    if (medicines.isEmpty) return '0%';
    
    final recordCount = _getPeriodRecords(records);
    final count = int.parse(recordCount.replaceAll('회', ''));
    
    int expectedCount = 0;
    switch (selectedPeriod) {
      case '주간':
        expectedCount = medicines.length * 7;
        break;
      case '월간':
        expectedCount = medicines.length * 30;
        break;
      case '연간':
        expectedCount = medicines.length * 365;
        break;
    }
    
    if (expectedCount == 0) return '0%';
    final percentage = (count / expectedCount * 100).round();
    return '$percentage%';
  }
  
  String _getPeriodMissed(List<QueryDocumentSnapshot> records, List<QueryDocumentSnapshot> medicines) {
    if (medicines.isEmpty) return '0회';
    
    final recordCount = _getPeriodRecords(records);
    final count = int.parse(recordCount.replaceAll('회', ''));
    
    int expectedCount = 0;
    switch (selectedPeriod) {
      case '주간':
        expectedCount = medicines.length * 7;
        break;
      case '월간':
        expectedCount = medicines.length * 30;
        break;
      case '연간':
        expectedCount = medicines.length * 365;
        break;
    }
    
    final missed = expectedCount - count;
    return '${missed > 0 ? missed : 0}회';
  }
  
  List<FlSpot> _getChartData(List<QueryDocumentSnapshot> records) {
    if (records.isEmpty) {
      switch (selectedPeriod) {
        case '주간':
          return List.generate(7, (i) => FlSpot(i.toDouble(), 0));
        case '월간':
          return List.generate(4, (i) => FlSpot(i.toDouble(), 0));
        case '연간':
          return List.generate(12, (i) => FlSpot(i.toDouble(), 0));
        default:
          return [FlSpot(0, 0)];
      }
    }
    
    final now = DateTime.now();
    switch (selectedPeriod) {
      case '주간':
        return List.generate(7, (i) {
          final date = now.subtract(Duration(days: 6 - i));
          final dayRecords = records.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final recordDate = data['date'] as String?;
            return recordDate == DateFormat('yyyy-MM-dd').format(date);
          }).length;
          return FlSpot(i.toDouble(), dayRecords.toDouble());
        });
      case '월간':
        return List.generate(4, (i) {
          final weekStart = now.subtract(Duration(days: (3 - i) * 7));
          final weekEnd = weekStart.add(Duration(days: 6));
          final weekRecords = records.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final recordDate = data['date'] as String?;
            if (recordDate == null) return false;
            final date = DateTime.parse(recordDate);
            return date.isAfter(weekStart.subtract(Duration(days: 1))) && 
                   date.isBefore(weekEnd.add(Duration(days: 1)));
          }).length;
          return FlSpot(i.toDouble(), weekRecords.toDouble());
        });
      case '연간':
        return List.generate(12, (i) {
          final month = DateTime(now.year, i + 1);
          final monthRecords = records.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final recordDate = data['date'] as String?;
            if (recordDate == null) return false;
            final date = DateTime.parse(recordDate);
            return date.month == month.month && date.year == month.year;
          }).length;
          return FlSpot(i.toDouble(), monthRecords.toDouble());
        });
      default:
        return [FlSpot(0, 0)];
    }
  }
  
  List<String> _getBottomTitles() {
    switch (selectedPeriod) {
      case '주간':
        return ['월', '화', '수', '목', '금', '토', '일'];
      case '월간':
        return ['1주', '2주', '3주', '4주'];
      case '연간':
        return ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('복용 통계'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 기간 선택
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                children: ['주간', '월간', '연간'].map((period) {
                  final isSelected = selectedPeriod == period;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedPeriod = period),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[600] : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          period,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // 복용률 차트
            Container(
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
                      Icon(Icons.show_chart, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      const Text(
                        '복용률 추이',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('medicine_records')
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final records = snapshot.hasData ? snapshot.data!.docs : <QueryDocumentSnapshot>[];
                      final chartData = _getChartData(records);
                      final maxY = chartData.isEmpty ? 10.0 : chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;
                      
                      return SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: maxY,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: maxY / 5,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey[300]!,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  interval: maxY / 5,
                                  getTitlesWidget: (value, meta) {
                                    return Text('${value.toInt()}', style: TextStyle(fontSize: 10));
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final titles = _getBottomTitles();
                                    if (value.toInt() >= 0 && value.toInt() < titles.length) {
                                      return Text(titles[value.toInt()], style: TextStyle(fontSize: 10));
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: chartData,
                                isCurved: true,
                                color: Colors.blue[600],
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue[600]!.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 복용 현황 요약
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('medicine_records')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, recordSnapshot) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('medicines')
                      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, medicineSnapshot) {
                    final records = recordSnapshot.hasData ? recordSnapshot.data!.docs : <QueryDocumentSnapshot>[];
                    final medicines = medicineSnapshot.hasData ? medicineSnapshot.data!.docs : <QueryDocumentSnapshot>[];
                    
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                '$selectedPeriod 복용률',
                                _getPeriodAverage(records, medicines),
                                Colors.green,
                                Icons.trending_up,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                '$selectedPeriod 복용',
                                _getPeriodRecords(records),
                                Colors.blue,
                                Icons.medication,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                '$selectedPeriod 누락',
                                _getPeriodMissed(records, medicines),
                                Colors.red,
                                Icons.warning,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSummaryCard(
                                '등록된 약물',
                                '${medicines.length}개',
                                Colors.purple,
                                Icons.inventory,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // 약물별 복용 현황
            Container(
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
                      Icon(Icons.pie_chart, color: Colors.purple[600]),
                      const SizedBox(width: 8),
                      const Text(
                        '약물별 복용 현황',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('medicines')
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('등록된 약물이 없습니다.');
                      }

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('medicine_records')
                            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context, recordSnapshot) {
                          final records = recordSnapshot.hasData ? recordSnapshot.data!.docs : <QueryDocumentSnapshot>[];
                          
                          return Column(
                            children: snapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              final medicineName = data['name'] ?? '약물명 없음';
                              final medicineId = doc.id;
                              
                              // 해당 약물의 복용 기록 갯수 계산
                              final medicineRecords = records.where((record) {
                                final recordData = record.data() as Map<String, dynamic>;
                                return recordData['medicineId'] == medicineId;
                              }).length;
                              
                              // 예상 복용 횟수 (최근 7일 기준)
                              final expectedCount = 7; // 일주일간 매일 1회 복용 가정
                              final double progress = expectedCount > 0 ? (medicineRecords / expectedCount * 100).clamp(0, 100) : 0.0;
                              
                              final index = snapshot.data!.docs.indexOf(doc);
                              final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
                              
                              return _buildMedicineProgressItem(
                                medicineName,
                                progress,
                                colors[index % colors.length],
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 복용 기록
            Container(
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
                      Icon(Icons.history, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      const Text(
                        '최근 복용 기록',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('medicine_records')
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .limit(5)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('복용 기록이 없습니다.');
                      }

                      return Column(
                        children: snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final takenAt = (data['takenAt'] as Timestamp?)?.toDate();
                          
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: Icon(Icons.check, color: Colors.green[600]),
                            ),
                            title: Text(data['medicineName'] ?? '약물명 없음'),
                            subtitle: Text(
                              takenAt != null 
                                  ? DateFormat('MM/dd HH:mm').format(takenAt)
                                  : '시간 정보 없음',
                            ),
                            trailing: Icon(Icons.check_circle, color: Colors.green[600]),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
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
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineProgressItem(String name, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${progress.toInt()}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}