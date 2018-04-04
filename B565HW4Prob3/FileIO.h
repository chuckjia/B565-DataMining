/*
 * FileIO.h
 *
 *  Created on: Apr 1, 2018
 *      Author: chuckjia
 */

#ifndef FILEIO_H_
#define FILEIO_H_

#include <vector>
#include "TwoDimArray.h"
#include "time.h"
#include "assert.h"
#include "limits.h"

/* ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
 * Testing
 * ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== */

void tm() {
	printf("\n>> Program passed here.\n\n");
}

void tm(int i) {
	printf("\n>> Index = %d\n", i);
}

void tm(double i) {
	printf("\n>> Index = %f\n", i);
}

void tm(int i, string s) {
	printf("\n>> %s = %d\n\n", s.c_str(), i);
}

void tm(double i, string s) {
	printf("\n>> %s = %f\n\n", s.c_str(), i);
}

void printToFile(TwoDimArray<int> &input, string filename) {
	int nrow = input.nrow(), ncol = input.ncol();

	FILE *f = fopen(filename.c_str(), "wb");
	for (int i = 0; i < nrow; ++i) {
		for (int j = 0; j < ncol; ++j)
			fprintf(f, "%d,", input[i][j]);
		fprintf(f, "\n");
	}
	fclose(f);
}

void printToConsole(vector<double> &v) {
	int n = v.size();
	for (int i = 0; i < n; ++i)
		printf("Element %d: %1.2f\n", i + 1, v[i]);
}

void printToConsole(TwoDimArray<int> &arr) {
	int nrow = arr.nrow(), ncol = arr.ncol();
	for (int i = 0; i < nrow; ++i) {
		for (int j = 0; j < ncol; ++j)
			printf("%d ", arr[i][j]);
		printf("\n");
	}
}

void printToConsole(TwoDimArray<bool> &arr) {
	int nrow = arr.nrow(), ncol = arr.ncol();
	for (int i = 0; i < nrow; ++i) {
		for (int j = 0; j < ncol; ++j)
			printf("%d ", arr[i][j]);
		printf("\n");
	}
}

void printToConsole(int k, int* arr) {
	printf("[ ");
	int last = k - 1;
	for (int i = 0; i < last; ++i)
		printf("%d, ", arr[i]);
	printf("%d ]\n", arr[last]);
}

void printToConsole(int k, bool* arr) {
	printf("[ ");
	int last = k - 1;
	for (int i = 0; i < last; ++i)
		printf("%d, ", arr[i]);
	printf("%d ]\n", arr[last]);
}

/* ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
 * 100K Data Set File I/O
 * ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== */

// Count number of lines in source file from the 100K data set
int getNumLine(string filename) {
	FILE *f = fopen(filename.c_str(), "r");
	if (f == NULL) {
		perror("File read failed in the function readCSV");
		exit(2);
	}
	int num_line = 0;
	while (true) {
		int a, b, c;
		int res = fscanf(f, "%d\t%d\t%d\t%*d", &a, &b, &c);
		if (res != 3) break;
		++num_line;
	}
	fclose(f);
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

// Count the number of lines in CSV file from the 10M data set
int getNumLine2(string filename) {
	FILE *f = fopen(filename.c_str(), "r");
	int num_line = 0;
	while (true) {
		int a, b;
		double c;
		int res = fscanf(f, "%d::%d::%lf::%*d", &a, &b, &c);
		if (res != 3) break;
		++num_line;
	}
	fclose(f);
	return num_line;
}

TwoDimArray<int> readCSV2(string filename, int num_line) {
	clock_t start = clock();

	TwoDimArray<int> ans(num_line, 3);
	FILE *f = fopen(filename.c_str(), "r");

	for (int i = 0; i < num_line; ++i) {
		int a, b;
		double c;
		fscanf(f, "%d::%d::%lf::%*d", &a, &b, &c);
		ans[i][0] = a;
		ans[i][1] = b;
		ans[i][2] = (int) (2 * c);
	}

	fclose(f);
	printf("\n>> Time used on reading CSV file = %1.6f seconds.\n", (double)(clock() - start) / CLOCKS_PER_SEC);
	return ans;
}

TwoDimArray<int> readCSV2(string filename) {
	return readCSV2(filename, getNumLine2(filename));
}

vector<int> renameUserID(TwoDimArray<int> raw_data) {
	int nrow = raw_data.nrow(), maxID = 0;
	for (int i = 0; i < nrow; ++i) {
		int id = raw_data[i][0];
		maxID = id > maxID ? id : maxID;
	}
	printf("Max ID = %d\n", maxID);

	vector<int> ans(maxID, -1);
	int orig_id = 0, new_id = -1;
	for (int i = 0; i < nrow; ++i) {
		int id = raw_data[i][0];
		if (id > orig_id) {
			orig_id = id;
			++new_id;
			ans[id] = new_id;
		}
	}
	return ans;
}

void renameMovieID(string filename) {
	FILE *f = fopen(filename.c_str(), "r");
	int num_line = 0;
	while (true) {
		int a;
		int res = fscanf(f, "%d::%*[^\n]", &a);
		if (res != 1) break;
		++num_line;
	}
	printf("%d", num_line);
	fclose(f);
}

#endif /* FILEIO_H_ */
