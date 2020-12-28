import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/Task.dart';
import 'package:to_do_app/DatabaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> allTasks = List<Task>();
  List<Task> completedTasks;
  List<Task> notCompletedTasks;

  initState() {
    super.initState();
    getAllTasks2();
    getCompletedTasks2();
    getNotCompletedTasks2();
  }

  getAllTasks2() async {
    allTasks = List<Task>();
    final Database db = await DatabaseHelper.instance.database;
    var tasks = await db.query(DatabaseHelper.table);
    tasks.forEach((element) {
      setState(() {
        var task = new Task();
        task.id = element["_id"];
        task.title = element["title"];
        task.status = element["status"];
        allTasks.add(task);
      });
    });
  }

  getCompletedTasks2() async {
    completedTasks = List<Task>();
    final Database db = await DatabaseHelper.instance.database;
    var tasks = await db.query(DatabaseHelper.table,
        where: "status = ?", whereArgs: [DatabaseHelper.completedFlag]);
    tasks.forEach((element) {
      setState(() {
        var task = new Task();
        task.id = element["_id"];
        task.title = element["title"];
        task.status = element["status"];
        completedTasks.add(task);
      });
    });
  }

  getNotCompletedTasks2() async {
    notCompletedTasks = List<Task>();
    final Database db = await DatabaseHelper.instance.database;
    var tasks = await db.query(DatabaseHelper.table,
        where: "status = ?", whereArgs: [DatabaseHelper.notCompletedFlag]);
    tasks.forEach((element) {
      setState(() {
        var task = new Task();
        task.id = element["_id"];
        task.title = element["title"];
        task.status = element["status"];
        notCompletedTasks.add(task);
      });
    });
  }

  /*
  *  ,*/
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "All Tasks",
                ),
                Tab(
                  text: "Complete Tasks",
                ),
                Tab(
                  text: "InComplete Tasks",
                ),
              ],
            ),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: TabBarView(
              children: [
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: allTasks.length,
                    itemBuilder: (BuildContext context, int position) {
                      return CheckboxListTile(
                        title: new Text(allTasks[position].title),
                        value: allTasks[position].status ==
                            DatabaseHelper.completedFlag,
                        onChanged: (bool value) {
                          setState(() {
                            if (value) {
                              allTasks[position].status =
                                  DatabaseHelper.completedFlag;
                            } else {
                              allTasks[position].status =
                                  DatabaseHelper.notCompletedFlag;
                            }
                            _updateI(
                                allTasks[position].id,
                                allTasks[position].title,
                                allTasks[position].status);
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: completedTasks.length,
                    itemBuilder: (BuildContext context, int position) {
                      return CheckboxListTile(
                        title: new Text(completedTasks[position].title),
                        value: completedTasks[position].status ==
                            DatabaseHelper.completedFlag,
                        onChanged: (bool value) {
                          setState(() {
                            if (value) {
                              completedTasks[position].status =
                                  DatabaseHelper.completedFlag;
                            } else {
                              completedTasks[position].status =
                                  DatabaseHelper.notCompletedFlag;
                            }
                            _updateI(
                                completedTasks[position].id,
                                completedTasks[position].title,
                                completedTasks[position].status);
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: notCompletedTasks.length,
                    itemBuilder: (BuildContext context, int position) {
                      return CheckboxListTile(
                        title: new Text(notCompletedTasks[position].title),
                        value: notCompletedTasks[position].status ==
                            DatabaseHelper.completedFlag,
                        onChanged: (bool value) {
                          setState(() {
                            if (value) {
                              notCompletedTasks[position].status =
                                  DatabaseHelper.completedFlag;
                            } else {
                              notCompletedTasks[position].status =
                                  DatabaseHelper.notCompletedFlag;
                            }
                            _updateI(
                                notCompletedTasks[position].id,
                                notCompletedTasks[position].title,
                                notCompletedTasks[position].status);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _displayDialog(context);
              // _delete();
            },
            tooltip: 'Add Task To Table',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  ////////////////////////////////////////////////
  _insertI(String title) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DatabaseHelper.instance.database;

    Task task = new Task(title: title, status: DatabaseHelper.notCompletedFlag);
    print('task ${task.toMap()}');

    // do the insert and get the id of the inserted row
    int id = await db.insert(DatabaseHelper.table, task.toMap() /*row*/);
    print('Success Insert Task with id $id');

    // show the results: print all rows in the db
    print(await db.query(DatabaseHelper.table));
  }

  _insertHY(String title) async {
    Database db = await DatabaseHelper.instance.database;
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnStatus: DatabaseHelper.notCompletedFlag
    };
    await db.insert(DatabaseHelper.table, row);
  }

  ////////////////////////////////////////////////

  _updateI(int taskId, String title, int newStatus) async {
    // get a reference to the database
    // because this is an expensive operation we use async and await
    Database db = await DatabaseHelper.instance.database;

    // row to insert
    Task task = new Task(title: title, status: newStatus);
    int id = await db.update(DatabaseHelper.table, task.toMap(),
        where: "_id = ?", whereArgs: [taskId]);

    // print(await db.query(DatabaseHelper.table));
    print('Success Update Task with id $id');
  }

  _updateH(Task task, int newStatus) async {
    Database db = await DatabaseHelper.instance.database;

    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: task.title,
      DatabaseHelper.columnId: task.id,
      DatabaseHelper.columnStatus: newStatus
    };

    await db.update(DatabaseHelper.table, row,
        where: "_id = ?", whereArgs: [task.id]);
  }

  _updateY(Task updatedTask) async {
    Database db = await DatabaseHelper.instance.database;

    await db.update(DatabaseHelper.table, updatedTask.toMap(),
        where: "_id = ?", whereArgs: [updatedTask.id] /*row*/);
  }

  ////////////////////////////////////////////////
  //Not Important
  Future<List<Task>> getAllTasks() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper.instance.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(DatabaseHelper.table);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    var list = List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['_id'],
        title: maps[i]['title'],
        status: maps[i]['status'],
      );
    });
    print('--------------------------------------');
    print('TAG getAllTasks ${await list}');
    print('--------------------------------------');
    return list;
  }

  Future<List<Task>> getCompletedTasks() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper.instance.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.table,
        where: "status = ?", whereArgs: [DatabaseHelper.completedFlag]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    var list = List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['_id'],
        title: maps[i]['title'],
        status: maps[i]['status'],
      );
    });
    print('--------------------------------------');
    print('TAG getCompletedTasks ${await list}');
    print('--------------------------------------');
    setState(() {
      completedTasks = list;
    });
    return list;
  }

  Future<List<Task>> getNotCompletedTasks() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper.instance.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.table,
        where: "status = ?", whereArgs: [DatabaseHelper.notCompletedFlag]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    var list = List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['_id'],
        title: maps[i]['title'],
        status: maps[i]['status'],
      );
    });
    print('--------------------------------------');
    print('TAG getNotCompletedTasks ${await list}');
    print('--------------------------------------');
    setState(() {
      notCompletedTasks = list;
    });
    return list;
  }

  _delete() async {
    Database db = await DatabaseHelper.instance.database;
    await db.delete(DatabaseHelper.table);
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Write Task Name'),
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(hintText: "Write Task Name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  var enteredText = _textFieldController.text;
                  print('Entered Text is $enteredText');
                  if (enteredText.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Can't create empty task",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    _insertI(_textFieldController.text);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
