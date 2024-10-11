import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/src/data/models/search_data.dart';
import 'package:tito_app/src/widgets/reuse/search_bar.dart';
import 'package:go_router/go_router.dart';

class Searchpage extends ConsumerStatefulWidget {
  const Searchpage({super.key});

  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends ConsumerState<Searchpage> {
  List<SearchData> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      body: SafeArea(
        // SafeArea 추가
        child: Column(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(80.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomSearchBar(
                        onSearchResults: (results) {
                          setState(() {
                            searchResults = results;
                          });
                        },
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            '취소',
                            style: FontSystem.KR16M,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SearchResultList(searchResults: searchResults),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
