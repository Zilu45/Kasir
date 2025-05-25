import 'package:flutter/material.dart';
import 'package:flutter_kasir/services/user.dart';
import 'package:flutter_kasir/widgets/alert.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  insertUser() async {
    var data = {
      "name": name.text,
      "email": email.text,
      "role": role,
      "password": password.text,
    };
    var result = await UserService().registerUser(data);
    if (result.status == true) {
      AlertMessage().showAlert(context, result.message, result.status);
    }
    print(result.status);
    print(result.message);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  UserService user = UserService();
  final formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  List roleChoice = ["admin", "user"];
  String? role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Register User"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: Icon(Icons.login))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Text(
                "Register User",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(label: Text("Name")),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama harus diisi';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(label: Text("Email")),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email harus diisi';
                        } else {
                          return null;
                        }
                      },
                    ),
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: role,
                      items: roleChoice.map((r) {
                        return DropdownMenuItem(value: r, child: Text(r));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          role = value.toString();
                        });
                      },
                      hint: Text("Pilih role"),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Role harus dipilih';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: password,
                      decoration: InputDecoration(label: Text("Password")),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password harus diisi';
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          var data = {
                            "name": name.text,
                            "email": email.text,
                            "role": role,
                            "password": password.text,
                          };
                          var result = await user.registerUser(data);
                          if (result.status == true) {
                            name.clear();
                            email.clear();
                            password.clear();
                            setState(() {
                              role = null;
                            });
                            AlertMessage()
                                .showAlert(context, result.message, true);
                            Navigator.pushReplacementNamed(context, '/login');
                          } else {
                            AlertMessage()
                                .showAlert(context, result.message, false);
                          }
                        }
                      },
                      color: const Color.fromARGB(255, 42, 158, 216),
                      child: Text("Register"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_kasir/services/user.dart';
// import 'package:flutter_kasir/widgets/alert.dart';

// class RegisterUserView extends StatefulWidget {
//   const RegisterUserView({super.key});

//   @override
//   State<RegisterUserView> createState() => _RegisterUserViewState();
// }

// class _RegisterUserViewState extends State<RegisterUserView> {
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController name = TextEditingController();
//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final UserService user = UserService();

//   List<String> roleChoice = ["admin", "user"];
//   String? role;
//   bool isLoading = false;
//   bool isPasswordVisible = false;

//   Future<void> registerUser() async {
//     if (!formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     var data = {
//       "name": name.text,
//       "email": email.text,
//       "role": role,
//       "password": password.text,
//     };

//     var result = await user.registerUser(data);

//     setState(() => isLoading = false);

//     AlertMessage().showAlert(context, result.message, result.status);

//     if (result.status) {
//       name.clear();
//       email.clear();
//       password.clear();
//       setState(() => role = null);
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         title: const Text("Register User"),
//         backgroundColor: const Color.fromARGB(255, 59, 82, 253),
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
//             icon: const Icon(Icons.login),
//           )
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 5,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Register User",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       controller: name,
//                       decoration: const InputDecoration(labelText: "Name"),
//                       validator: (value) =>
//                           value!.isEmpty ? 'Nama harus diisi' : null,
//                     ),
//                     TextFormField(
//                       controller: email,
//                       decoration: const InputDecoration(labelText: "Email"),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) =>
//                           value!.isEmpty ? 'Email harus diisi' : null,
//                     ),
//                     DropdownButtonFormField(
//                       isExpanded: true,
//                       value: role,
//                       items: roleChoice.map((r) {
//                         return DropdownMenuItem(value: r, child: Text(r));
//                       }).toList(),
//                       onChanged: (value) =>
//                           setState(() => role = value.toString()),
//                       decoration: const InputDecoration(labelText: "Role"),
//                       validator: (value) =>
//                           value == null ? 'Role harus dipilih' : null,
//                     ),
//                     TextFormField(
//                       controller: password,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         suffixIcon: IconButton(
//                           icon: Icon(isPasswordVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off),
//                           onPressed: () => setState(
//                               () => isPasswordVisible = !isPasswordVisible),
//                         ),
//                       ),
//                       obscureText: !isPasswordVisible,
//                       validator: (value) =>
//                           value!.isEmpty ? 'Password harus diisi' : null,
//                     ),
//                     const SizedBox(height: 20),
//                     MaterialButton(
//                       onPressed: () async {
//                         if (formKey.currentState!.validate()) {
//                           setState(() {
//                             isLoading = true;
//                             Navigator.pushNamed(context, '/login');
//                           });
//                           var data = {
//                             "email": email.text,
//                             "password": password.text,
//                           };
//                           var result = await user.registerUser(data);
//                           setState(() {
//                             isLoading = false;
//                           });
//                           print(result.message);
//                           if (result.status == true) {
//                             AlertMessage()
//                                 .showAlert(context, result.message, true);
//                             Future.delayed(Duration(seconds: 2), () {});
//                             Navigator.pushReplacementNamed(context, '/login');
//                           } else {
//                             AlertMessage()
//                                 .showAlert(context, result.message, false);
//                           }
//                         }
//                       },
//                       child: isLoading == true
//                           ? const CircularProgressIndicator(
//                               color: Color.fromARGB(255, 0, 0, 0))
//                           : const Text("Register",
//                               style: TextStyle(fontSize: 16)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
