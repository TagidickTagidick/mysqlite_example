import 'package:ekf/custom_button.dart';
import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CreateChild extends StatefulWidget {
  final List<Map> childList;

  CreateChild({required this.childList});

  @override
  _CreateChildState createState() => _CreateChildState();
}

class _CreateChildState extends State<CreateChild> {
  TextEditingController surname = TextEditingController(),
      name = TextEditingController(),
      patronymic = TextEditingController(),
      dateOfBirth = TextEditingController();

  List<Map> childList = [];

  bool canTap = false;

  void checkCanTap() {
    if (surname.text == ""
        || name.text == ""
        || patronymic.text == ""
        || dateOfBirth.text == ""
    )
      setState(() => canTap = false);
    else setState(() => canTap = true);
  }

  int count = 0;

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      Navigator.pop(context, childList);
      return true;
    },
    child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: BackButton(
              color: Colors.black
            )
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
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
                            },
                          ),
                          SizedBox(height: 10),
                          CustomButton(
                              canTap: canTap,
                              text: "Добавить",
                              onTap: () async {
                                var databasesPath = await getDatabasesPath();
                                String path = join(databasesPath, 'child.db');
                                Database database = await openDatabase(path, version: 1,
                                    onCreate: (Database db, int version) async {
                                      await db.execute(
                                          'CREATE TABLE Child (id INTEGER PRIMARY KEY, surname TEXT, name TEXT, patronymic TEXT, dateOfBirth TEXT)');
                                    });
                                await database.transaction((txn) async {
                                  int id1 = await txn.rawInsert(
                                      'INSERT INTO Child(surname, name, patronymic, dateOfBirth) VALUES(?, ?, ?, ?)', [surname.text, name.text, patronymic.text, dateOfBirth.text]);
                                  print('inserted1: $id1');
                                });
                                List<Map> list = await database.rawQuery('SELECT * FROM Child');
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