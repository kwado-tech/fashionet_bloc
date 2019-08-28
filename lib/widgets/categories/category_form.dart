import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/consts/consts.dart';
import 'package:fashionet_bloc/models/return_type.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  CategoryBloc _categoryBloc;

  // GlobalKey<ScaffoldState> get _scaffoldKey => widget.scaffoldKey;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _categoryBloc = CategoryProvider.of(context);
  }

  void _hideKeyPad() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _buildFormTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          'Category Form',
          style: Theme.of(context).textTheme.display1.copyWith(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor),
        ),
        Text(
          'Complete all required information',
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(color: Theme.of(context).primaryColor, fontSize: 15.0),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildTitleTextField() {
    return StreamBuilder<String>(
        stream: _categoryBloc.title,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyles.textFieldTextStyle,
            controller: _titleController,
            onChanged: _categoryBloc.onTitleChanged,
            decoration:
                InputDecoration(labelText: 'Title', errorText: snapshot.error),
          );
        });
  }

  Widget _buildDescriptioneTextField() {
    return StreamBuilder<String>(
        stream: _categoryBloc.description,
        builder: (context, snapshot) {
          return TextField(
            maxLines: 2,
            keyboardType: TextInputType.multiline,
            controller: _descriptionController,
            onChanged: _categoryBloc.onDescriptionChanged,
            style: TextStyles.textFieldTextStyle,
            decoration: InputDecoration(
                labelText: 'Description', errorText: snapshot.error),
          );
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

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();

    // reset stream controllers
    _categoryBloc.onTitleChanged('');
    _categoryBloc.onDescriptionChanged('');
  }

  void submitForm() async {
    _hideKeyPad();

    if (_titleController.text.isEmpty) {
      final _icon = Icon(Icons.warning, color: Colors.amber);
      _showSnackbar(
          icon: _icon, title: 'Validation', message: 'Please enter title');
      return;
    }

    if (_descriptionController.text.isEmpty) {
      final _icon = Icon(Icons.warning, color: Colors.amber);
      _showSnackbar(
          icon: _icon,
          title: 'Validation',
          message: 'Please enter description');
      return;
    }

    final ReturnType _isCreated = await _categoryBloc.createCategory(
        title: _titleController.text, description: _descriptionController.text);

    if (_isCreated.returnType) {
      final _icon = Icon(Icons.verified_user, color: Colors.green);
      _showSnackbar(
          icon: _icon, title: 'Success', message: _isCreated.messagTag);
      _resetForm();
    } else {
      final _icon = Icon(Icons.error_outline, color: Colors.red);

      _showSnackbar(icon: _icon, title: 'Error', message: _isCreated.messagTag);
    }
  }

  Widget _buildActionButton() {
    return StreamBuilder<bool>(
        stream: _categoryBloc.validateForm,
        builder: (context, validatorSnapshot) {
          return StreamBuilder<CategoryFormState>(
              stream: _categoryBloc.categoryFormState,
              builder: (context, snapshot) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: validatorSnapshot.hasData &&
                            validatorSnapshot.data &&
                            snapshot.data != CategoryFormState.Loading
                        ? () => submitForm()
                        : null,
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Submit',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 20.0),
                          snapshot.data == CategoryFormState.Loading
                              ? SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0),
                                )
                              : Icon(Icons.arrow_forward_ios,
                                  size: 18.0,
                                  color: Theme.of(context).primaryColor)
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Widget _buildCategoryForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildFormTitle(),
          _buildTitleTextField(),
          _buildDescriptioneTextField(),
          SizedBox(height: 20.0),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildCategoryForm(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // elevation: 0.0,
      // backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: GestureDetector(
        onTap: () => _hideKeyPad(),
        child: _buildBody(),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Dialog(
  //     elevation: 0.0,
  //     backgroundColor: Colors.transparent,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //     child: GestureDetector(
  //       onTap: () => _hideKeyPad(),
  //       child: Scaffold(
  //         key: _scaffoldKey,
  //         backgroundColor: Colors.transparent,
  //         body: _buildBody(),
  //       ),
  //     ),
  //   );
  // }
}
