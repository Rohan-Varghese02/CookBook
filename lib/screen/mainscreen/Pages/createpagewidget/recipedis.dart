import 'dart:typed_data';

import 'package:cook_book/const/colors.dart';
import 'package:cook_book/db/dbfunction/recipe_notifier.dart';
import 'package:cook_book/db/model/recipe_model/recipe_model.dart';
import 'package:cook_book/screen/recipescreen/recipescreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Recipedis extends StatelessWidget {
  const Recipedis({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: recipeListNotifier,
      builder: (BuildContext ctx, List<RecipeModel> recipeList, Widget? child) {
        return ListView.separated(
          itemBuilder: (ctx, index) {
            final data = recipeList[index];
            Uint8List pic = data.recipePic ?? Uint8List(0);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => Recipescreen(data: data)));
                },
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(primary)),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: ListTile(
                      title: Text(
                        data.name,
                        style: GoogleFonts.poppins(
                            color: const Color(primary),
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.star,
                              size: 20, color: const Color(primary)),
                          Text(
                            data.rating,
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          const SizedBox(
                            width: 35,
                          ),
                          const Icon(Icons.shopify,
                              size: 20, color:  Color(primary)),
                          Text(
                            data.ingridients.length.toString(),
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          const SizedBox(
                            width: 35,
                          ),
                          const Icon(Icons.timer,
                              size: 20, color:  Color(primary)),
                          Text(
                            data.ingridients.length.toString(),
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: MemoryImage(pic),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            deleteRecipe(data.id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox();
          },
          itemCount: recipeList.length,
        );
      },
    );
  }
}
