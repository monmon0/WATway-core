//
// This program, when run, will allow user to enter input to add to the database
// specify database name by modifying const char* dbname
// user enters tunnel information in the form
// tunnel start entrance name
// bulding of tunnel start entrance
// tunnel end name
// building of tunnel end name
// tunnel distance
//
// program will read the input, and then add to database, informing user about
// whether or not the add was successful.
#include <string>
#include <sstream>
#include <cstdio>
#include <iostream>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include "paths.hpp"
#include "sqlite/sqlite3.h"
const int INF = 0x3f3f3f3f;
const char* dbname = "test.db";
const std::string table_name = "BUILDING_EXITS";
const std::string column_check = "EXIT";

// we need a map that stores conversion between the location irl
// and how the machine reads it
// we also need the opposite to convert it back
/*
void check_response(Edge& inp, std::string& start_building, std::string& end_building) {
    // have user verify entered information
    std::string response;
    std::cout << "Verify starting location name: " << inp.start << "\nCorrect? (y/n)";
    std::cin >> response;
    if (response != "y") { std::cout << "Insertion terminated."; exit(0); }
    std::cout << "Verify starting building name: " << start_building << "\nCorrect? (y/n)";
    std::cin >> response;
    if (response != "y") { std::cout << "Insertion terminated."; exit(0); }
    std::cout << "Verify ending location name: " << inp.finish << "\nCorrect? (y/n)";
    std::cin >> response;
    if (response != "y") { std::cout << "Insertion terminated."; exit(0); }
    std::cout << "Verify ending building name: " << end_building << "\nCorrect? (y/n)";
    std::cin >> response;
    if (response != "y") { std::cout << "Insertion terminated."; exit(0); }
}
 */
