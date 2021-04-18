import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp_sutt/AddNote.dart';
import 'package:notesapp_sutt/DatabaseServices.dart';
import 'package:notesapp_sutt/EditNote.dart';
import 'package:notesapp_sutt/authService.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  Databaseservices opendb = Databaseservices();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Future<Database> database;

  // database = openDatabase(
  //   join(await getDatabasesPath(), 'notes_database.db'),
  //   onCreate: (db, version) {
  //     return db.execute("CREATE TABLE notetable(title TEXT, content TEXT)");
  //   },
  //   version: 1,
  // );
  await runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notes App'),
    );
  }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    print('connected');
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await AuthService().signInWithGoogle().then((value) {
                      print(value);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextScreen(
                              auth.currentUser.displayName,
                              auth.currentUser.email),
                        ),
                      );
                    });
                  }
                } on SocketException catch (_) {
                  print('not connected');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OfflineScreen()));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign-In With Google',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextScreen extends StatefulWidget {
  final name;
  final email;
  NextScreen(this.name, this.email);
  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final ref = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                AuthService().signOutGoogle();
                Navigator.pop(context);
              },
              child: Text('Logout')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNote()));
        },
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditNote(
                                    docToEdit: snapshot.data.docs[index],
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 50,
                      color: Colors.grey,
                      child: Column(
                        children: [
                          Text(snapshot.data.docs[index].data()['title']),
                          Text(snapshot.data.docs[index].data()['note']),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}

class OfflineScreen extends StatelessWidget {
  Databaseservices db1 = Databaseservices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Database'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                await db1.notetable();
              },
              child: Text('show offline data')),
        ],
      ),
    );
  }
}
