import 'package:cook_book/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cook_book/db/dbnotifiers/ingredients_notifier.dart';
import 'package:cook_book/db/model/shoppinglist_model/shoppinglist_model.dart';

class Getslist extends StatefulWidget {
  const Getslist({super.key});

  @override
  State<Getslist> createState() => _GetslistState();
}

class _GetslistState extends State<Getslist> {
  late SharedPreferences _prefs;
  Map<String, bool> _checkedState = {};

  @override
  void initState() {
    super.initState();
    _loadCheckedState();
  }

  Future<void> _loadCheckedState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _checkedState = Map<String, bool>.from(
        _prefs.getStringList('checkedState')?.asMap().map((key, value) =>
                MapEntry('${value.split(':')[0]}:${value.split(':')[1]}',
                    value.split(':')[2] == 'true')) ??
            {},
      );
    });
  }

  Future<void> _saveCheckedState() async {
    final List<String> savedStates = _checkedState.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .toList();
    await _prefs.setStringList('checkedState', savedStates);
  }

  void _removeCrossedOutIngredients() {
    setState(() {
      _checkedState.removeWhere((key, value) {
        if (value) {
          final parts = key.split(":");
          final name = parts[0];
          final quantity = parts[1];
          deleteIngredient(name, quantity);
        }
        return value;
      });
      _saveCheckedState();
    });
  }

  void _selectAll(List<IngredientModel> ingredientList) {
    setState(() {
      for (final ingredient in ingredientList) {
        final key = '${ingredient.name}:${ingredient.quantity}';
        _checkedState[key] = true; // Mark as selected
      }
      _saveCheckedState();
    });
  }

  void _uncheckAll(List<IngredientModel> ingredientList) {
    setState(() {
      for (final ingredient in ingredientList) {
        final key = '${ingredient.name}:${ingredient.quantity}';
        _checkedState[key] = false; // Mark as unselected
      }
      _saveCheckedState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ingredientNotifier,
      builder: (BuildContext ctx, List<IngredientModel> ingredientList,
          Widget? child) {
        if (ingredientList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Pending Items To Be Purchased',
                  style: GoogleFonts.poppins(
                      color: const Color(primary),
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Text(
                  'Press + button to add Ingredients',
                  style: GoogleFonts.poppins(
                      color: const Color(primary),
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(primary)),
                      onPressed: () => _selectAll(ingredientList),
                      child: Text(
                        "Select All",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(primary)),
                      onPressed: () => _uncheckAll(ingredientList),
                      child: Text(
                        "Uncheck All",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (ctx, index) {
                    final data = ingredientList[index];
                    final key = '${data.name}:${data.quantity}';
                    final isChecked = _checkedState[key] ?? false;

                    return ListTile(
                      title: Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        'Quantity: ${data.quantity}',
                        style: TextStyle(
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedState[key] = value ?? false;
                            _saveCheckedState();
                          });
                        },
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Divider();
                  },
                  itemCount: ingredientList.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(primary)),
                    onPressed: _removeCrossedOutIngredients,
                    child: Text(
                      "Clear Cart",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
