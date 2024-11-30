import 'dart:async';
import 'package:fintracker/dao/account_dao.dart';
import 'package:fintracker/dao/category_dao.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/helpers/sharedpreferneceshelper.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentDao {

  Future<int> create(Payment payment) async {
    final db = await getDBInstance();

    // Remove the 'tags' from the payment and only insert the necessary fields into the 'payments' table
    var paymentData = payment.toJson();
    paymentData.remove('tags');

    // Insert the payment record first (without tags)
    var result = await db.insert("payments", paymentData);

    // If the payment has tags, insert them into the 'payment_tags' table
    if (payment.tags.isNotEmpty) {
      for (var tagId in payment.tags) {
        await db.insert("payment_tags", {
          'payment_id': result,
          'tag_id': tagId,
        });
      }
    }

    return result;
  }


  Future<List<Payment>> find(
      {DateTimeRange? range,
      PaymentType? type,
      Category? category,
      Account? account}) async {
    final db = await getDBInstance();
    String where = "";

    if (range != null) {
      where +=
          "AND datetime BETWEEN DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.start)}') AND DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.end.add(const Duration(days: 1)))}')";
    }

    //type check
    if (type != null) {
      where += "AND type='${type == PaymentType.credit ? "DR" : "CR"}' ";
    }

    //icon check
    if (account != null) {
      where += "AND account='${account.id}' ";
    }

    //icon check
    if (category != null) {
      where += "AND category='${category.id}' ";
    }

    //categories
    List<Category> categories = await CategoryDao().find();
    List<Account> accounts = await AccountDao().find();

    List<Payment> payments = [];
    List<Map<String, Object?>> rows = await db.query("payments",
        orderBy: "datetime DESC, id DESC", where: "1=1 $where");
    for (var row in rows) {
      Map<String, dynamic> payment = Map<String, dynamic>.from(row);
      Account account = accounts.firstWhere((a) => a.id == payment["account"]);
      Category category =
          categories.firstWhere((c) => c.id == payment["category"]);
      payment["category"] = category.toJson();
      payment["account"] = account.toJson();
      payment['autoCategorizationEnabled'] =
          payment['autoCategorizationEnabled'] == 0 ? false : true;
      payments.add(Payment.fromJson(payment));
    }

    return payments;
  }

  Future<int> update(Payment payment) async {
    final db = await getDBInstance();

    // Remove the 'tags' from the payment data to avoid error
    var paymentData = payment.toJson();
    paymentData.remove('tags');  // Remove 'tags' from the update data

    // Update the payment record first (without tags)
    var result = await db.update("payments", paymentData,
        where: "id = ?", whereArgs: [payment.id]);

    // Remove old tags for the payment (if any)
    await db.delete("payment_tags", where: "payment_id = ?", whereArgs: [payment.id]);

    // Insert new tags (if any)
    if (payment.tags.isNotEmpty) {
      for (var tagId in payment.tags) {
        await db.insert("payment_tags", {
          'payment_id': payment.id,
          'tag_id': tagId,
        });
      }
    }

    return result;
  }

  Future<int> upsert(Payment payment) async {
    final db = await getDBInstance();
    int result;

    if (payment.id != null) {
      // Update the existing payment
      var paymentData = payment.toJson();
      paymentData.remove('tags'); // Remove 'tags' from the data to avoid the error

      result = await db.update("payments", paymentData,
          where: "id = ?", whereArgs: [payment.id]);

      // Remove old tags for the payment
      await db.delete("payment_tags", where: "payment_id = ?", whereArgs: [payment.id]);

      // Insert new tags (if any)
      if (payment.tags.isNotEmpty) {
        for (var tagId in payment.tags) {
          await db.insert("payment_tags", {
            'payment_id': payment.id,
            'tag_id': tagId,
          });
        }
      }
    } else {
      // Insert the new payment
      var paymentData = payment.toJson();
      paymentData.remove('tags'); // Remove 'tags' from the new payment

      result = await db.insert("payments", paymentData);

      // Insert tags for the new payment (if any)
      if (payment.tags.isNotEmpty) {
        for (var tagId in payment.tags) {
          await db.insert("payment_tags", {
            'payment_id': result,
            'tag_id': tagId,
          });
        }
      }
    }

    return result;
  }

  Future<int> deleteTransaction(int id) async {
    final db = await getDBInstance();

    // Delete the tags associated with this payment
    await db.delete("payment_tags", where: "payment_id = ?", whereArgs: [id]);

    // Now delete the payment record
    var result = await db.delete("payments", where: 'id = ?', whereArgs: [id]);

    return result;
  }

  Future deleteAllTransactions() async {
    final db = await getDBInstance();

    // Then delete all payments
    var result = await db.delete("payments");

    return result;
  }

  Future<int> findPaymentCategoryByTitle(String title) async {
    final db = await getDBInstance();
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: 'title = ? AND autoCategorizationEnabled = ?',
      whereArgs: [title, true], // Assuming you want to filter for true
    );
    if (maps.isNotEmpty) {
      // Returns the Index of Applied Category
      return (maps.first)['category'] - 1;
    }
    return 9;
  }

  Future<List<Map<String, dynamic>>?> findPaymentsWithMissingCategory() async {
    final db = await getDBInstance();
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: 'category = ?',
      whereArgs: [9], // Assuming you want to filter for true
    );
    if (maps.isNotEmpty) {
      return maps;
    }
    return null;
  }

  Future<Map<String, dynamic>?> searchForSameTitle(String title, int id) async {
    final db = await getDBInstance();
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: 'title = ? AND id != ?',
      whereArgs: [title, id], // Assuming you want to filter for true
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }

    return null;
  }

  Future<List<Map<String, dynamic>>?> getAllMiscellanous() async {
    List<Category> allCategories = await CategoryDao().find();
    final db = await getDBInstance();
    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: 'category = ?',
      whereArgs: [10], // Assuming you want to filter for true
    );

    if (maps.isNotEmpty) {
      return maps;
    }

    return null;
  }

  Future<int> updateMiscellanousCategories() async {
    int count = 0;
    CategoryDao categoryDao = CategoryDao();
    AccountDao accountDao = AccountDao();
    List<Map<String, dynamic>> allMisPayments =
        await getAllMiscellanous() ?? [];
    if (allMisPayments.isNotEmpty) {
      for (Map<String, dynamic> misPayment in allMisPayments) {
        Map<String, dynamic> gotPayment =
            await searchForSameTitle(misPayment['title'], misPayment['id']) ??
                {};
        if (gotPayment.isNotEmpty) {
          Category? cat =
              await categoryDao.findCategoryById(gotPayment['category']);
          Account? acc =
              await accountDao.findCategoryById(misPayment['account']);
          final updatedMap = {
            "id": misPayment['id'],
            "title": misPayment['title'],
            "description": misPayment['description'],
            "account": acc!.toJson(),
            "category": cat!.toJson(),
            "amount": misPayment['account'].toDouble(),
            "type": misPayment['type'],
            "datetime": misPayment['datetime'],
            "autoCategorizationEnabled":
                misPayment['autoCategorizationEnabled'] == 1 ? true : false
          };
          await upsert(
            Payment.fromJson(updatedMap),
          );
          count++;
        }
      }
    }
    return count;
  }

  Future<int> categorizeUsingRules() async {
    CategoryDao categoryDao = CategoryDao();
    AccountDao accountDao = AccountDao();
    final db = await getDBInstance();
    List<String> titles = [
      "Toll charges",
      "Motors",
      "Food",
      "Swiggy",
      "Zomato",
      "Bistro",
      "Restaurant",
      "pharmacy",
      "Diagnostics",
      "BookMyShow"
    ];


    Map<String, dynamic> mapOfCategory =
        SharedPreferncesHelper.getListOfCategoryRules();
    List<String> getUserRules = SharedPreferncesHelper.getListOfUserRules();
    titles.addAll(getUserRules);

// Get User Defined Rules using below line
// List userRules = await getUserRules();
// titles.addAll(userRules);

    String placeholders =
        List.generate(titles.length, (index) => '?').join(',');

    final upperTitles = titles.map((title) => title.toUpperCase()).toList();

    String whereClause = upperTitles.map((title) => 'UPPER(title) LIKE ?').join(' OR ');

    List<String> whereArgs = upperTitles.map((title) => '%$title%').toList();
    whereArgs.add('10');

    final List<Map<String, dynamic>> maps = await db.query(
      'payments',
      where: '($whereClause) AND category = ?',
      whereArgs: whereArgs,
    );

    int count = 0;

    for (Map<String, dynamic> payment in maps) {
      String title = payment['title'].toLowerCase();
      print(payment);
      //Transportation Category
      if (title.contains("toll charges") || title.contains("motors")) {
        Category? category = await categoryDao.findCategoryById(2);
        Account? account =
            await accountDao.findCategoryById(payment['account']);
        final updatedMap = {
          "id": payment['id'],
          "title": payment['title'],
          "description": payment['description'],
          "account": account!.toJson(),
          "category": category!.toJson(),
          "amount": payment['amount'].toDouble(),
          "type": payment['type'],
          "datetime": payment['datetime'],
          "autoCategorizationEnabled":
              payment['autoCategorizationEnabled'] == 1 ? true : false
        };
        print(updatedMap);
        await upsert(
          Payment.fromJson(updatedMap),
        );
        count++;
      }

      //Food Category
      else if (title.contains("food") ||
          title.contains("swiggy") ||
          title.contains("zomato") ||
          title.contains("bistro") ||
          title.contains("restaurant")) {
        Category? category = await categoryDao.findCategoryById(3);
        Account? account =
            await accountDao.findCategoryById(payment['account']);
        final updatedMap = {
          "id": payment['id'],
          "title": payment['title'],
          "description": payment['description'],
          "account": account!.toJson(),
          "category": category!.toJson(),
          "amount": payment['account'].toDouble(),
          "type": payment['type'],
          "datetime": payment['datetime'],
          "autoCategorizationEnabled":
              payment['autoCategorizationEnabled'] == 1 ? true : false
        };
        await upsert(
          Payment.fromJson(updatedMap),
        );
        count++;
      }

      //Medical and Healthcare Category
      else if (title.contains("pharmacy") || title.contains("diagnostics")) {
        Category? category = await categoryDao.findCategoryById(6);
        Account? account =
            await accountDao.findCategoryById(payment['account']);
        final updatedMap = {
          "id": payment['id'],
          "title": payment['title'],
          "description": payment['description'],
          "account": account!.toJson(),
          "category": category!.toJson(),
          "amount": payment['account'].toDouble(),
          "type": payment['type'],
          "datetime": payment['datetime'],
          "autoCategorizationEnabled":
              payment['autoCategorizationEnabled'] == 1 ? true : false
        };
        await upsert(
          Payment.fromJson(updatedMap),
        );
        count++;
      } else if (title.contains("bookmyshow")) {
        Category? category = await categoryDao.findCategoryById(9);
        Account? account =
            await accountDao.findCategoryById(payment['account']);
        final updatedMap = {
          "id": payment['id'],
          "title": payment['title'],
          "description": payment['description'],
          "account": account!.toJson(),
          "category": category!.toJson(),
          "amount": payment['account'].toDouble(),
          "type": payment['type'],
          "datetime": payment['datetime'],
          "autoCategorizationEnabled":
              payment['autoCategorizationEnabled'] == 1 ? true : false
        };
        await upsert(
          Payment.fromJson(updatedMap),
        );
        count++;
      } else if (mapOfCategory.containsKey(title)) {
        int categoryInt = mapOfCategory[title];
        Category? category = await categoryDao.findCategoryById(categoryInt);
        Account? account =
            await accountDao.findCategoryById(payment['account']);
        final updatedMap = {
          "id": payment['id'],
          "title": payment['title'],
          "description": payment['description'],
          "account": account!.toJson(),
          "category": category!.toJson(),
          "amount": payment['account'].toDouble(),
          "type": payment['type'],
          "datetime": payment['datetime'],
          "autoCategorizationEnabled":
              payment['autoCategorizationEnabled'] == 1 ? true : false
        };
        await upsert(
          Payment.fromJson(updatedMap),
        );
        count++;
      }
    }

    return count;
  }

  Future<List<Payment>> findByTags({
    DateTimeRange? range,
    required List<int> tagIds,
    PaymentType? type,
    Category? category,
    Account? account,
  }) async {
    final db = await getDBInstance();
    String where = "1=1 "; // Base condition to simplify concatenation
    final whereArgs = <dynamic>[];

    // Add tag-based filtering
    if (tagIds.isNotEmpty) {
      where +=
      "AND id IN (SELECT payment_id FROM payment_tags WHERE tag_id IN (${tagIds.join(',')})) ";
    }

    // Add range filtering
    if (range != null) {
      where +=
      "AND datetime BETWEEN ? AND ? ";
      whereArgs.add(DateFormat('yyyy-MM-dd kk:mm:ss').format(range.start));
      whereArgs.add(DateFormat('yyyy-MM-dd kk:mm:ss').format(
          range.end.add(const Duration(days: 1)))); // Include the end date
    }

    // Add account filtering
    if (account != null) {
      where += "AND account = ? ";
      whereArgs.add(account.id);
    }

    // Add category filtering
    if (category != null) {
      where += "AND category = ? ";
      whereArgs.add(category.id);
    }

    // Add type filtering
    if (type != null) {
      where += "AND type = ? ";
      whereArgs.add(type == PaymentType.credit ? "CR" : "DR");
    }

    // Fetch categories and accounts for mapping
    List<Category> categories = await CategoryDao().find();
    List<Account> accounts = await AccountDao().find();

    // Execute the query
    final rows = await db.query(
      "payments",
      where: where,
      whereArgs: whereArgs,
      orderBy: "datetime DESC, id DESC",
    );

    // Map results to Payment objects
    List<Payment> payments = rows.map((row) {
      Map<String, dynamic> payment = Map<String, dynamic>.from(row);
      Account account = accounts.firstWhere((a) => a.id == payment["account"]);
      Category category =
      categories.firstWhere((c) => c.id == payment["category"]);
      payment["category"] = category.toJson();
      payment["account"] = account.toJson();
      payment['autoCategorizationEnabled'] =
      payment['autoCategorizationEnabled'] == 0 ? false : true;
      return Payment.fromJson(payment);
    }).toList();

    return payments;
  }

  Future<List<Map<String, dynamic>>> fetchTagsForPayment(int? paymentId) async {
    final db = await getDBInstance();

    // Query to fetch tag details for the given payment ID
    final rows = await db.rawQuery(
      '''
    SELECT tags.id, tags.name
    FROM tags
    INNER JOIN payment_tags ON tags.id = payment_tags.tag_id
    WHERE payment_tags.payment_id = ?
    ''',
      [paymentId],
    );

    return rows; // Returning a list of maps with tag details
  }



}
