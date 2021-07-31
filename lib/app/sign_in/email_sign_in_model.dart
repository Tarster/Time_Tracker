import 'package:time_tracker_final/app/sign_in/validators.dart';

enum EmailSignInFormType { SignIn, Register }

class EmailSignInModel with EmailAndPasswordValidators {
  //Model Fields
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool submitted;

  //Actual Constructor of the model
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.SignIn,
    this.isLoading = false,
    this.submitted = false,
  });

  String get primaryButtonText {
    return formType == EmailSignInFormType.SignIn ? 'Sign in' : 'Register';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.SignIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  //copyWith function to copy old properties and new provided properties in the new object.
  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
