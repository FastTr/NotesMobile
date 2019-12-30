// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:notes_mobile/database.dart';
import 'package:notes_mobile/note.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notes'),
    );
  }
}

buttonPressed() {
  print("BUTTON CLICKED");
}

Map<String, String> notesMap = new Map<String, String>();
Future<List<Note>> getList() async {
  return NoteDatabaseProvider.db.getAllNotes();

}


// TODO: Add new notes to a ListView dynamically
Widget myListView(BuildContext context) {
  return new FutureBuilder(
    future: getList(),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      if (!snapshot.hasData) {
        return new Container();
      }
      print("Snapshot is the issue");
      print("STUFF" + snapshot.data[1].toString());
      List<Note> notes = snapshot.data;
      print(notes.length);
      return new ListView.builder(
        scrollDirection: Axis.vertical,
        padding: new EdgeInsets.all(5.0),
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("${notes.elementAt(index).noteTitle}"),
            subtitle: Text("${notes.elementAt(index).noteContent}"),
          );
        },
      );
    }
  );

}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    ListView drawerListView = new ListView(
      children: <Widget>[
        new OutlineButton(
            padding: new EdgeInsets.all(15.0),
            child: new Text("Spreadsheet",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              null;
            },
            textColor: Colors.green),

        new OutlineButton(
            padding: new EdgeInsets.all(15.0),
            child: new Text("Calendar",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              null;
            },
            textColor: Colors.green),

        new OutlineButton(
            padding: new EdgeInsets.all(15.0),
            child: new Text("Calculator",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              null;
            },
            textColor: Colors.green)            

      ],
    );

    Drawer drawer = new Drawer(child: drawerListView);

    return Scaffold(
        drawer: drawer,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: myListView(context),

        floatingActionButton: new FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewNotePage()),
            );
          },
          tooltip: "Make a new note",
          child: new Icon(Icons.add),
        )

        );
  }
}


class NewNotePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final TextEditingController notesTitleController = new TextEditingController();
    final TextEditingController notesContentController = new TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        title: Text("New Note"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: new Column(
            children: <Widget>[
              TextField(
                  controller: notesTitleController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Enter note title here",
                    border: OutlineInputBorder(),
                  )),
              Container(height: 20),
              TextField(
                controller: notesContentController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Enter note here",
                  border: OutlineInputBorder(),
                ),
              ),
              Container(height: 15),
              new OutlineButton(
                  padding: new EdgeInsets.all(15.0),
                  child: new Text("Finish note",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () async {
                    // Add new note to notesMap
                    notesMap[notesTitleController.text] = notesContentController.text;
                    // Save the new data into datbase
                    await NoteDatabaseProvider.db.addNoteToDatabase(new Note(
                      noteTitle: notesTitleController.text,
                      noteContent: notesContentController.text));
                    Navigator.pop(context);
                    NoteDatabaseProvider.db.getAllNotes();
                
                  },
                  
                  textColor: Colors.green),
            ],
          ),
          
        ),


    );
  }
}