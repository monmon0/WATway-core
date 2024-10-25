#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include "paths.hpp"
#include "sqlite/sqlite3.h"
const char* db_name = "test.db";
// given a start location and end location as input
// return a json file format as output with the path information

// we first focus on getting the path
// this assumes that the path exists, which may not be true in practice
void init_error() {
    std::cout << "Invalid query\n";
    exit(0);
}
void error() {
    std::cout << "Path/starting locations don't exist\n";
    exit(0);
}
Path retrieve_path(const Database& db, std::string start, const std::string& end) {
    std::string cur = start;
    Path ret;

    // todo: implement path retrieval to tell us when the path is incomplete, we will return accordingly

    while (cur != "-1") {
        // we should query current to see if there is a picture of it
        sqlite3_stmt* img_stmt;
        std::string img_sql = "SELECT * FROM BUILDING_EXITS WHERE DB_NAME=\'" + cur + "\';";
        const char* print_img_sql = img_sql.c_str();
        if (sqlite3_prepare_v2(db.db, print_img_sql, -1, &img_stmt, 0) != SQLITE_OK) {
            init_error();
        }
        sqlite3_step(img_stmt);
        if (sqlite3_column_type(img_stmt, 3) != SQLITE_NULL) {
            Image img;
            img.compress = (char *)sqlite3_column_text(img_stmt, 3);
            sqlite3_stmt* cur_stmt;
            std::string cur_sql = "SELECT * FROM BUILDING_EXITS WHERE DB_NAME=\'" + cur + "\';";
            const char* print_cur_sql = cur_sql.c_str();
            if (sqlite3_prepare_v2(db.db, print_cur_sql, -1, &cur_stmt, 0) != SQLITE_OK) {
                init_error();
            }
            sqlite3_step(cur_stmt);
            ret.images.insert({(char *)sqlite3_column_text(cur_stmt, 0), img});
        }
        // we now query for the next element
        sqlite3_stmt* stmt;
        std::string sql = "SELECT * FROM PATH_RETRIEVAL WHERE START=\'" + cur + "\' AND END=\'" + end + "\';";
        const char* print_sql = sql.c_str();
        if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
            init_error();
        }
        if (sqlite3_step(stmt) != SQLITE_ROW) {
            error();
        }
        std::string next = (char *)sqlite3_column_text(stmt, 2);
        // we can add this path
        if (next != "-1") {
            Edge e;

            sqlite3_stmt* start_stmt;
            std::string start_sql = "SELECT * FROM BUILDING_EXITS WHERE DB_NAME=\'" + cur + "\';";
            const char* print_start_sql = start_sql.c_str();
            if (sqlite3_prepare_v2(db.db, print_start_sql, -1, &start_stmt, 0) != SQLITE_OK) {
                init_error();
            }
            sqlite3_step(start_stmt);
            e.start = (char *)sqlite3_column_text(start_stmt, 0);

            sqlite3_stmt* end_stmt;
            std::string end_sql = "SELECT * FROM BUILDING_EXITS WHERE DB_NAME=\'" + next + "\';";
            const char* print_end_sql = end_sql.c_str();
            if (sqlite3_prepare_v2(db.db, print_end_sql, -1, &end_stmt, 0) != SQLITE_OK) {
                init_error();
            }
            sqlite3_step(end_stmt);
            e.finish = (char *)sqlite3_column_text(end_stmt, 0);
            // it is guaranteed that the edge exists
            sqlite3_stmt* dist_stmt;
            std::string dist_sql = "SELECT * FROM TUNNELS WHERE START=\'" + cur + "\' AND END=\'" + next + "\';";
            const char* print_dist_sql = dist_sql.c_str();
            if (sqlite3_prepare_v2(db.db, print_dist_sql, -1, &dist_stmt, 0) != SQLITE_OK) {
                init_error();
            }
            sqlite3_step(dist_stmt);
            e.distance = sqlite3_column_int(dist_stmt, 2);
            // add to the return
            ret.edges.emplace_back(e);
        }
        // we check if the next element is -1 or not, add an edge if not
        // we will take the next one and set it to the current
        cur = next;
    }
    // potential check here to see if it is good
    return ret;
}
int main() {
    Database db;
    db.init(db_name);
    Input inp;
    std::cout << "Enter the start location: \n";
    std::getline(std::cin, inp.src);
    std::cout << "Enter the ending location: \n";
    std::getline(std::cin, inp.dest);
    std::string st_dbname, ed_dbname;
    // get the start name of the location
    sqlite3_stmt* stmt;
    std::string sql = "SELECT * FROM BUILDING_EXITS WHERE EXIT=\'" + inp.src + "\';";
    const char* print_sql = sql.c_str();
    if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
        init_error();
    }
    if (sqlite3_step(stmt) != SQLITE_ROW) {
        error();
    }
    st_dbname = (char *) sqlite3_column_text(stmt, 2);
    // get the end name of the location
    sqlite3_stmt* stmt2;
    std::string sql2 = "SELECT * FROM BUILDING_EXITS WHERE EXIT=\'" + inp.dest + "\';";
    const char* print_sql2 = sql2.c_str();
    if (sqlite3_prepare_v2(db.db, print_sql2, -1, &stmt2, 0) != SQLITE_OK) {
        init_error();
    }
    if (sqlite3_step(stmt2) != SQLITE_ROW) {
        error();
    }
    ed_dbname = (char *) sqlite3_column_text(stmt2, 2);
    Path path = retrieve_path(db, st_dbname, ed_dbname);
    std::cout << "Path: \n";
    for (Edge &e : path.edges) {
        std::cout << e.start << " -> " << e.finish << ", dist: " << e.distance << "\n";
    }
    std::cout << "Images: \n";
    for (std::pair<std::string,Image> p : path.images) {
        std::cout << p.first << ": " << p.second.compress << "\n";
    }
}