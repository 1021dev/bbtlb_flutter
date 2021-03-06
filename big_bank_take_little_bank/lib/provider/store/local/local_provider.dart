

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'migrate/migrate.dart';
import 'migrate/migrate_v1.dart';

// https://pub.dev/packages/sqflite
class LocalProvider {
  ///Create api instance
  LocalProvider._private();

  static final LocalProvider instance = LocalProvider._private();

  ///Database instance
  Database database;

  ///Init database connection
  Future<Database> init({String databaseName}) async {
    if (database != null && database.isOpen) {
      database.close();
    }
    return database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        // Data types: https://www.sqlite.org/datatype3.html
        Migrate migrate;
        switch (version) {
          case 1:
            migrate = new MigrateV1();
            break;
        }

        // Create as new installation
        if (migrate != null) {
          var batch = db.batch();
          await migrate.create(batch);
          await batch.commit();
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        Migrate migrate;
        switch (newVersion) {
          case 1:
            migrate = new MigrateV1();
            break;
        }

        // Upgrade as a upgrade from old database
        if (migrate != null) {
          var batch = db.batch();
          await migrate.upgrade(batch);
          await batch.commit();
        }
      },
      onDowngrade: onDatabaseDowngradeDelete,
      version: 1,
    );
  }
}
