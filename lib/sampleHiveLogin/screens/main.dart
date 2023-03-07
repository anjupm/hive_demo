import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_demo/db/db_function.dart';
import 'package:hive_demo/sampleHiveLogin/models/user_model.dart';
import 'package:hive_demo/sampleHiveLogin/screens/home_screen.dart';
import 'package:hive_demo/sampleHiveLogin/screens/signup.dart';
import 'package:hive_flutter/adapters.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<UserModel>('user');
  Hive.registerAdapter(UserModelAdapter());
  runApp(GetMaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatelessWidget {
  final email_controller = TextEditingController();
  final password_controler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
            child: Stack(
              children: [
                // const RiveAnimation.asset(
                //   "assets/rive/spiral.riv",
                //   fit: BoxFit.cover,
                // ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    //  color: Colors.transparent.withOpacity(.3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      TextField(
                        controller: email_controller,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                      TextField(
                        controller: password_controler,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: const InputDecoration(hintText: 'Password'),
                      ),
                      SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(onPressed: () async {

                            final list = await DBFunctions.instance.getUsers();
                            checkUser(list);

                            print(list);
                          }, child: const Text("Login Here"))),
                      TextButton(
                          onPressed: () {
                            Get.to(()=>SignUpScreen());
                          },
                          child: const Text("Not a user ? SignUp Here!!!")),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Future<void>  checkUser(List<UserModel> list)  async{
    final email = email_controller.text.trim();
    final pass  = password_controler.text.trim();

    bool isUserFound = false;
    final isValidated = await validateLogin(email,pass);

    if(isValidated == true){

      await Future.forEach(list, (user) {
        if(user.email == email &&  user.password == pass){
          isUserFound = true;
        }else{
          isUserFound = false;
        }
      });

      if( isUserFound == true){
        Get.offAll(()=> HomeScreen(email : email));
        Get.snackbar("Success", "Logged in $email");
      }else{
        Get.snackbar("error", "incorrect email or password");
      }
    }else{
      Get.snackbar("error", "Fields cannot be empty");

    }
  }

  Future<bool>  validateLogin(String email, String pass) async {
    if(email != ' ' && pass != " "){
      return true;
    }else{
      return false;
    }
  }
}