import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFF6F91BC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFF6F91BC)),
          ),
          labelStyle: TextStyle(color: Color(0xFF6F91BC)),
        ),
      ),
      home: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isPasswordLengthValid = false;
  bool _containsUppercase = false;
  bool _containsDigit = false;
  bool _isSubmitted = false;

  void _validatePassword(String password) {
    setState(() {
      _isPasswordLengthValid = password.length >= 8 && password.length <= 64;
      _containsUppercase = password.contains(RegExp(r'[A-Z]'));
      _containsDigit = password.contains(RegExp(r'\d'));
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _submitForm() {
    setState(() {
      _isSubmitted = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sign up success'),
            content: Text('You have successfully signed up.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  InputDecoration _inputDecoration({required String hintText, required bool hasError}) {
    Color borderColor = hasError ? Color(0xFFFF8080) : _isSubmitted ? Color(0xFF27B274) : Color(0xFF6F91BC);
    Color textColor = hasError ? Color(0xFFFF8080) : _isSubmitted ? Color(0xFF27B274) : Color(0xFF6F91BC);

    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6F91BC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6F91BC)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFFFF8080)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFFFF8080)),
      ),
      hintStyle: TextStyle(color: textColor),
      labelStyle: TextStyle(color: textColor),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28,
            height: 1,
            color: Color(0xFF4A4E71),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4F9FF),
              Color(0xFFE0EDFB),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration(hintText: 'Email', hasError: false),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                      return '';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: _inputDecoration(hintText: 'Create your password', hasError: false).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: _isSubmitted
                            ? (_isPasswordLengthValid && _containsUppercase && _containsDigit ? Color(0xFF27B274) : Color(0xFFFF8080))
                            : Color(0xFF6F91BC),
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  onChanged: _validatePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    if (!_isPasswordLengthValid) {
                      return '';
                    }
                    if (!_containsUppercase) {
                      return '';
                    }
                    if (!_containsDigit) {
                      return '';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '8 characters or more (no spaces)',
                        style: TextStyle(
                          color: _isPasswordLengthValid ? Color(0xFF27B274) : Color(0xFFFF8080),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Uppercase and lowercase letters',
                        style: TextStyle(
                          color: _containsUppercase ? Color(0xFF27B274) : Color(0xFFFF8080),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'At least one digit',
                        style: TextStyle(
                          color: _containsDigit ? Color(0xFF27B274) : Color(0xFFFF8080),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.0, width: 240.0),
                GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        colors: [Color(0xFF70C3FF), Color(0xFF4B65FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
