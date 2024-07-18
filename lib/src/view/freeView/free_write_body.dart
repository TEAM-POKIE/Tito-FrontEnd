import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tito_app/core/provider/freewrite_provider.dart';

class FreeWriteBody extends ConsumerStatefulWidget {
  @override
  _FreeWriteBodyState createState() => _FreeWriteBodyState();
}

class _FreeWriteBodyState extends ConsumerState<FreeWriteBody> {
  bool _isVotingEnabled = false;
  List<TextEditingController> _votingControllers = [];
  //객체들의 리스트 생성하는 것 -> 텍스트 필드를 한번에 관리하기 위해 사용

  @override
  void initState() {
    super.initState();
    _initializeVotingControllers();
  }

  void _initializeVotingControllers() {
    // 필요한 만큼 TextEditingController를 초기화
    _votingControllers = List.generate( 2,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    for (var controller in _votingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addVotingOption() {
    setState(() {
      _votingControllers.add(TextEditingController());
    });
  }

  void _removeVotingOption(int index) {
    setState(() {
      _votingControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleController = ref.watch(freewriteProvider);
    final contentController = ref.watch(freewriteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            '주제에 대한 내용과 투표 여부를 설정해보세요!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  const Text('제목',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: '입력하세요',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFFF6F6F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 30.0),
                  const Text('내용',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 230.0,
                    child: TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 250.0),
                        hintText: '입력하세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color(0xFFF6F6F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('투표',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      Transform.scale(
                        scale: 1,
                        child: Switch(
                          value: _isVotingEnabled,
                          //_isVotingEnaled가 true이면, 스위치가 켜진 상태
                          onChanged: (bool value) {
                            setState(() {
                              _isVotingEnabled = value;
                              if (!value) {
                                _votingControllers.clear();
                                //리스트를 비움으로써 컨트롤러 초기화하는 것
                              }
                            });
                          },
                          activeColor: const Color(0xFF8E48F8),
                          activeTrackColor:
                              const Color.fromARGB(255, 215, 192, 248),
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: const Color(0xFFF6F6F6),
                        ),
                      ),
                    ],
                  ),
                  if (_isVotingEnabled) ...[
                    for (int i = 0; i < _votingControllers.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _votingControllers[i],
                                decoration: InputDecoration(
                                  hintText: '입력하세요',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: const Color(0xFFF6F6F6),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.grey),
                              onPressed: () => _removeVotingOption(i),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: 380.0,
                      height: 55.0,
                      child: OutlinedButton(
                        onPressed: _addVotingOption,
                        child: Text(
                          '추가  +',
                          style: TextStyle(
                            color: Color.fromARGB(255, 109, 109, 109),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 370,
          height: 60,
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8E48F8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                '게시글 작성하기',
                style: TextStyle(fontSize: 18),
              )),
        ),
        const SizedBox(height: 23),
      ],
    );
  }
}
