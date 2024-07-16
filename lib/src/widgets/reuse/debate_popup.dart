import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/core/provider/popup_provider.dart';
import 'package:go_router/go_router.dart';

class DebatePopup extends ConsumerWidget {
  const DebatePopup({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupState = ref.watch(popupProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 35,
                ),
                popupState.buttonStyle == 2
                    ? Row(
                        children: [
                          Image.asset(
                            popupState.imgSrc ?? '',
                            width: 30,
                          ),
                          Text(
                            popupState.titleLabel ?? '',
                            style: FontSystem.KR14M
                                .copyWith(color: ColorSystem.black),
                          ),
                        ],
                      )
                    : Image.asset(
                        popupState.imgSrc ?? '',
                        width: 50,
                      ),
                IconButton(
                  iconSize: 25,
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              popupState.title ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: ColorSystem.ligthGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                popupState.content ?? '',
                textAlign: TextAlign.center,
                style: FontSystem.KR14R,
              ),
            ),
            const SizedBox(height: 25),
            if (popupState.buttonStyle == 2)
              _twoButtons(context, ref)
            else if (popupState.buttonStyle == 1)
              _oneButton(context, ref),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _oneButton(BuildContext context, WidgetRef ref) {
    final popupState = ref.watch(popupProvider);
    final popupViewModel = ref.watch(popupProvider.notifier);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 45),
        backgroundColor: ColorSystem.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      onPressed: () {
        popupState.buttonStyle = 0;
        popupState.title = '토론이 시작 됐어요! 🎵';
        popupState.content = '서로 존중하는 토론을 부탁드려요!';
        context.pop();
        popupViewModel.showDebatePopup(context);
      },
      child: Text(
        '토론 참여하기',
        style: FontSystem.KR14M.copyWith(color: ColorSystem.white),
      ),
    );
  }

  Widget _twoButtons(BuildContext context, WidgetRef ref) {
    final popupState = ref.watch(popupProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () {},
            child: Text(
              popupState.buttonContentLeft ?? '',
              style: FontSystem.KR12B.copyWith(color: ColorSystem.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorSystem.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onPressed: () {},
            child: Text(
              popupState.buttonContentRight ?? '',
              style: FontSystem.KR12B.copyWith(color: ColorSystem.white),
            ),
          ),
        ),
      ],
    );
  }
}
