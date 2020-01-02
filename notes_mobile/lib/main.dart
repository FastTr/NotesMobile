// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:notes_mobile/database.dart';
import 'package:notes_mobile/note.dart';
import 'package:intl/intl.dart';


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
      routes: {
        EditNotesPage.routeName: (context) => EditNotesPage(),
      }
    );
  }
}


Map<String, String> notesMap = new Map<String, String>();
Future<List<Note>> getList() async {
  return NoteDatabaseProvider.db.getAllNotes();

}


Widget myListView(BuildContext context) {

  return new FutureBuilder(
    future: getList(),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      if (!snapshot.hasData) {
        return new Container();
      }

      List<Note> notes = snapshot.data;
      return Flexible(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            padding: new EdgeInsets.all(5.0),
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("${notes.elementAt(index).noteTitle}"),
                        subtitle: Text("${notes.elementAt(index).noteContent}"),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            EditNotesPage.routeName,
                            arguments: EditNotesArguments(
                              notes.elementAt(index).id,
                              notes.elementAt(index).noteTitle,
                              notes.elementAt(index).noteContent,
                              notes.elementAt(index).timeNoteMade,
                              notes.elementAt(index).dateNoteMade,
                              notes.elementAt(index).dayNoteMade
                            ),
                          );
                        },
                        // trailing: new Text("${notes.elementAt(index).timeNoteMade}"),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, bottom: 5.0),
                            child: new Text("${notes.elementAt(index).dayNoteMade} ${notes.elementAt(index).dateNoteMade} ${notes.elementAt(index).timeNoteMade}"),
                          ),
                        ],
                      )
                    ],
                  ),
                  elevation: 3.0,
                );
            },
        ),
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
          actions: <Widget>[
            FlatButton(
              child: Text("DELETE ALL NOTES"),              
              textColor: Colors.black,
              onPressed: () {
                NoteDatabaseProvider.db.deleteAllNotes();
                setState(() {
                  
                });
              },
              shape: CircleBorder(
                side: BorderSide(
                  color: Colors.transparent,
                )
              )
            ),
          ],

        ),
        body: 
          new Container(
            child:
              new Column(
                children: 
                  <Widget>[
                    myListView(context),
                  ],
              )
            ),


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
                    await NoteDatabaseProvider.db.addNoteToDatabase(
                      new Note(
                        noteTitle: notesTitleController.text,
                        noteContent: notesContentController.text,
                        timeNoteMade: new TimeOfDay.now().format(context),
                        dateNoteMade: "${new DateFormat("MMM").format(new DateTime.now())} ${new DateTime.now().day}, ${new DateTime.now().year}",
                        dayNoteMade: "${new DateFormat("EEEE").format(new DateTime.now())}",
                      )
                    );

                    // Go back to home page  
                    Navigator.pop(context);

                    // Populate home page with updated notes
                    NoteDatabaseProvider.db.getAllNotes();
                
                  },
                  
                  textColor: Colors.green),
            ],
          ),
        ),
    );
  }
}


class EditNotesArguments {
  final int id;
  final String title;
  final String content;
  final String timeMade;
  final String dateNoteMade;
  final String dayNoteMade;

  EditNotesArguments(this. id, this.title, this.content, this.timeMade, this.dateNoteMade, this.dayNoteMade);
}

class EditNotesPage extends StatelessWidget {

  static const routeName = '/editNotes';

  @override
  Widget build(BuildContext context) {

    final EditNotesArguments args = ModalRoute.of(context).settings.arguments;
    final TextEditingController notesTitleController = new TextEditingController(text: args.title);
    final TextEditingController notesContentController = new TextEditingController(text: args.content);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
        actions: <Widget>[
          FlatButton(
            child: Text("DELETE NOTE"),              
            textColor: Colors.black,
            onPressed: () {
              NoteDatabaseProvider.db.deleteNoteWithId(args.id);
              Navigator.pop(context);
              NoteDatabaseProvider.db.getAllNotes();              
            },
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.transparent,
              )
            )
          ),
        ],
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
                  child: new Text("Update note",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () async {
                    // Add new note to notesMap
                    notesMap[notesTitleController.text] = notesContentController.text;
                    // Update the data in the database
                    await NoteDatabaseProvider.db.updateExistingNote(
                      new Note(id: args.id,
                        noteTitle: notesTitleController.text,
                        noteContent: notesContentController.text,
                        timeNoteMade: new TimeOfDay.now().format(context),
                        dateNoteMade: "${new DateFormat("MMM").format(new DateTime.now())} ${new DateTime.now().day}, ${new DateTime.now().year}",
                        dayNoteMade: "${new DateFormat("EEEE").format(new DateTime.now())}",
                      )
                    );
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