std::vector<std::string> adv_tokenizer(std::string s, char del) {
    std::stringstream ss(s);
    std::string word;
    std::vector<std::string> ret;
    while (!ss.eof()) {
        getline(ss, word, del);
        ret.emplace_back(word);
    }
    return ret;
}
int main() {
    freopen("add.in", "r", stdin);
    freopen("add.out", "w", stdout);
    std::string raw_input;
    // we now check to see if we need to add new building codes
    Database db;
    db.init(dbname);
    while (getline(std::cin, raw_input)) {
        Edge inp;
        std::string start_building, end_building;
        std::cout << "Enter addition query: " << std::endl;
        std::vector<std::string> input_vector = adv_tokenizer(raw_input, '\t');

        inp.start = input_vector[0];
        start_building = input_vector[1];
        inp.finish = input_vector[2];
        end_building = input_vector[3];
        inp.distance = std::stoi(input_vector[4]);
        //check_response(inp, start_building, end_building);

        std::string start_dbname, end_dbname;

        // slightly redundant checking code but i am too lazy to make a function

        // see if the current entrance exists already
        std::vector<std::vector<std::string>> begin_vector = db.check_existence(table_name, column_check, inp.start, 3);
        if (begin_vector.empty()) {
            // current entrance does not exist, we need to add
            // we now query for the number of exits already
            sqlite3_stmt *stmt;
            std::string sql = "SELECT * FROM CONNECTION_COUNT WHERE BUILDING_NAME=\'" + start_building + "\';";
            const char *print_sql = sql.c_str();
            if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
                printf("QUERY FAILED\n");
                std::cout << sql << "\n";
                exit(1);
            }
            sqlite3_step(stmt);
            int num_exits = sqlite3_column_int(stmt, 1);
            // we increase that number by 1, so update table
            sql = "UPDATE CONNECTION_COUNT SET COUNT = " + std::to_string(num_exits + 1) + " WHERE BUILDING_NAME=\'" +
                  start_building + "\';";
            print_sql = sql.c_str();
            db.run_op(print_sql, "Updated CONNECTION_COUNT Successfully");
            // we can now access the start db_name
            start_dbname = start_building + "-" + std::to_string(num_exits);
            std::vector<Database::Row> q = {{"EXIT",     inp.start},
                                            {"BUILDING", start_building},
                                            {"DB_NAME",  start_dbname}};
            // now we have to insert the current exit into BUILDING_EXITS, remember to 0 index
            db.insert_into(table_name, q);
        } else {
            // current entrance does exist, we need to find it
            std::string sql = "SELECT * FROM BUILDING_EXITS WHERE EXIT = \'" + inp.start + "\';";
            const char *print_sql = sql.c_str();
            sqlite3_stmt *stmt;
            if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
                printf("QUERY FAILED\n");
                exit(1);
            }
            sqlite3_step(stmt);
            // we can now get the name
            start_dbname = (char *) sqlite3_column_text(stmt, 2);
        }

        // we check for ending location as well
        std::vector<std::vector<std::string>> end_vector = db.check_existence(table_name, column_check, inp.finish, 3);
        if (end_vector.empty()) {
            // current exit does not exist, we need to add
            // we now query for the number of exits already
            sqlite3_stmt *stmt;
            std::string sql = "SELECT * FROM CONNECTION_COUNT WHERE BUILDING_NAME=\'" + end_building + "\';";
            const char *print_sql = sql.c_str();
            if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
                printf("QUERY FAILED\n");
                std::cout << sql << "\n";
                exit(1);
            }
            sqlite3_step(stmt);
            int num_exits = sqlite3_column_int(stmt, 1);
            // we increase that number by 1, so update table
            sql = "UPDATE CONNECTION_COUNT SET COUNT = " + std::to_string(num_exits + 1) + " WHERE BUILDING_NAME=\'" +
                  end_building + "\';";
            print_sql = sql.c_str();
            db.run_op(print_sql, "Updated CONNECTION_COUNT Successfully");
            // we can now access the end db_name
            end_dbname = end_building + "-" + std::to_string(num_exits);
            std::vector<Database::Row> q = {{"EXIT",     inp.finish},
                                            {"BUILDING", end_building},
                                            {"DB_NAME",  end_dbname}};
            // now we have to insert the current exit into BUILDING_EXITS, remember to 0 index
            db.insert_into(table_name, q);
        } else {
            // current entrance does exist, we need to find it
            std::string sql = "SELECT * FROM BUILDING_EXITS WHERE EXIT = \'" + inp.finish + "\';";
            const char *print_sql = sql.c_str();
            sqlite3_stmt *stmt;
            if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
                printf("QUERY FAILED\n");
                exit(1);
            }
            sqlite3_step(stmt);
            // we can now get the name
            end_dbname = (char *) sqlite3_column_text(stmt, 2);
        }

        // we now add to the tunnels database and link distance
        // since we assign start and end lexicographcially according to descirptors, we can simply search and add

        sqlite3_stmt *stmt;
        std::string sql =
                "SELECT * FROM TUNNELS WHERE START=\'" + start_dbname + "\'" + " AND " + "END=\'" + end_dbname + "\';";
        const char *print_sql = sql.c_str();
        if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
            printf("QUERY FAILED\n");
            std::cout << sql << "\n";
            exit(1);
        }
        // does not exist, so we input
        if (sqlite3_step(stmt) != SQLITE_ROW) {
            std::vector<Database::Row> r;
            r.push_back({"START", start_dbname});
            r.push_back({"END", end_dbname});
            r.push_back({"DIST", std::to_string(inp.distance)});
            db.insert_into("TUNNELS", r);
            // we need
            std::vector<Database::Row> r2;
            r2.push_back({"START", end_dbname});
            r2.push_back({"END", start_dbname});
            r2.push_back({"DIST", std::to_string(inp.distance)});
            db.insert_into("TUNNELS", r2);
            std::cout << "new connection created, inserted into tunnels.\n";
        }
        std::cout << "addition query complete.\n";
    }
}