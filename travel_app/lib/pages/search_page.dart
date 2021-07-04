import 'package:flutter/material.dart';
import 'package:travel_app/widgets/search_bar.dart';
import 'package:travel_app/cloud.dart' as global;
import 'package:travel_app/widgets/vertical_place_item.dart';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.keyword, this.hint})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String keyword;
  List places;

  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.keyword != null) {
      _onTextChange(widget.keyword);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _appBar(),
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                flex: 1,
                child: buildVerticalList(),
              ))
        ],
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
        itemCount: places == null ? 0 : places.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = places[index];
          return VerticalPlaceItem(place: place);
        },
      ),
    );
  }

  _appBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  _onTextChange(text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        keyword = null;
      });
      return;
    }
    global.db
        .collection('classic')
        .where({
          'name': global.db.regExp('.*' + keyword + '.*', 'i'),
        })
        .get()
        .then((res) {
          places = res.data;
          setState(() {
            places = places;
            print('last');
            print(places);
          });
          if (places.isEmpty) {
            print('new');
            global.db
                .collection('new')
                .where({
                  'name': global.db.regExp('.*' + keyword + '.*', 'i'),
                })
                .get()
                .then((res) {
                  setState(() {
                    places = res.data;
                  });
                });
          }
        });
  }
}
