import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class CategoryCard extends StatefulWidget {
  final Category category;

  const CategoryCard({Key key, @required this.category}) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  GlobalKey _menuButtonKey = GlobalKey();

  Category get _category => widget.category;

  void _openCategoryForm() {
    final _categoryForm = CategoryForm(category: _category);

    showDialog(
        context: context,
        builder: (context) {
          return _categoryForm;
        });
  }

  void _showSnackbar(
      {@required Icon icon, @required String title, @required String message}) {
    Flushbar(
      icon: icon,
      title: title,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void _openDeleteConfirmationDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CategoryDeleteDialog(category: _category);
        }).then((_) {
      if (_ != null && _) {
        final _icon = Icon(Icons.verified_user, color: Colors.green);
        final _deleteMessage = 'Category deleted successfully';
        _showSnackbar(icon: _icon, title: 'Success', message: _deleteMessage);
      }
    });
  }

  void _onClickMenu(MenuItemProvider item) {
    item.menuTitle == 'Update'
        ? _openCategoryForm()
        : _openDeleteConfirmationDialog();
  }

  void _onStateChanged(bool isShow) {
    print('Menu is ${isShow ? 'Open' : 'Closed'}');
  }

  void _onDismiss() {
    print('Menu is closed');
  }

  void _openCustomMenuOptions() {
    PopupMenu _menu = PopupMenu(
        maxColumn: 1,
        items: [
          MenuItem(
              title: 'Update',
              image: Icon(
                Icons.update,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Delete',
              image: Icon(
                Icons.delete_outline,
                color: Colors.red,
              )),
        ],
        onClickMenu: _onClickMenu,
        stateChanged: _onStateChanged,
        onDismiss: _onDismiss);
    _menu.show(widgetKey: _menuButtonKey);
  }

  Widget _buildCategoryAvatar() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: Theme.of(context).primaryColorLight,
      child: Center(
        child: Text(
          '${_category.title.substring(0, 1)}',
          style: Theme.of(context).textTheme.display1.copyWith(
              color: Colors.white70,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCategoryListTile() {
    return ListTile(
      leading: _buildCategoryAvatar(),
      title: Text('${_category.title}',
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold)),
      subtitle: Text(
        '${_category.description}',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: _openCustomMenuOptions,
        key: _menuButtonKey,
        icon: Icon(Icons.more_vert),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: _buildCategoryListTile(),
      ),
    );
  }
}
