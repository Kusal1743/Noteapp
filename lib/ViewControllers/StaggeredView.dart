import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Models/Note.dart';
import '../Models/SqliteHandler.dart';
import '../Models/Utility.dart';
import '../views/StaggeredTiles.dart';
import 'HomePage.dart';

class StaggeredGridPage extends StatefulWidget {
  final notesViewType;
  const StaggeredGridPage({required Key key, this.notesViewType})
      : super(key: key);
  @override
  _StaggeredGridPageState createState() => _StaggeredGridPageState();
}

class _StaggeredGridPageState extends State<StaggeredGridPage> {
  var noteDB = NotesDBHandler();
  List<Map<String, dynamic>> _allNotesInQueryResult = [];
  late viewType notesViewType;
  
  get StaggeredTile => null;

  @override
  void initState() {
    super.initState();
    notesViewType = widget.notesViewType;
  }

  @override
  void setState(fn) {
    super.setState(fn);
    notesViewType = widget.notesViewType;
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey stagKey = GlobalKey();

    print("update needed?: ${CentralStation.updateNeeded}");
    if (CentralStation.updateNeeded) {
      retrieveAllNotesFromDatabase();
    }
    return Container(
        child: Padding(
      padding: _paddingForView(context),
      child: StaggeredGrid.count(
        key: stagKey,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: _colForStaggeredView(context),
        
        children: List.generate(_allNotesInQueryResult.length, (i) {
          return _tileGenerator(i);
        }),
      ),
    ));
  }

  int _colForStaggeredView(BuildContext context) {
    if (widget.notesViewType == viewType.List) {
      return 1;
    }
    // for width larger than 600 on grid mode, return 3 irrelevant of the orientation to accommodate more notes horizontally
    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }

  Future<List<dynamic>> _tilesForView() async {
    // Generate staggered tiles for the view based on the current preference.
    return List.generate(_allNotesInQueryResult.length, (index) {
      return StaggeredTile.fit(1);
    });
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    double topBottom = 8;
    if (width > 500) {
      padding = (width) * 0.05; // 5% padding of width on both side
    } else {
      padding = 8;
    }
    return EdgeInsets.only(
        left: padding, right: padding, top: topBottom, bottom: topBottom);
  }

  MyStaggeredTile _tileGenerator(int i) {
    return MyStaggeredTile(Note(
        _allNotesInQueryResult[i]["id"],
        _allNotesInQueryResult[i]["title"] == null
            ? ""
            : utf8.decode(_allNotesInQueryResult[i]["title"]),
        _allNotesInQueryResult[i]["content"] == null
            ? ""
            : utf8.decode(_allNotesInQueryResult[i]["content"]),
        DateTime.fromMillisecondsSinceEpoch(
            _allNotesInQueryResult[i]["date_created"] * 1000),
        DateTime.fromMillisecondsSinceEpoch(
            _allNotesInQueryResult[i]["date_last_edited"] * 1000),
        Color(_allNotesInQueryResult[i]["note_color"])));
  }

  void retrieveAllNotesFromDatabase() {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.
    var testData = noteDB.selectAllNotes();
    testData.then((value) {
      setState(() {
        _allNotesInQueryResult = value;
        CentralStation.updateNeeded = false;
      });
    });
  }
}
