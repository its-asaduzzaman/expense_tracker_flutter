import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/expense.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Isar isar;
  List<Expense> _allExpenses = [];

  /*

  S E T U P

  */

//initialize db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }

/*
  G E T T E R
 */
  List<Expense> get allExpense => _allExpenses;

/*
 O P E R A T I O N
  */

//create -  a new expanse
  Future<void> createNewExpense(Expense newExpense) async {
    //add to db
    await isar.writeTxn(() => isar.expenses.put(newExpense));

    //re-read from db
    await readExpense();
  }

//read - expense from the database
  Future<void> readExpense() async {
    //fetch all existing expense from db
    List<Expense> fetchExpenses = await isar.expenses.where().findAll();

    //give to local expense list
    _allExpenses.clear();
    _allExpenses.addAll(fetchExpenses);

    //update ui
    notifyListeners();
  }

//update - edite an expense in db

  Future<void> updateExpense(int id, Expense updatedExpense) async {
    //make sure new expense has same id as existing one
    updatedExpense.id = id;

    //update in db
    await isar.writeTxn(() => isar.expenses.put(updatedExpense));

    //re-read from db
    await readExpense();
  }

//delete - an expense

  Future<void> deleteExpense(int id) async {
    //delete from db
    await isar.writeTxn(() => isar.expenses.delete(id));

    //re-read from db
    await readExpense();
  }

/*

  H E L P E R

  */
}
