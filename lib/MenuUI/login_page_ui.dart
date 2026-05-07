import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyflow/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'post_login_menu_ui.dart';

String userIcon = "assets/images/UserIcon1.png";
String keyIcon = "assets/images/key_icon.png";

//Authorization Service 
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return 'No Account Found!';
      if (e.code == 'wrong-password') return 'Wrong Password';
      if (e.code == 'invalid-credential') return 'Invalid email or password';
      return e.message;
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.updateDisplayName(name.trim());
      return null;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'An account with this email already exists.';
      }

      if (e.code == 'weak-password') return 'Password is too weak';
      return e.message;
    }
  }

  String getUserName() {
    return _auth.currentUser?.displayName ?? 'User';
  }

  //Validators 
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is Required.';
      final regex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$', 
      );

      if (!regex.hasMatch(value.trim())) return 'Enter a Valid Email Address.';
      return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is Required.';
    if (value.length < 6) return 'Password must be at least 6 chracters.';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Passowrd must contain at least one number.';
    }
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]'))) {
      return 'Password must contain at least one special character.';
    }
    return null; 
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is Required.';
    return null;
  }
}

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
  }

  class _CreateAccountPageState extends State<CreateAccountPage> {
    final _formKey = GlobalKey<FormState>();
    final _nameCtrl = TextEditingController();
    final _emailCtrl = TextEditingController();
    final _passwordCtrl = TextEditingController();
    final _confirmCtrl = TextEditingController();

    bool _obscurePassword = true; 
    bool _obscureConfirm = true; 
    bool _isLoading = false; 

    @override 
    void dispose() {
      _nameCtrl.dispose();
      _emailCtrl.dispose();
      _passwordCtrl.dispose();
      _confirmCtrl.dispose();
      super.dispose();
    }

    Future<void> _onRegister() async {
      if (!_formKey.currentState!.validate()) return;
      setState ( () => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 400));

      final error = await AuthService.instance.register(
        _nameCtrl.text,
        _emailCtrl.text,
        _passwordCtrl.text,
      );

      setState ( () => _isLoading = false);
      if (error != null) {
        _showSnackBar(error, isError: true);
        return;
      }

      _showSnackBar('Account created! Please log in.', isError: false);
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return; 
      Navigator.pop(context);
    }

    void _showSnackBar(String message, {required bool isError}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: 
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
      );
    }
    InputDecoration _inputDecoration( {
      required String hint,
      required String prefixAsset,
      Widget? suffixIcon,
    })
    {
      return InputDecoration(
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(prefixAsset, width: 20),
        ),

        suffixIcon: suffixIcon, 
        fillColor: Colors.white, 
        errorStyle: const TextStyle( 
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),

        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(37),
        ),

        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(37),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(37),
          )
        );
    }

    @override 
    Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;

      return Scaffold(
        body: Container( 
          height: double.maxFinite,
          decoration: const BoxDecoration( 
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 47, 158, 249),
                Color.fromARGB(255, 197, 227, 252),
              ],

              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: SafeArea( 
            child: SingleChildScrollView(
              padding: EdgeInsets.all(size.height * 0.040),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero, 
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    const Text( 
                      "Create Account",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text( 
                      "Fill in the details below to get started.",
                      style: TextStyle( 
                        fontSize: 15,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    _buildLabel("Full Name"),
                    SizedBox(height: size.height * 0.008),
                    TextFormField( 
                      controller: _nameCtrl,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: Colors.black),
                      validator: AuthService.validateName,
                      decoration: _inputDecoration( 
                        hint: "Your name",
                        prefixAsset: userIcon,
                      ),
                    ),
                    SizedBox(height: size.height * 0.022),
                    _buildLabel("Email Address"),
                    SizedBox(height: size.height * 0.008),
                    TextFormField( 
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.black),
                      validator: AuthService.validateEmail,
                      decoration: _inputDecoration( 
                        hint: "you@example.com",
                        prefixAsset: userIcon,
                      ),
                    ),
                    SizedBox(height: size.height * 0.022),
                    _buildLabel("Password"),
                    SizedBox(height: size.height * 0.008),
                    TextFormField( 
                      controller: _passwordCtrl, 
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.black),
                      validator: AuthService.validatePassword,
                      decoration: _inputDecoration( 
                        hint: "Minimum of 6 characters, A-z, 0-9,special character",
                        prefixAsset: keyIcon,
                        suffixIcon: IconButton( 
                          icon: Icon (
                            _obscurePassword 
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                              color: Colors.grey,
                          ),
                          onPressed: () => setState( 
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    const _PasswordHints(),

                    SizedBox(height: size.height * 0.022),
                    _buildLabel("Verify Password"),
                    SizedBox(height: size.height * 0.008),
                    TextFormField( 
                      controller: _confirmCtrl,
                      obscureText: _obscureConfirm,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please verify your password.';
                        }
                        if (value != _passwordCtrl.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                      decoration: _inputDecoration(
                        hint: "Re-enter your password", 
                        prefixAsset: keyIcon,
                        suffixIcon: IconButton(
                          icon: Icon( 
                            _obscureConfirm 
                              ? Icons.visibility_off_outlined 
                              : Icons.visibility_outlined,
                              color: Colors.grey,
                          ),
                          onPressed: () => setState( 
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: size.height * 0.04),
                  CupertinoButton( 
                    padding: EdgeInsets.zero,
                    onPressed: _isLoading ? null : _onRegister,
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.080,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 125, 205, 249),
                        borderRadius: BorderRadius.circular(37),
                      ),
                      child: _isLoading 
                        ? const SizedBox( 
                          width: 22, 
                          height: 22, 
                          child: CircularProgressIndicator( 
                            color: Colors.white, 
                            strokeWidth: 2.5,
                          ),
                        )
                        : const Text( 
                          "Create Account",
                          style: TextStyle( 
                            color: Colors.white, 
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                    ),
                  ),
                SizedBox(height: size.height * 0.025),
                Center( 
                  child: CupertinoButton(
                    padding: EdgeInsets.zero, 
                    onPressed: () => Navigator.pop(context),
                    child: const Text( 
                      "Already have an account? Log In",
                      style: TextStyle (
                        color: Colors.white, 
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildLabel(String text) {
      return Text( 
        text, 
        style: const TextStyle( 
          color: Colors.white, 
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      );
    }
  }
  class _PasswordHints extends StatelessWidget { 
    const _PasswordHints();

  @override
  Widget build(BuildContext context) {
    const rules = [
      'At least 6 chracters',
      'One uppercase letter (A-Z)',
      'One lowercase letter (a-z)',
      'One number (0-9)',
      'One special character (!@#\$... etc.)',
    ];
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration( 
        color: const Color.fromARGB(255, 47, 130, 200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password must include:",
            style: TextStyle( 
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          ...rules.map( 
            (r) => Padding( 
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Row( 
                children: [
                  const Icon(Icons.circle, color: Colors.white70, size: 6),
                  const SizedBox(width: 6),
                  Text ( 
                    r, 
                    style: 
                      const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ); 
  }
  }

class LoginPage extends StatefulWidget {
 const LoginPage({super.key});


 @override
 State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
 final _formKey = GlobalKey<FormState>();
 final _emailCtrl = TextEditingController();
 final _passwordCtrl = TextEditingController();


 bool _obscurePassword = true;
 bool _isLoading = false;


 @override
 void dispose() {
   _emailCtrl.dispose();
   _passwordCtrl.dispose();
   super.dispose();
 }


 Future<void> _onContinue() async {
   if (!_formKey.currentState!.validate()) return;


   setState(() => _isLoading = true);
   await Future.delayed(const Duration(milliseconds: 500));


   final result = await AuthService.instance.login(
     _emailCtrl.text,
     _passwordCtrl.text,
   );


   setState(() => _isLoading = false);
   if (!mounted) return;


   if (result == 'No Account Found!') {
     _showSnackBar(
       'No account found. Please create an account then log in.',
       isError: true,
     );
     return;
   }


   if (result == 'Wrong Password' || result == 'Invalid email or password') {

     _showSnackBar('Incorrect password. Please try again.', isError: true);
     return;
   }


   Navigator.pushReplacement(
     context,
     MaterialPageRoute(builder: (_) => const PostLoginMenuUI()),
   );
 }


 void _onCreateAccount() {
   Navigator.push(
     context,
     MaterialPageRoute(builder: (_) => const CreateAccountPage()),
   );
 }


 void _showSnackBar(String message, {required bool isError}) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(message),
       backgroundColor:
           isError ? Colors.red.shade700 : Colors.green.shade700,
       behavior: SnackBarBehavior.floating,
       shape:
           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       duration: const Duration(seconds: 3),
     ),
   );
 }


 @override
 Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;


   return Scaffold(
     body: Container(
       height: double.maxFinite,
       decoration: const BoxDecoration(
         gradient: LinearGradient(
           colors: [
             Color.fromARGB(255, 47, 158, 249),
             Color.fromARGB(255, 197, 227, 252),
           ],
           begin: Alignment.bottomCenter,
           end: Alignment.topCenter,
         ),
       ),
       child: SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.all(size.height * 0.040),
           child: Form(
             key: _formKey,
             child: Column(
               children: [
                 Image.asset("assets/images/Image1.png"),
                 SizedBox(height: size.height * 0.018),
                 const Text(
                   "Welcome Back!",
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 20,
                     fontWeight: FontWeight.w600,
                     color: Colors.white,
                   ),
                 ),
                 SizedBox(height: size.height * 0.007),
                 const Text(
                   "Please, Log In.",
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 34,
                     fontWeight: FontWeight.w600,
                     color: Colors.white,
                   ),
                 ),
                 SizedBox(height: size.height * 0.03),


                 // Email Field
                 TextFormField(
                   controller: _emailCtrl,
                   keyboardType: TextInputType.emailAddress,
                   style: const TextStyle(color: Colors.black),
                   validator: AuthService.validateEmail,
                   decoration: InputDecoration(
                     filled: true,
                     hintText: "Email",
                     prefixIcon: Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: Image.asset(userIcon, width: 20),
                     ),
                     fillColor: Colors.white,
                     errorStyle: const TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.w500,
                     ),
                     border: OutlineInputBorder(
                       borderSide: BorderSide.none,
                       borderRadius: BorderRadius.circular(37),
                     ),
                     errorBorder: OutlineInputBorder(
                       borderSide: const BorderSide(
                           color: Colors.white, width: 1.5),
                       borderRadius: BorderRadius.circular(37),
                     ),
                     focusedErrorBorder: OutlineInputBorder(
                       borderSide:
                           const BorderSide(color: Colors.white, width: 2),
                       borderRadius: BorderRadius.circular(37),
                     ),
                   ),
                 ),


                 SizedBox(height: size.height * 0.025),


                 // Password Field
                 TextFormField(
                   controller: _passwordCtrl,
                   obscureText: _obscurePassword,
                   style: const TextStyle(color: Colors.black),
                   validator: AuthService.validatePassword,
                   decoration: InputDecoration(
                     filled: true,
                     hintText: "Password",
                     prefixIcon: Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: Image.asset(keyIcon, width: 20),
                     ),
                     suffixIcon: IconButton(
                       icon: Icon(
                         _obscurePassword
                             ? Icons.visibility_off_outlined
                             : Icons.visibility_outlined,
                         color: Colors.grey,
                       ),
                       onPressed: () => setState(
                         () => _obscurePassword = !_obscurePassword,
                       ),
                     ),
                     fillColor: Colors.white,
                     errorStyle: const TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.w500,
                     ),
                     border: OutlineInputBorder(
                       borderSide: BorderSide.none,
                       borderRadius: BorderRadius.circular(37),
                     ),
                     errorBorder: OutlineInputBorder(
                       borderSide: const BorderSide(
                           color: Colors.white, width: 1.5),
                       borderRadius: BorderRadius.circular(37),
                     ),
                     focusedErrorBorder: OutlineInputBorder(
                       borderSide:
                           const BorderSide(color: Colors.white, width: 2),
                       borderRadius: BorderRadius.circular(37),
                     ),
                   ),
                 ),


                 SizedBox(height: size.height * 0.02),


                 // Continue Button
                 CupertinoButton(
                   padding: EdgeInsets.zero,
                   onPressed: _isLoading ? null : _onContinue,
                   child: Container(
                     alignment: Alignment.center,
                     height: size.height * 0.080,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       color: const Color.fromARGB(255, 125, 205, 249),
                       borderRadius: BorderRadius.circular(37),
                     ),
                     child: _isLoading
                         ? const SizedBox(
                             width: 22,
                             height: 22,
                             child: CircularProgressIndicator(
                               color: Colors.white,
                               strokeWidth: 2.5,
                             ),
                           )
                         : const Text(
                             "Continue",
                             style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.w700,
                               fontSize: 16,
                             ),
                           ),
                   ),
                 ),


                 SizedBox(height: size.height * 0.04),
                 Row(
                   children: [
                     const Expanded(
                         child: Divider(height: 1, color: Colors.white)),
                     SizedBox(width: size.width * 0.02),
                     const Text(
                       "OR",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 16,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     SizedBox(width: size.width * 0.02),
                     const Expanded(
                         child: Divider(height: 1, color: Colors.white)),
                   ],
                 ),


                 SizedBox(height: size.height * 0.04),
                 CupertinoButton(
                   padding: EdgeInsets.zero,
                   onPressed: _onCreateAccount,
                   child: Container(
                     alignment: Alignment.center,
                     height: size.height * 0.080,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       color: const Color.fromARGB(255, 125, 205, 249),
                       borderRadius: BorderRadius.circular(37),
                     ),
                     child: const Text(
                       "Create an Account",
                       style: TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.w700,
                         fontSize: 16,
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
       ),
     ),
   );
 }
}


void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await AuthService.initialize();
 runApp(
   const MaterialApp(
     debugShowCheckedModeBanner: false,
     home: LoginPage(),
   ),
 );
}
