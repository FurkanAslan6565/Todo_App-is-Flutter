import 'package:flutter/material.dart';

import '../screen/categories_screen.dart';
import '../screen/home_screen.dart';
import '../screen/todos_category.dart';
import '../services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  //
  List<Widget> _categoryList = List<Widget>.empty(growable: true);

  CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TodosByCategory(
                    category: category['name'],
                  ))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://media.istockphoto.com/photos/check-boxes-on-white-paper-picture-id999144656?s=612x612'),
              ),
              accountName: Text('test'),
              accountEmail: Text('admin.admin'),
              decoration: BoxDecoration(color: Colors.amberAccent),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('Categories'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Column(
              children: _categoryList,
            ),
          ],
        ),
      ),
    );
  }
}
