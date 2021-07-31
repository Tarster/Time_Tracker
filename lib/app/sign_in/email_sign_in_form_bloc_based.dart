import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_final/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_final/common_widgets/form_submit_button.dart';
import 'package:time_tracker_final/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_final/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
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

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
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

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    return [
      _buildEmailTextField(model),
      _buildPasswordTextField(model),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: FormSubmitButton(
          text: model!.primaryButtonText,
          onPressed: model.canSubmit ? _submit : null,
        ),
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  TextField _buildEmailTextField(EmailSignInModel? model) {
    return TextField(
      onEditingComplete: () => _emailEditingComplete(model!),
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      onChanged: widget.bloc.updateEmail,
      controller: _emailController,
      enabled: model!.isLoading == false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
      ),
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel? model) {
    return TextField(
      enabled: model!.isLoading == false,
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      obscureText: true,
      onChanged: widget.bloc.updatePassword,
      decoration: InputDecoration(
        errorText: model.passwordErrorText,
        labelText: 'Password',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel? model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(model),
          ),
        );
      },
    );
  }
}
