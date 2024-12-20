// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:typed_data';

import 'package:cook_book/const/colors.dart';
import 'package:cook_book/const/utils.dart';
import 'package:cook_book/db/model/usermodel/user_model.dart';
import 'package:cook_book/screen/main_screen/main_view.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Proceedbtn extends StatelessWidget {
  TextEditingController nameController;
  final Uint8List? image;
  final GlobalKey<FormState> formkey;
  final List<String> selectedCategories;

  Proceedbtn(
      {super.key,
      required this.formkey,
      required this.nameController,
      required this.selectedCategories,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color.fromARGB(226, 4, 160, 134),
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        if (formkey.currentState?.validate() ?? false) {
          // Form is valid, perform your action
          if (image == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add Profile Picture')),
            );
          }
          if (selectedCategories.length < 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Enter atleast 2 Cuisines')),
            );
          } else {
            saveUserData(
                nameController.text.trim(), image!, selectedCategories);
            final sharedPrefs = await SharedPreferences.getInstance();
            await sharedPrefs.setBool(save_State, true);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const MainView()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enter your name')),
          );
        }
      },
      child: Container(
        width: 350,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: const Color(primary),
          ),
        ),
        child: const Center(
          child: Text(
            'Proceed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(primary),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveUserData(
      String name, Uint8List profilePicture, List<String> cuisines) async {
    final box = Hive.box<UserModel>('userBox');

    // Store user data in the box
    final user = UserModel(
      name: name,
      profilePic: image,
      cuisine: selectedCategories,
    );

    await box.put('user', user); // Save with a fixed key (e.g., 'user')
  }
}
