#include <string>
#include <iostream>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include "paths.hpp"
#include "sqlite/sqlite3.h"
const int INF = 0x3f3f3f3f;
const char* dbname = "test.db";
// stores connections between entrances/exits
std::unordered_map<std::string,std::vector<std::pair<std::string,int>>> tunnels;
// stores each building and the exits of that building
std::unordered_map<std::string,std::unordered_set<std::string>> buildings;
// stores the shortest paths between two entrances/exits
std::unordered_map<std::string,std::unordered_map<std::string,int>> shortest_distances;
// stores the next node in the path between start and finish, or -1 if start = finish
std::unordered_map<std::string,std::unordered_map<std::string,std::string>> nxt;
std::unordered_map<std::string,Image> images;
void error_invalid() {
    std::cerr << "Invalid query\n";
    exit(0);
}
std::string get_id(const std::string& exit) {
    size_t pos = exit.find('-');
    return exit.substr(0, pos);
}
int main() {
    // initialize database
    Database db;
    db.init(dbname);
    // truncate the tables since we are reinitializing
    db.truncate_table("PATH_RETRIEVAL");
    db.truncate_table("SHORTEST_DISTANCES");
    // we now recreate the data in the tables
    // we do this by using the data in tunnels

    // we first acquire the data in tunnels
    sqlite3_stmt* stmt;
    std::string sql = "SELECT * FROM TUNNELS";
    const char* print_sql = sql.c_str();
    if (sqlite3_prepare_v2(db.db, print_sql, -1, &stmt, 0) != SQLITE_OK) {
        error_invalid();
    }
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        Edge e;
        e.start = (char *)sqlite3_column_text(stmt, 0);
        e.finish = (char *)sqlite3_column_text(stmt, 1);
        e.distance = sqlite3_column_int(stmt, 2);

        std::string building_from = get_id(e.start);
        std::string building_to = get_id(e.finish);

        buildings[building_from].insert(e.start);
        buildings[building_to].insert(e.finish);
        // when we read the reverse path will be inserted
        tunnels[e.start].emplace_back(e.finish, e.distance);
    }
    //--------------------------------------------RUN FLOYD-WARSHALL ALGORITHM-------------------------------------------------
    for (const auto& from : tunnels) {
        for (const auto& to : tunnels) {
            // if we encounter ourselves
            if (from.first == to.first) {
                shortest_distances[from.first][to.first] = 0;
                nxt[from.first][to.first] = "-1";
            }
            else shortest_distances[from.first][to.first] = INF;
        }
    }
    // now go through each connection and set to non-infinity value
    for (const auto& from : tunnels) {
        for (const auto& edges : from.second) {
            shortest_distances[from.first][edges.first] = edges.second;
            nxt[from.first][edges.first] = edges.first;
        }
    }
    for (const auto& k : tunnels) {
        for (const auto &i : tunnels) {
            for (const auto &j : tunnels) {
                if (shortest_distances[i.first][k.first] + shortest_distances[k.first][j.first]
                    < shortest_distances[i.first][j.first]) {
                    shortest_distances[i.first][j.first] = shortest_distances[i.first][k.first] + shortest_distances[k.first][j.first];
                    nxt[i.first][j.first] = nxt[i.first][k.first];
                }
            }
        }
    }
    //--------------------------------------------------------------------------------------------------------------------
    // insert shortest distances back into database
    for (const auto& elem : shortest_distances) {
        for (const auto& ed : elem.second) {
            std::vector<Database::Row> tmp;
            Database::Row r1, r2, r3;
            r1.column_name = "START";
            r1.value = elem.first;
            tmp.push_back(r1);
            r2.column_name = "END";
            r2.value = ed.first;
            tmp.push_back(r2);
            r3.column_name = "DIST";
            r3.value = std::to_string(ed.second);
            tmp.push_back(r3);
            db.insert_into("SHORTEST_DISTANCES", tmp);
        }
    }
    // insert path retrieval information
    for (const auto& elem : nxt) {
        for (const auto& ed : elem.second) {
            std::vector<Database::Row> tmp;
            Database::Row r1, r2, r3;
            r1.column_name = "START";
            r1.value = elem.first;
            tmp.push_back(r1);
            r2.column_name = "END";
            r2.value = ed.first;
            tmp.push_back(r2);
            r3.column_name = "NEXT";
            r3.value = ed.second;
            tmp.push_back(r3);
            db.insert_into("PATH_RETRIEVAL", tmp);
        }
    }
    std::cout << "Reinitializing complete\n";
}