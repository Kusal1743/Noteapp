import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'StaggeredView.dart';
import '../Models/Note.dart';
import 'NotePage.dart';
import '../Models/Utility.dart';

enum viewType {
  List,
  Staggered
}

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Provide key parameter

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notesViewType;

  @override
  void initState() {
    super.initState(); // Call super.initState()
    notesViewType = viewType.Staggered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: _appBarActions(),
        elevation: 1,
        backgroundColor: const Color.fromARGB(255, 85, 185, 235),
        centerTitle: true,
        title: const Text("Notes"),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        right: true,
        left: true,
        top: true,
        bottom: true,
        child: _body(),
      ),
      bottomSheet: _bottomBar(),
    );
  }

  Widget _body() {
    print(notesViewType);
    return Container(child: StaggeredGridPage(notesViewType: notesViewType, key: UniqueKey()));
  }

  Widget _bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton( // Use TextButton instead of FlatButton
          child: const Text(
            "New Note\n",
            style: TextStyle(color: Color.fromARGB(255, 43, 59, 204), fontWeight: FontWeight.bold),
          ),
          onPressed: () => _newNoteTapped(context),
        ),
      ],
    );
  }

  void _newNoteTapped(BuildContext ctx) {
    // "-1" id indicates the note is not new
    var emptyNote = Note(-1, "", "", DateTime.now(), DateTime.now(), Colors.white);
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => NotePage(emptyNote)));
  }

  void _toggleViewType() {
    setState(() {
      CentralStation.updateNeeded = true;
      if (notesViewType == viewType.List) {
        notesViewType = viewType.Staggered;
      } else {
        notesViewType = viewType.List;
      }
    });
  }

  List<Widget> _appBarActions() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _toggleViewType(),
            child: Icon(
              notesViewType == viewType.List ? Icons.developer_board : Icons.view_headline,
              color: CentralStation.fontColor,
            ),
          ),
        ),
      ),
    ];
  }
}