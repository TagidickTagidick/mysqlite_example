import 'create_employee.dart';
import 'custom_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sqflite Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map> employeeList = [];

  @override
  void initState() {
    getDatabase();
    super.initState();
  }

  void getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'employee.db');
    Database database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Employee (id INTEGER PRIMARY KEY, surname TEXT, name TEXT, patronymic TEXT, dateOfBirth TEXT, post TEXT, count INTEGER)');
    });
    List<Map> list = await database.rawQuery('SELECT * FROM Employee');
    setState(() => employeeList = list);
  }

  @override
  Scaffold build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ListView.builder(
                  itemCount: employeeList.length,
                  itemBuilder: (BuildContext context, int index) => CustomExpansionTile(
                      title: Text(employeeList[index].values.elementAt(1)),
                      children: [
                        ListTile(
                          title: Text("Фамилия:"),
                          trailing: Text(employeeList[index].values.elementAt(1)),
                        ),
                        ListTile(
                          title: Text("Имя:"),
                          trailing: Text(employeeList[index].values.elementAt(2)),
                        ),
                        ListTile(
                          title: Text("Отчество:"),
                          trailing: Text(employeeList[index].values.elementAt(3)),
                        ),
                        ListTile(
                          title: Text("Дата рождения:"),
                          trailing: Text(employeeList[index].values.elementAt(4)),
                        ),
                        ListTile(
                          title: Text("Должность:"),
                          trailing: Text(employeeList[index].values.elementAt(5)),
                        ),
                        ListTile(
                            title: Text("Количество детей:"),
                            trailing: Text(employeeList[index].values.elementAt(6).toString())
                        )
                      ]
                  )
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async => await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CreateEmployee(
                      employeeList: employeeList
                  )
              )
          ).then((value) => setState(() => employeeList = value))
      )
  );
}