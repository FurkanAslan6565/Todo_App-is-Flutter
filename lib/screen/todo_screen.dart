import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/category_service.dart';
import '../services/todo_service.dart';



class TodoScreen extends StatefulWidget {
const TodoScreen({Key? key}) : super(key: key);

@override
State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  //Tarih
  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  //Tarih
  //dropdown

  var _selectedValue;
  List<DropdownMenuItem> _categories =
  List<DropdownMenuItem>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  //dropdown
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write Todo Title',
              ),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Write Todo Description',
              ),
            ),
            //Tarih
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Pick a Date',
                  prefixIcon: InkWell(
                    onTap: () {
                      _selectedTodoDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  )),
            ),
            //Tarih
            //dropdown
            DropdownButtonFormField<dynamic>(
              value: _selectedValue,
              items: _categories,
              hint: Text('Category'),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            //dropdown
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                var todoObject = Todo();

                todoObject.title = _todoTitleController.text;
                todoObject.description = _todoDescriptionController.text;
                todoObject.category = _selectedValue.toString();
                todoObject.todoDate = _todoDateController.text;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                print(result);
              },
              color: Colors.amber,
              child: Text('Save', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
