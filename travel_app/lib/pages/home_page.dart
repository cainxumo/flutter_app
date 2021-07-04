import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:travel_app/pages/essay.dart';
import 'package:travel_app/pages/search_page.dart';
import 'package:travel_app/pages/speak_page.dart';
import 'package:travel_app/util/navigator.dart';
import 'package:travel_app/widgets/horizontal_place_item.dart';
import 'package:travel_app/widgets/search_bar.dart';
import 'dart:ui';
import 'package:travel_app/widgets/vertical_place_item.dart';
import 'package:travel_app/cloud.dart' as global;

const APPBAR_SCROLL_OFFSET = 100;
const String SEARCH_BAR_DEFAULT_TEXT = "寻找你喜欢的国漫吧！";

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://img2.baidu.com/it/u=747988703,3378831195&fm=26&fmt=auto&gp=0.jpg',
    'https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20191231%2F4276efc011b24918b2529514d9191a7e.jpeg&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1627923735&t=1ac1bc0491a8f626b78b8862f386054f',
    'https://img1.baidu.com/it/u=1713279521,388457276&fm=26&fmt=auto&gp=0.jpg',
    'https://img1.baidu.com/it/u=2898860180,191573441&fm=26&fmt=auto&gp=0.jpg',
    'https://img0.baidu.com/it/u=3082168121,929318608&fm=26&fmt=auto&gp=0.jpg',
    'https://img0.baidu.com/it/u=2501870911,3716188416&fm=26&fmt=auto&gp=0.jpg'
  ];
  List _cardUrls = [
    'https://img0.baidu.com/it/u=3435919782,3866455198&fm=26&fmt=auto&gp=0.jpg',
    'https://img1.baidu.com/it/u=3748277135,4009802193&fm=26&fmt=auto&gp=0.jpg',
    'https://img1.baidu.com/it/u=2309205526,2767273342&fm=26&fmt=auto&gp=0.jpg',
    'https://img2.baidu.com/it/u=3421416831,419540708&fm=26&fmt=auto&gp=0.jpg',
    'https://img0.baidu.com/it/u=3826879036,3627660609&fm=26&fmt=auto&gp=0.jpg',
    'https://img0.baidu.com/it/u=1467031506,380885004&fm=26&fmt=auto&gp=0.jpg'
  ];
  List news;
  List classics;
  double appBarAlpha = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    global.db.collection('new').orderBy("year", "asc").get().then((res) {
      news = res.data;
      setState(() {
        news = news;
      });
    });
    global.db.collection('classic').orderBy("year", "desc").get().then((res) {
      classics = res.data;
      setState(() {
        classics = classics;
      });
    });
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
              },
              child: _listView,
            )),
        _appbar,
      ],
    ));
  }

  Widget get _appbar {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0x66000000), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Container(
            padding: EdgeInsets.fromLTRB(
                0, MediaQueryData.fromWindow(window).padding.top, 0, 0),
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.3
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: appBarAlpha > 0.3 ? 0.5 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        ),
      ],
    );
    // return Opacity(
    //   opacity: appBarAlpha,
    //   child: Container(
    //     height: 80,
    //     decoration: BoxDecoration(color: Colors.white),
    //     child: Center(
    //       child: Padding(padding: EdgeInsets.only(top:20),
    //         child: Text('hello'),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget get _bannerView {
    return Container(
      height: 300,
      child: Swiper(
        itemCount: _imageUrls.length,
        autoplay: true,
        viewportFraction: 0.8,
        scale: 0.9,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            _imageUrls[index],
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  Widget get _SwiperCardView {
    return Container(
      height: 450,
      child: Swiper(
        itemCount: _cardUrls.length,
        autoplay: true,
        viewportFraction: 0.8,
        scale: 0.9,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            _cardUrls[index],
            fit: BoxFit.fill,
          );
        },
        itemWidth: 290.0,
        layout: SwiperLayout.STACK,
      ),
    );
  }

  Widget get _cardView {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        AspectRatio(
          aspectRatio: 30 / 12, //控制子元素的宽高比
          child: Image.network(
            'https://img0.baidu.com/it/u=1258999898,2928263551&fm=26&fmt=auto&gp=0.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Divider(),
        InkWell(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("《大鱼海棠》为何与优秀失之交臂"),
            ),
            onTap: null)
      ]),
    );
  }

  Widget get _card2View {
    String name = '国漫崛起，路有多远？(圆桌谈)';
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        AspectRatio(
          aspectRatio: 30 / 12, //控制子元素的宽高比
          child: Image.network(
            'https://img2.baidu.com/it/u=1313495062,2253445621&fm=26&fmt=auto&gp=0.jpg',
            fit: BoxFit.cover,
          ),
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(name),
          ),
          //onTap: NavigatorUtil.push(context, Essay(name: name)),
        )
      ]),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _bannerView,
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "经典回忆",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        buildHorizontalList(context),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "优秀电影",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _SwiperCardView,
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "精彩影评",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _cardView,
        _card2View,
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "国漫新潮",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        buildVerticalList(),
      ],
    );
  }

  buildHorizontalList(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 20.0),
      height: 250.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: classics == null ? 0 : classics.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = classics.reversed.toList()[index];
          return HorizontalPlaceItem(place: place);
        },
      ),
    );
  }

  buildVerticalList() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: news == null ? 0 : news.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = news[index];
          return VerticalPlaceItem(place: place);
        },
      ),
    );
  }

  _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage());
  }
}
