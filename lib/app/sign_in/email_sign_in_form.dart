import 'package:flutter/material.dart';
import 'package:time_tracker_final/app/sign_in/validators.dart';
import 'package:time_tracker_final/common_widgets/form_submit_button.dart';
import 'package:time_tracker_final/services/auth.dart';

enum EmailSignInFormType { SignIn, Register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  final AuthBase auth;
  EmailSignInForm({required this.auth});
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.SignIn;
  bool _submitted = false;

  void _submit() async {
    setState(() {
      _submitted = true;
    });
    try {
      if (_formType == EmailSignInFormType.SignIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.SignIn
          ? EmailSignInFormType.Register
          : EmailSignInFormType.SignIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.SignIn ? 'Sign in' : 'Register';
    final secondaryText = _formType == EmailSignInFormType.SignIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    //Checking for submit button using mixin class validator
    bool _submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);
    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FormSubmitButton(
          text: primaryText,
          onPressed: _submitEnabled ? _submit : null,
        ),
      ),
      TextButton(
        onPressed: _toggleFormType,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      onEditingComplete: _emailEditingComplete,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      onChanged: (email) => _updateState(),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
      ),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      obscureText: true,
      onChanged: (password) => _updateState(),
      decoration: InputDecoration(
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        labelText: 'Password',
      ),
    );
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

  void _updateState() {
    setState(() {});
  }
}
