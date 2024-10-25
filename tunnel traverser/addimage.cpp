#include <string>
#include <cstdio>
#include <iostream>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include "paths.hpp"
#include "sqlite/sqlite3.h"
const char* dbname = "test.db";
int main() {
    Database db;
    db.init(dbname);
    std::string exit, image_url;
    std::cout << "Enter exit:\n";
    getline(std::cin, exit);
    std::cout << "Enter image url:\n";
    std::cin >> image_url;
    // set up query
    std::string sql = "UPDATE BUILDING_EXITS SET IMAGE=\'" + image_url + "\' WHERE EXIT =\'" + exit + "\';";
    const char* print_sql = sql.c_str();
    // if the tunnel doesn't exist this message will still be shown
    db.run_op(print_sql, "Successfully updated image");
}