import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:apartments/app/utils/services/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = false;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      dynamic res = await _apiClient.login(
        usernameController.text,
        passwordController.text,
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (res['status'] != 401) {
        String accessToken = res['token'];
        String token = accessToken;

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        bool isTokenExpired = JwtDecoder.isExpired(token);

        if (isTokenExpired == true) {
          Get.toNamed('/loginScreen');
        }
        await SPHelper.saveTokenSharedPreference(token);

        // DateTime expirationDate = JwtDecoder.getExpirationDate(token);

        // print(expirationDate);

        // Duration tokenTime = JwtDecoder.getTokenTime(token);

        // print(tokenTime.inDays);
        Get.toNamed('/dashboard');
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) =>  const DashboardScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['Message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blueGrey[200],
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Stack(children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // SizedBox(height: size.height * 0.08),
                              const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.06),
                              TextFormField(
                                controller: usernameController,
                                validator: (value) {
                                  return Validator.validateName(value ?? "");
                                },
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: "User name",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.03),
                              TextFormField(
                                obscureText: _showPassword,
                                controller: passwordController,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                validator: (value) {
                                  return Validator.validatePassword(
                                      value ?? "");
                                },
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(
                                          () => _showPassword = !_showPassword);
                                    },
                                    child: Icon(
                                      _showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Password",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.04),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: login,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.indigo,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15)),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}
