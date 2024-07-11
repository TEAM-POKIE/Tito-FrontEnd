import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/models/debate_info.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tito_app/provider/nav_provider.dart';
import 'package:tito_app/screen/list_screen.dart';

class DebateWriter extends ConsumerStatefulWidget {
  final String? debateId;

  const DebateWriter({super.key, this.debateId});

  @override
  ConsumerState<DebateWriter> createState() => _DebateWriterState();
}

class _DebateWriterState extends ConsumerState<DebateWriter> {
  final _formKey = GlobalKey<FormState>();
  var myArguments = '';
  var opponentArguments = '';
  late Future<DebateInfo?> debateInfoFuture;

  @override
  void initState() {
    super.initState();
    debateInfoFuture = widget.debateId != null
        ? fetchDebateInfo(widget.debateId!)
        : Future.value(null);
  }

  Future<DebateInfo?> fetchDebateInfo(String debateId) async {
    final url = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
        'debate_list/$debateId.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return DebateInfo.fromMap(debateId, data);
      }
    } else {
      throw Exception('Failed to load debate info');
    }
    return null;
  }

  Future<void> _updateDebateState(String debateId) async {
    final url = Uri.https('pokeeserver-default-rtdb.firebaseio.com',
        'debate_list/$debateId.json');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {'debateState': '토론 중'},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update debate state');
    }
  }

  void _createDebateRoom(DebateInfo debateInfo) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    await _updateDebateState(debateInfo.id);

    ref.read(selectedIndexProvider.notifier).state = 1;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ListScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ListScreen()),
              (Route<dynamic> route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: FutureBuilder<DebateInfo?>(
        future: debateInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          } else {
            final debateInfo = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      debateInfo.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '나의 주장',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        debateInfo.myArgument,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '상대 주장',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        debateInfo.opponentArgument,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      (debateInfo.opponentId.isNotEmpty)
                          ? '토론 준비가 완료 되었어요!'
                          : '아직 반대 주장 참여자를 찾고 있어요!',
                      style: TextStyle(
                          color: (debateInfo.opponentId.isNotEmpty)
                              ? const Color(0xff8E48F8)
                              : Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (debateInfo.opponentId.isNotEmpty)
                            ? () => _createDebateRoom(debateInfo)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (debateInfo.opponentId.isNotEmpty)
                              ? const Color(0xff8E48F8)
                              : Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text(
                          '시작하기',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
