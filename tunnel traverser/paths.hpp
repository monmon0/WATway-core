#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include "sqlite/sqlite3.h"

// not really sure how this is to be implemented for now, currently string
class Image {
public:
    std::string compress;
};

// represents a single segment
class Edge {
public:
    std::string start; // in the form building-entrance#, which we can parse later
    std::string finish; // also in the form building-entrance#
    int distance; // distance represented
};

class Path {
public:
    std::vector<Edge> edges; // contain the bare minimum details
    std::unordered_map<std::string,Image> images; // ability to add images
    // extra stuff can be added if required
};


class Database {
public:
    sqlite3* db;
    std::unordered_set<std::string> var_length_dtypes =
            {"CHAR", "VARCHAR", "BINARY", "VARBINARY", "TEXT", "BLOB", "BIT",
             "TINYINT", "SMALLINT", "MEDIUMINT", "INT", "INTEGER", "BIGINT",
             "FLOAT"};
    class TableElement {
    public:
        std::string column_name, variable_type;
        int len; // length of variable if required
        bool not_null; // if true then add not_null
        bool primary_key;
    };
    class Row {
    public:
        std::string column_name, value;
    };
    static int callback(void* NotUsed, int argc, char** argv, char** azColName) {
        int i;
        for (i = 0; i < argc; i++) {
            printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
        }
        printf("\n");
        return 0;
    }
    void init(const char* dbname) {
        int rc;
        rc = sqlite3_open(dbname, &db);
        if (rc) {
            fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        }
        else {
            fprintf(stdout, "Opened database successfully\n");
        }
    }
    void run_op(const char* printsql, const std::string& success_message) const {
        int rc;
        char* zErrMsg = 0;
        rc = sqlite3_exec(db, printsql, callback, 0, &zErrMsg);
        if( rc != SQLITE_OK ){
            fprintf(stderr, "SQL error: %s\n", zErrMsg);
            //fprintf(stderr, "%s\n", printsql);
            sqlite3_free(zErrMsg);
        } else {
            std::cout << success_message << "\n";
        }
    }
    void create_table(std::string& table_name, std::vector<TableElement>& params) const {
        std::string sql;
        sql = "CREATE TABLE " + table_name + "(\n";
        std::vector<std::string> primary_keys;
        for (TableElement& te : params) {
            // if there is a parameter in the data type
            if (var_length_dtypes.count(te.variable_type)) {
                sql += te.column_name + " " + te.variable_type + "(" + std::to_string(te.len) + ")";
            } else {
                sql += te.column_name + " " + te.variable_type;
            }
            if (te.not_null) {
                sql += " NOT NULL";
            }
            if (te.primary_key) primary_keys.emplace_back(te.column_name);
            sql += ",\n";
        }
        // primary key should never be empty
        sql += "PRIMARY KEY (";
        for (int itr = 0; itr < primary_keys.size(); ++itr) {
            sql += primary_keys[itr];
            if (itr != primary_keys.size() - 1) {
                sql += ", ";
            }
        }
        sql += "));";
        // next step: make this whole thing a function
        // this will streamline things
        const char* printsql = sql.c_str();
        std::string succ = "Table " + table_name + " created successfully";
        run_op(printsql, succ);
    }
    void delete_table(std::string table_name) const {
        std::string sql = "DROP TABLE " + table_name + ";";
        const char* printsql = sql.c_str();
        std::string succ = "Table " + table_name + " deleted successfully";
        run_op(printsql, succ);
    }
    void insert_into(std::string table_name, std::vector<Row> row) const {
        std::string sql = "INSERT INTO " + table_name + " (";
        for (auto& element : row) {
            sql += element.column_name + ", ";
        }
        // get rid of the comma and space at the end
        sql.pop_back(); sql.pop_back();
        sql += ") ";
        sql += "VALUES (";
        for (auto& element : row) {
            sql += '\'' + element.value + '\'';
            sql += ", ";
        }
        sql.pop_back(); sql.pop_back(); // remove comma and space
        sql += ");";
        std::cout << sql << "\n";
        const char* printsql = sql.c_str();
        std::string succ = "Successfully inserted into " + table_name;
        run_op(printsql, succ);
    }
    //columnname --> the column we want to index by, entryname is the existence
    std::vector<std::vector<std::string>> check_existence(std::string table_name, std::string columnname, std::string entryname, int num_columns) const {
        std::string sql = "SELECT * FROM " + table_name + " WHERE " + columnname + "=\'" + entryname + "\';";
        const char* printsql = sql.c_str();
        std::string succ = "Successfully selected from " + table_name;
        sqlite3_stmt* stmt;
        if (sqlite3_prepare_v2(db, printsql, -1, &stmt, 0) != SQLITE_OK) {
            printf("QUERY FAILED\n");
            exit(1);
        }
        std::vector<std::vector<std::string>> retrieve;
        // this should only be run if we have a matching row
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            std::vector<std::string> tmp;
            for (int i = 0; i < num_columns; ++i) {
                tmp.emplace_back((char*)sqlite3_column_text(stmt, i));
            }
            retrieve.emplace_back(tmp);
        }
        return retrieve;
    }
    void truncate_table(std::string table_name) const {
        std::string sql = "DELETE FROM " + table_name + ";";
        const char* print_sql = sql.c_str();
        run_op(print_sql, "Cleared " + table_name + " successfully");
    }
};

// this should bascially be the raw input that the user selects
class Input {
public:
    std::string src; // starting point, building and closest entrance stored here
    std::string dest; // ending point, destination
    /*
    Path parse_query(Database& db) {
        Path path;
        double INF = 0x3f3f3f3f;
        // there is nowhere to go, return empty path
        if (src == dest) {
            return path;
        }
        std::string best_entrance = "-1";
        double best_distance = INF;
        for (const auto& exits: db.buildings[dest]) {
            if (db.shortest_distances[src][exits] < best_distance) {
                best_entrance = exits;
                best_distance = db.shortest_distances[src][exits];
            }
        }
        if (abs(best_distance - INF) < 1e-6) {
            return path; // no path, return empty path
        } else {
            std::string cur = src;
            while (db.nxt[cur][best_entrance] != "-1") {
                std::string next = db.nxt[cur][best_entrance];
                path.edges.push_back({cur, next, db.shortest_distances[cur][next]});
                // there exists an image of this tunnel
                if (db.images.find(cur) != db.images.end()) {
                    path.images.emplace_back(cur, db.images[cur]);
                }
                cur = db.nxt[cur][best_entrance];
            }
        }
        return path;
    }
     */
};