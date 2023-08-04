import 'dart:math' as math;
import 'dart:developer';

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
  late final ScrollController _scrollController = ScrollController();

  late int _seed = math.Random().nextInt(100);
  int _itemCount = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    log(name: "initState", "New seed : $_seed");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {

        if (_scrollController.position.extentAfter < 350 && !_isLoading) {
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

  _loadData() {
    if (_isLoading == false) {
      _isLoading = true;
      setState(() {
        _itemCount += 10;
        _isLoading = false;
        log(name: "onLoadData", "New item count: $_itemCount");
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
                    _itemCount = 10;
                    _seed = math.Random().nextInt(100);
                    log(name: "onRefresh", "New seed : $_seed");
                  });
                });
              },
            ),
            SliverList.builder(
                itemCount: _itemCount,
                itemBuilder: (context, index) {
                  log(name: "OnLoadData", "Building item: $index/$_itemCount");
                  return ListItem(
                      imageUrl:
                          "https://picsum.photos/seed/${_seed + index}/500/600");
                }),
          ]),
        ),
      ),
    );
  }
}

Color randomColor() {
  return Color(0xFFFFFFFF & math.Random().nextInt(0xFFFFFFFF));
}
