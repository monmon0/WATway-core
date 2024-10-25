#include <string>
#include <cstdio>
#include <iostream>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include "paths.hpp"
#include "sqlite/sqlite3.h"
const int INF = 0x3f3f3f3f;
const char* dbname = "test.db";
int N, Q;
// stores connections between entrances/exits
std::unordered_map<std::string,std::vector<std::pair<std::string,int>>> tunnels;
// stores each building and the exits of that building
std::unordered_map<std::string,std::unordered_set<std::string>> buildings;
// stores the shortest paths between two entrances/exits, including dummy node
std::unordered_map<std::string,std::unordered_map<std::string,int>> shortest_distances;
// stores the next node in the path between start and finish, or -1 if start = finish
std::unordered_map<std::string,std::unordered_map<std::string,std::string>> nxt;
std::unordered_map<std::string,Image> images;
std::string get_id(const std::string& exit) {
    size_t pos = exit.find('-');
    return exit.substr(0, pos);
}
// ---------------------- PART 1 - PREPROCESSING ----------------------
int main() {
    freopen("input.txt", "r", stdin);
    //freopen("output.txt", "w", stdout);
    // --------------------------fake data -------------------------------
    // some fake data for images
    Image img;
    img.compress = "https://www.flickr.com/photos/takashi/16040691848";
    images["mc-1"] = img;
    img.compress = "https://uwaterloo.ca/computer-museum/";
    images["dc-2"] = img;
    img.compress = "https://uwaterloo.ca/library/dc-entrance-and-after";
    images["dc-1"] = img;
    std::cin >> N;
    for (int i = 1; i <= N; ++i) {
        std::string exit_from, exit_to;
        double distance;
        std::cin >> exit_from >> exit_to >> distance;
        // we get the building name by stripping the end of the exit code off
        std::string building_from = get_id(exit_from), building_to = get_id(exit_to);
        // from here we know all the building exits for each building
        buildings[building_from].insert(exit_from);
        buildings[building_to].insert(exit_to);
        // add bidirectional edges
        tunnels[exit_from].emplace_back(exit_to, distance);
        tunnels[exit_to].emplace_back(exit_from, distance);
    }
    // finds shortest paths
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
    // -------------------------- init database -------------------------
    Database db;
    db.init(dbname);
    /*
    // create tunnel table----------------------------------------------------------------------------------
    std::vector<Database::TableElement> tnl;
    Database::TableElement start = {"START", "VARCHAR", 50, true, true};
    Database::TableElement end = {"END", "VARCHAR", 50, true, true};
    Database::TableElement distance = {"DIST", "INT", 0, true, false};
    tnl.emplace_back(start); tnl.emplace_back(end); tnl.emplace_back(distance);
    std::string table_name = "TUNNELS";
    db.create_table(table_name, tnl);
    // create building table--------------------------------------------------------------------------------
    std::vector<Database::TableElement> bdg;
    Database::TableElement exit = {"EXIT", "VARCHAR", 50, true, true};
    Database::TableElement build = {"BUILDING", "VARCHAR", 50, true, false};
    bdg.emplace_back(exit); bdg.emplace_back(build);
    table_name = "BUILDING_EXITS";
    db.create_table(table_name, bdg);
    // create shortest distances table-----------------------------------------------------------------------
    std::vector<Database::TableElement> shortdist;
    // using start, end, distance elements as defined above
    shortdist.emplace_back(start); shortdist.emplace_back(end); shortdist.emplace_back(distance);
    table_name = "SHORTEST_DISTANCES";
    db.create_table(table_name, shortdist);
    // create path retrival table----------------------------------------------------------------------------
    std::vector<Database::TableElement> path_retrieval;
    // using start, end as defined above
    Database::TableElement next = {"NEXT", "VARCHAR", 50, false, false};
    path_retrieval.emplace_back(start); path_retrieval.emplace_back(end); path_retrieval.emplace_back(next);
    table_name = "PATH_RETRIEVAL";
    db.create_table(table_name, path_retrieval);

    std::vector<Database::TableElement> bcount;
    Database::TableElement bname = {"BUILDING_NAME", "VARCHAR", 50, true, true};
    Database::TableElement count = {"COUNT", "INT", 0, true, false};
    bcount.emplace_back(bname); bcount.emplace_back(count);
    std::string table_name = "CONNECTION_COUNT";
    db.create_table(table_name, bcount);
     */

    // insertion into table
    Database::Row tn1 = {"START","MC-SLC tunnel, MC side"};
    Database::Row tn2 = {"END", "DC-MC tunnel, MC side"};
    Database::Row tn3 = {"DIST", std::to_string(45)};
    std::vector<Database::Row> tn;
    tn.emplace_back(tn1); tn.emplace_back(tn2); tn.emplace_back(tn3);
    db.insert_into("TUNNELS", tn);

    std::vector<Edge> result;

    sqlite3_stmt* stmt;
    if (sqlite3_prepare_v2(db.db, "SELECT * FROM TUNNELS", -1, &stmt, 0) == SQLITE_OK) {
        printf("QUERY OK\n");
    }
    //std::cout << sqlite3_column_int(stmt, 0);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        Edge e;
        e.start = (char *)sqlite3_column_text(stmt, 0);
        e.finish = (char *)sqlite3_column_text(stmt, 1);
        e.distance = sqlite3_column_int(stmt, 2);
        result.emplace_back(e);
    }
    for (auto& str : result) {
        std::cout << str.start << " " << str.finish << " " << str.distance << "\n";
    }
    std::cout << "\n";

    // make images table later once data type figured out

    // delete tables
    /*
    db.delete_table("TUNNELS");
    db.delete_table("BUILDING_EXITS");
    db.delete_table("SHORTEST_DISTANCES");
    db.delete_table("PATH_RETRIEVAL");
     */
}