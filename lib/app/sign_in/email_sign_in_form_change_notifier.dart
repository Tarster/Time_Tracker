import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_final/common_widgets/form_submit_button.dart';
import 'package:time_tracker_final/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_final/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  void _emailEditingComplete() {
    final newFocus = widget.model.emailValidator.isValid(widget.model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      //This will automatically choose the platform and show the corresponding alert dialogue
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FormSubmitButton(
          text: widget.model.primaryButtonText,
          onPressed: widget.model.canSubmit ? _submit : null,
        ),
      ),
      TextButton(
        onPressed: !widget.model.isLoading ? _toggleFormType : null,
        child: Text(widget.model.secondaryButtonText),
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      onEditingComplete: () => _emailEditingComplete(),
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      onChanged: widget.model.updateEmail,
      controller: _emailController,
      enabled: widget.model.isLoading == false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: widget.model.emailErrorText,
      ),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      enabled: widget.model.isLoading == false,
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      obscureText: true,
      onChanged: widget.model.updatePassword,
      decoration: InputDecoration(
        errorText: widget.model.passwordErrorText,
        labelText: 'Password',
      ),
    );
  }


}
