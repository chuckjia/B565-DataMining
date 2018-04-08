/*
 * Testing.h
 *
 *  Created on: Apr 4, 2018
 *      Author: chuckjia
 */

#ifndef TESTING_H_
#define TESTING_H_

#include <vector>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <limits.h>

#include "TwoDimArray.h"

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

void printToConsole(vector<int> &v) {
	int n = v.size();
	for (int i = 0; i < n; ++i)
		printf("Element %d: %d\n", i, v[i]);
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


#endif /* TESTING_H_ */
