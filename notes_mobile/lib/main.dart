// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

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

// TODO: Add new notes to a ListView dynamically
Widget myListView(BuildContext context, Map<String, String> notesMap) {

  return new ListView.builder(
    itemCount: notesMap.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text("${notesMap.keys.elementAt(index)}"),
        subtitle: Text("${notesMap[notesMap.keys.elementAt(index)]}"),
      );
    },
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
        body: myListView(context, notesMap),

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
    String noteTitle = "";
    String noteContent = "";




  // void disposeNotesTitle() {
  //   // Clean up the controller when the widget is disposed.
  //   notesTitleController.dispose();
  //   super.dispose();
  // }

  // void disposeNotesContent() {
  //   notesContentController.dispose();
  //   super.dispose();
  // }
    
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
                      // Figure out how to make the new note show up after clicking submit button
                  onPressed: () {
                    
                    Navigator.pop(context);
                    notesMap[notesTitleController.text] = notesContentController.text;
                    // setState() {

                    // }                    
                  },
                  
                  textColor: Colors.green),

                  // new Expanded(child: new ListView.builder(
                  //   itemCount: notesMap.length, 
                  //   itemBuilder: (BuildContext context, int index) {
                  //     _myListView(context, notesTitleController.text, notesContentController.text);
                  //   },
                  //   )),
            ],
          ),
          
        ),


    );
  }
}