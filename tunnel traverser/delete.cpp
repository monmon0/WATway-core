#include <string>
#include <iostream>
#include <vector>
#include <unordered_set>
#include "paths.hpp"
#include "sqlite/sqlite3.h"
const char* dbname = "test.db";
void error_invalid() {
    std::cerr << "Invalid query\n";
    exit(0);
}
void error() {
    std::cerr << "Tunnel does not exist\n";
    exit(0);
}
int main() {
    Database db;
    db.init(dbname);
    std::string st, ed;
    std::cout << "Enter start location\n";
    getline(std::cin, st);
    std::cout << "Enter the finish location\n";
    getline(std::cin, ed);
    // we now need to get the db names from the BUILDING_EXITS db if they exist
    std::string st_dbname, ed_dbname;
    sqlite3_stmt *stmt;
    std::string sql = "SELECT * FROM BUILDING_EXITS WHERE EXIT=\'" + st + "\';";
    const char *print_sql = sql.c_str();
    if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
        error_invalid();
    }
    if (sqlite3_step(stmt) != SQLITE_ROW) {
        error_invalid();
    }
    st_dbname = (char *)sqlite3_column_text(stmt, 2);

    sqlite3_stmt *stmt2;
    sql = "SELECT * FROM BUILDING_EXITS WHERE EXIT=\'" + ed + "\';";
    const char *print_sql2 = sql.c_str();
    if (sqlite3_prepare_v2(db.db, print_sql2, -1, &stmt2, 0) != SQLITE_OK) {
        error_invalid();
    }
    if (sqlite3_step(stmt2) != SQLITE_ROW) {
        error();
    }
    ed_dbname = (char *)sqlite3_column_text(stmt2, 2);

    // we now remove from building exits
    sql = "DELETE FROM TUNNELS WHERE START=\'" + st_dbname + "\' AND END=\'" + ed_dbname + "\';";
    const char* run_sql = sql.c_str();
    db.run_op(run_sql, "SUCCESSFULLY DELETED");
    sql = "DELETE FROM TUNNELS WHERE START=\'" + ed_dbname + "\' AND END=\'" + st_dbname + "\';";
    const char* run_sql2 = sql.c_str();
    db.run_op(run_sql2, "SUCCESSFULLY DELETED REVERSE");
}