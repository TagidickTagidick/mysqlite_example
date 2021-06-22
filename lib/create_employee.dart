import 'package:ekf/custom_button.dart';
import 'package:flutter/material.dart';
import 'custom_expansion_tile.dart';
import 'custom_text_field.dart';
import 'create_child.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CreateEmployee extends StatefulWidget {
  final List<Map> employeeList;

  CreateEmployee({required this.employeeList});

  @override
  _CreateEmployeeState createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  TextEditingController surname = TextEditingController(),
      name = TextEditingController(),
      patronymic = TextEditingController(),
      dateOfBirth = TextEditingController(),
      post = TextEditingController();

  List<Map> childList = [];

  List<Map> employeeList = [];

  bool canTap = false;

  void checkCanTap() {
    if (surname.text == ""
        || name.text == ""
        || patronymic.text == ""
        || dateOfBirth.text == ""
        || post.text == ""
    )
      setState(() => canTap = false);
    else setState(() => canTap = true);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.employeeList);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: BackButton(
                color: Colors.black,
              )
          ),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: 10),
                            CustomTextField(
                              text: "Фамилия",
                              controller: surname,
                              onChanged: (value) => checkCanTap(),
                              hintText: "Введите фамилию",
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                                text: "Имя",
                                controller: name,
                                onChanged: (value) => checkCanTap(),
                                hintText: "Введите имя"
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                                text: "Отчество",
                                controller: patronymic,
                                onChanged: (value) => checkCanTap(),
                                hintText: "Введите отчество"
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                                text: "Дата рождения",
                                controller: dateOfBirth,
                                onChanged: (value) => checkCanTap(),
                                hintText: "Введите дату рождения",
                              getDate: true,
                              onDateTimeChanged: (DateTime value) {
                                setState(() => dateOfBirth.text = "${value.day}.${value.month}.${value.year}");
                                checkCanTap();
                              }
                            ),
                            SizedBox(height: 10),
                            CustomTextField(
                                text: "Должность",
                                controller: post,
                                onChanged: (value) => checkCanTap(),
                                hintText: "Введите должность"
                            ),
                            for (Map child in childList)
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: CustomExpansionTile(
                                      title: Text(child.values.elementAt(1)),
                                      children: [
                                        ListTile(
                                          title: Text("Фамилия:"),
                                          trailing: Text(child.values.elementAt(1)),
                                        ),
                                        ListTile(
                                          title: Text("Имя:"),
                                          trailing: Text(child.values.elementAt(2)),
                                        ),
                                        ListTile(
                                          title: Text("Отчество:"),
                                          trailing: Text(child.values.elementAt(4)),
                                        ),
                                        ListTile(
                                          title: Text("Дата рождения:"),
                                          trailing: Text(child.values.elementAt(3)),
                                        )
                                      ]
                                  )
                              ),
                            SizedBox(height: 10),
                            CustomButton(
                                text: "Добавить ребенка",
                                onTap: () async => await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => CreateChild(
                                          childList: childList
                                        )
                                    )
                                ).then((value) => setState(() => childList = value))
                            ),
                            SizedBox(height: 10),
                            CustomButton(
                                canTap: canTap,
                                text: "Подтвердить",
                                onTap: () async {
                                  var databasesPath = await getDatabasesPath();
                                  String path = join(databasesPath, 'employee.db');
                                  Database database = await openDatabase(path, version: 1,
                                      onCreate: (Database db, int version) async {
                                        await db.execute(
                                            'CREATE TABLE Employee (id INTEGER PRIMARY KEY, surname TEXT, name TEXT, patronymic TEXT, dateOfBirth TEXT, post TEXT, count INTEGER)');
                                      });
                                  await database.transaction((txn) async {
                                    await txn.rawInsert(
                                        'INSERT INTO Employee(surname, name, patronymic, dateOfBirth, post, count) VALUES(?, ?, ?, ?, ?, ?)', [surname.text, name.text, patronymic.text, dateOfBirth.text, post.text, childList.length]);
                                  });
                                  List<Map> list = await database.rawQuery('SELECT * FROM Employee');
                                  await database.close();
                                  var childDatabasesPath = await getDatabasesPath();
                                  String childPath = join(childDatabasesPath, 'child.db');
                                  await deleteDatabase(childPath);
                                  setState(() => childList = []);
                                  Navigator.pop(context, list);
                                }
                            ),
                            SizedBox(height: 10)
                          ]
                      )
                  )
              )
          )
      )
  );
}