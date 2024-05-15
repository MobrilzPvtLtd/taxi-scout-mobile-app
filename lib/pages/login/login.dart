import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/pages/login/forgot_password.dart';
import 'package:tagyourtaxi_driver/pages/login/otp_page.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/pages/signupPage/signup_screen.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import '../../widgets/widgets.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

String phnumber = '';

class _LoginState extends State<Login> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailRegex = RegExp(
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])');
  final _passwordRegex =
      RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*]).{8,}$");
  String? _errorMessage;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool terms = true;
  bool _isLoading = true;
  bool passwordVisible = false;

  @override
  void initState() {
    countryCode();
    passwordVisible = true;
    super.initState();
  }

  countryCode() async {
    await getCountryCode();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //navigate
  navigate() {
    // Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) =>  Maps()),
    //       (route) => false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Otp()));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: (languageDirection == 'rtl')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Stack(
              children: [
                (countries.isNotEmpty)
                    ? Container(
                        color: page,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            left: media.width * 0.08,
                            right: media.width * 0.08),
                        height: media.height * 1,
                        width: media.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(height: media.height * 0.20),
                            Center(
                              child: Image.asset(
                                'assets/images/36759121.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                              ),
                            ),

                            //SizedBox(height: media.height * 0.195),
                            Text(
                              languages[choosenLanguage]['text_login'],
                              style: GoogleFonts.roboto(
                                  fontSize: media.width * twentysix,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                            SizedBox(
                              height: media.height * 0.100,
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF2F3F5),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none),
                                labelText: "Email",
                              ),
                              onSaved: (String? value) {},
                              validator: validateEmail,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                                obscureText: passwordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      }),
                                  labelText: "Password",
                                  filled: true,
                                  fillColor: Color(0xffF2F3F5),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                onSaved: (String? value) {},
                                  validator: (String? value) {
          if (value!.isEmpty) {
            return "Please Re-Enter New Password";
          } else {
          return null;
          }
          },),
                            SizedBox(height: 20),
                            Container(
                              width: media.width * 1 - media.width * 0.08,
                              alignment: Alignment.center,
                              child: Button(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _errorMessage = validateEmail(_emailController.text);
                                    if (_errorMessage == null) {
                                      _errorMessage = validatePassword(_passwordController.text);
                                    }

                                    if (_errorMessage == null) {
                                      var loginResult = await userLogin(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );

                                      if (loginResult == true) {
                                        // Navigate to new screen if login was successful
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Maps())
                                        );
                                      } else {
                                        // Show a snackbar with error if login failed
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Email or password is incorrect'))
                                        );
                                      }
                                    }
                                  }
                                  // Unfocus the keyboard
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },

                                text: languages[choosenLanguage]['text_login'],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ForgotPassword()),
                                    );
                                  },
                                  child: Text(
                                    languages[choosenLanguage]
                                        ['text_forgotPassword'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 1,
                                  width: 152,
                                  color: Colors.black,
                                ),
                                Text(
                                  "OR",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                                Container(
                                  height: 1,
                                  width: 152,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Need an account?",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                                    );
                                  },
                                  child: Text(
                                    "SignUp",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        color: textColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        height: media.height * 1,
                        width: media.width * 1,
                        color: page,
                      ),

                //No internet
                (internet == false)
                    ? Positioned(
                        top: 0,
                        child: NoInternet(onTap: () {
                          setState(() {
                            _isLoading = true;
                            internet = true;
                            countryCode();
                          });
                        }))
                    : Container(),

                //loader
                (_isLoading == true)
                    ? const Positioned(top: 0, child: Loading())
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email is required";
    } else if (!_emailRegex.hasMatch(value)) {
      return "Invalid  email format";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Password is required";
    }
    // else if (!_passwordRegex.hasMatch(value)) {
    //   return "Invalid password format";
    // }
    return null;
  }
}