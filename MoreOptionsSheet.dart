import 'package:flutter/material.dart';

import 'ColorSlider.dart';
import '../Models/Utility.dart';

enum moreOptions { delete, share, copy }

class MoreOptionsSheet extends StatefulWidget {
  final Color color;
  final DateTime date_last_edited;
  final void Function(Color) callBackColorTapped;

  final void Function(moreOptions) callBackOptionTapped;

  const MoreOptionsSheet(
      {required Key key,
      required this.color,
      required this.date_last_edited,
      required this.callBackColorTapped,
      required this.callBackOptionTapped})
      : super(key: key);

  @override
  _MoreOptionsSheetState createState() => _MoreOptionsSheetState();
}

class _MoreOptionsSheetState extends State<MoreOptionsSheet> {
  var note_color;

  @override
  void initState() {
    super.initState();
    note_color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: note_color,
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete permanently'),
              onTap: () {
                Navigator.of(context).pop();
                widget.callBackOptionTapped(moreOptions.delete);
              }),
          ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Duplicate'),
              onTap: () {
                Navigator.of(context).pop();
                widget.callBackOptionTapped(moreOptions.copy);
              }),
          ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.of(context).pop();
                widget.callBackOptionTapped(moreOptions.share);
              }),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 44,
              width: MediaQuery.of(context).size.width,
              child: ColorSlider(
                callBackColorTapped: _changeColor,
                // call callBack from notePage here
                noteColor: note_color, // take color from local variable
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 44,
                child: Center(
                    child: Text(CentralStation.stringForDatetime(
                        widget.date_last_edited))),
              )
            ],
          ),
          const ListTile()
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    setState(() {
      note_color = color;
      widget.callBackColorTapped(color);
    });
  }
}
