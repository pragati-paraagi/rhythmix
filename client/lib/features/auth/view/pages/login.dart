import 'package:client/features/auth/view/pages/sign_up.dart';
import 'package:client/features/auth/view/widgets/loading.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/home/view/pages/upload_song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.1;
    double iconSize = screenWidth * 0.1;
    final isLoading = ref.watch(authViewmodelProvider.select((val)=>val?.isLoading==true));

    ref.listen(authViewmodelProvider, (_, next){
         next?.when(
           data: (data) {
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomePage()),(_)=>false);
           }, 
           error: (error, st) {
             ScaffoldMessenger.of(context)
               ..hideCurrentSnackBar()
               ..showSnackBar(
                 SnackBar(content: Text(error.toString()))
               );
           }, 
           loading: () {}
         );
       }
    );

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: isLoading ? const Loader() : SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    // Changed to cover full screen height
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        'images/img.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Added a semi-transparent overlay for better text visibility
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    Positioned(
                      top: 370,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Rhythmix....',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: screenWidth * 0.9,
                              child: TextFormField(
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return "Email is required";
                                  }
                                  // Basic email validation
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                                    return "Please enter a valid email";
                                  }
                                  return null;
                                },
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    fontSize: fontSize * 0.40,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: const Color(0xff45859d),
                                    size: iconSize * 0.6,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: screenWidth * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextFormField(
                                    obscureText: true,
                                    controller: passwordController,
                                    validator: (val) {
                                      if (val == null || val.trim().isEmpty) {
                                        return "Password is required";
                                      }
                                      if (val.length < 6) {
                                        return "Password must be at least 6 characters";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: fontSize * 0.40,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: const Color(0xff45859d),
                                        size: iconSize * 0.6,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white70,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      // Handle forgot password
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: fontSize * 0.40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () async {
                                if(formKey.currentState!.validate()){
                                  await ref.read(authViewmodelProvider.notifier).loginUser(
                                    email: emailController.text.trim(), 
                                    password: passwordController.text.trim()
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text("Please fill all fields correctly")));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xff45859d),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100.0,
                                  vertical: 15.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              child: Text(
                                'Sign In',
                                style: TextStyle(fontSize: fontSize * 0.45),
                              ),
                            ),
                            const SizedBox(height: 35),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSize * 0.40,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      _fadeTransition(const SignUp()),
                                    );
                                  },
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: const Color(0xff45859d),
                                      fontSize: fontSize * 0.5,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  PageRouteBuilder _fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}