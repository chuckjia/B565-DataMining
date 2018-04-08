/*
 * FileIO.h
 *
 *  Created on: Apr 1, 2018
 *      Author: chuckjia
 */

#ifndef FILEIO_H_
#define FILEIO_H_
#include "Testing.h"

/* ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
 * 100K Data Set File I/O
 * ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== */

// Count number of lines in source file from the 100K data set
int getNumLine(string filename) {
	clock_t start = clock();
	FILE *f = fopen(filename.c_str(), "r");
	if (f == NULL) {
		perror("File read failed in the function getNumLine");
		exit(2);
	}
	int num_line = 0;
	while (true) {
		int res = fscanf(f, "%*d%*[^\n]");
		if (res != 0) break;
		++num_line;
	}
	fclose(f);
	printf("\n>> Time used on counting lines: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return num_line;
}

// Read data from CSV source file
// Output: a TwoDimArray with integer elements. 1st column is user ID, 2nd column is item ID, and 3rd column is
//         rating. Ratings are from {1, 2, 3, 4, 5}. Each row represents a data point
TwoDimArray<int> readCSV(string filename, int num_line) {
	// clock_t start = clock();

	TwoDimArray<int> ans(num_line, 3);
	FILE *f = fopen(filename.c_str(), "r");

	if (f == NULL) {
		perror("File read failed in the function readCSV");
		exit(2);
	}

	for (int i = 0; i < num_line; ++i) {
		int a, b, c;
		fscanf(f, "%d\t%d\t%d\t%*d", &a, &b, &c);
		ans[i][0] = a;
		ans[i][1] = b;
		ans[i][2] = c;
	}

	fclose(f);
	// printf("Time used on reading CSV file = %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return ans;
}

// Read CSV file with unknown number of rows
TwoDimArray<int> readCSV(string filename) {
	return readCSV(filename, getNumLine(filename));
}

/* ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
 * 10M Data Set File I/O
 * ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== */

TwoDimArray<int> readCSV2(string filename, int num_line) {
	clock_t start = clock();

	TwoDimArray<int> ans(num_line, 3);
	FILE *f = fopen(filename.c_str(), "r");
	if (f == NULL) {
		perror("File read failed in the function readCSV2");
		exit(2);
	}

	for (int i = 0; i < num_line; ++i) {
		int a, b;
		double c;
		fscanf(f, "%d::%d::%lf::%*d", &a, &b, &c);
		ans[i][0] = a;
		ans[i][1] = b;
		ans[i][2] = (int) (2 * c);
	}

	fclose(f);
	printf("\n>> Time used on reading CSV file (10M data set): %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return ans;
}

TwoDimArray<int> readCSV2(string filename) {
	return readCSV2(filename, getNumLine(filename));
}

/* ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
 * Create ID Maps and Map IDs
 * ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== */

/*
 * For 100K data sets
 */
vector<int> generateIdMap(int n) {
	vector<int> id_map(n + 1);
	for (int i = 0; i <= n; ++i)
		id_map[i] = i - 1;
	return id_map;
}

/*
 * For 10M data sets
 */

int maxIn1stCol(string filename) {
	clock_t start = clock();

	FILE *f = fopen(filename.c_str(), "r");
	if (f == NULL) {
		perror("File read failed in the function maxIn1stCol");
		exit(2);
	}
	int max_id = 0;
	while (true) {
		int id;
		int res = fscanf(f, "%d%*[^\n]", &id);
		if (res != 1) break;
		max_id = id > max_id ? id : max_id;
	}
	fclose(f);

	printf("\n>> Time used on finding max value in 1st column: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return max_id;
}

// Assume original IDs are all >= 1, all integers
vector<int> generateUserIdMap(string filename, int max_id) {
	clock_t start = clock();

	FILE *f = fopen(filename.c_str(), "r");
	if (f == NULL) {
		perror("File read failed in the function generateUserIdMap");
		exit(2);
	}

	vector<int> id_map(max_id + 1, -1);

	int new_id = -1, old_id = -1;
	while (true) {
		int id;
		int res = fscanf(f, "%d%*[^\n]", &id);
		if (res != 1) break;
		if (id != old_id) {
			++new_id;
			old_id = id;
			id_map[id] = new_id;
		}
	}

	fclose(f);
	printf("\n>> Time used on generating user id map: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return id_map;
}

vector<int> generateUserIdMap(string filename) {
	return generateUserIdMap(filename, maxIn1stCol(filename));
}

vector<int> generateItemIdMap(string movie_filename, int max_id) {
	clock_t start = clock();
	vector<int> itemid_map(max_id + 1, -1);

	FILE *f = fopen(movie_filename.c_str(), "r");
	if (f == NULL) {
		perror("File read failed in the function generateItemIdMap");
		exit(2);
	}

	int index = -1;
	while (true) {
		int itemid;
		int res = fscanf(f, "%d%*[^\n]", &itemid);
		if (res != 1) break;
		++index;
		itemid_map[itemid] = index;
	}
	fclose(f);

	printf("\n>> Time used on generating item id map: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return itemid_map;
}

vector<int> generateItemIdMap(string movie_filename) {
	return generateItemIdMap(movie_filename, maxIn1stCol(movie_filename));
}

vector<int> generateItemIdMap2(string movie_filename, int max_id) {
	clock_t start = clock();

	FILE *f = fopen(movie_filename.c_str(), "r");
	if (f == NULL) {
		perror("File read failed in the function generateItemIdMap");
		exit(2);
	}

	vector<int> itemid_map(max_id + 1, -1);

	int new_id = -1;
	while (true) {
		int id;
		int res = fscanf(f, "%*d::%d%*[^\n]", &id);
		if (res != 1) break;
		if (itemid_map[id] == -1) {
			++new_id;
			itemid_map[id] = new_id;
		}
	}

	fclose(f);

	printf("\n>> Time used on generating item id map: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return itemid_map;
}

/*
 * For both 100K and 10M data sets
 */

void mapId(TwoDimArray<int> &raw_data, vector<int> userid_map, vector<int> itemid_map) {
	int nrow = raw_data.nrow();
	for (int row = 0; row < nrow; ++row) {
		int user = raw_data[row][0], item = raw_data[row][1];
		raw_data[row][0] = userid_map[user];
		raw_data[row][1] = itemid_map[item];
	}
}

#endif /* FILEIO_H_ */
