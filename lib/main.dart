import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliver_list_example/list_item.dart';
import 'package:sliver_list_example/shimmer_effect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final ScrollController _scrollController = ScrollController();

  late int _seed;
  int _itemCount = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //Sets random seed value for the image list
    _seed = Random().nextInt(100);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        setState(() {});
        if (_scrollController.position.extentAfter < 250 && !_isLoading) {
          _loadData();
        }
      });
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _loadData() async {
    if (_isLoading == false) {
      _isLoading = true;
      debugPrint("Loading data...");
      setState(() {
        _itemCount += 3;
        debugPrint("Item count: $_itemCount");
        _isLoading = false;
        debugPrint("Load complete!");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Shimmer(
          linearGradient: shimmerGradient,
          child: CustomScrollView(controller: _scrollController, slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              title: Text("Sliver List Example"),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                //Sets new random seed value for the image list
                await Future<void>.delayed(
                    const Duration(
                      milliseconds: 300,
                    ), () {
                  setState(() {
                    _seed = Random().nextInt(100);
                  });
                });
              },
            ),
            SliverList.builder(
                itemCount: _itemCount,
                itemBuilder: (context, index) {
                  return ListItem(
                      imageUrl:
                          "https://picsum.photos/seed/${_seed + index}/1000/1000");
                }),
          ]),
        ),
      ),
    );
  }
}

Color randomColor() {
  return Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF));
}
