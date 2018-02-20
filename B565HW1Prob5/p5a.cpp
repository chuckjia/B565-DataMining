/*
 * p5a.cpp
 *
 * 	This file computes all the results for n = {100, 1000, 10000}, k = 1:100, and with 5 different
 * 	distance functions.
 *
 * 	This file uses the unit uniform random generator.
 *
 *  Created on: Feb 2, 2018
 *      Author: chuckjia
 */

#include <time.h>
#include <random>
#include "distfcn.h"

const double random_seed = 200;  // Random seed used in random number generators

// Calculate r(k) values for a specific pair of n and k with a distance function
double calc_r(int n, int k, double (*dist_fcn)(int, double[], double[])) {
	// Generate random numbers as data points
	std::default_random_engine generator(random_seed);
	std::uniform_real_distribution<double> distribution(0., 1.);
	// std::normal_distribution<double> distribution(0., 1.);
	double data_pts[n][k];
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < k; ++j)
			data_pts[i][j] = distribution(generator);

	// Find the max and min distances between data points
	double max_dist = (*dist_fcn)(k, data_pts[0], data_pts[1]), min_dist = max_dist;
	for (int i = 0; i < n - 1; ++i)
		for (int j = i + 1; j < n; ++j) {
			double distance = (*dist_fcn)(k, data_pts[i], data_pts[j]);
			if (distance > max_dist)
				max_dist = distance;
			else if (distance < min_dist)
				min_dist = distance;
		}

	return log10((max_dist - min_dist) / min_dist);
}

// Test the random generator
void test_random_generator() {
	int n = 10000;
	std::default_random_engine generator;
	std::normal_distribution<double> distribution(0., 1.);
	// std::uniform_real_distribution<double> distribution(0., 1.);
	FILE *f = fopen("test_random_generator.csv", "wb");
	for (int i = 0; i < n; ++i)
		fprintf(f, "%1.20e\n", distribution(generator));
	fclose(f);
}

// Test run time
void test_runtime() {
	clock_t start = clock();

	int n = 10000;
	double (*dist_fcn_ptr)(int, double[], double[]) = &euclidean_dist_squared;

	for (int k = 100; k <= 100; ++k) {
		if (k % 10 == 0) printf("  - Progress: %d%%\n", k);
		printf("%f\n", calc_r(n, k, dist_fcn_ptr));
	}

	printf("Time used: %fs\n", ((double) (clock() - start)) / CLOCKS_PER_SEC);
}

int main() {
	clock_t start = clock();

	int n_values[] = { 100, 1000, 10000 };
	double (*dist_fcn_set[])(int, double[], double[])
							= { &euclidean_dist_squared, &cityblock_dist, &minkowski_3_dist, &prob4_dist, &cos_dist };

	for (int dist_fcn_choice = 0; dist_fcn_choice <= 4; ++dist_fcn_choice) {
		double (*dist_fcn_ptr)(int, double[], double[]) = dist_fcn_set[dist_fcn_choice];
		for (int ii = 0; ii < 3; ++ii) {
			int n = n_values[ii];
			printf("dist_fcn no. %d, n = %d\n", dist_fcn_choice, n);
			char filename[30]; sprintf(filename, "dist_%d_n_%d.csv", dist_fcn_choice, n);  // Create filename for saving results
			FILE *f = fopen(filename, "wb");

			// Calculate r(k) for k = 1:100 and save to file
			for (int k = 1; k <= 100; ++k) {
				if (k % 10 == 0) printf("  - Progress: %d%%\n", k);
				fprintf(f, "%1.20e\n", calc_r(n, k, dist_fcn_ptr));
			}

			fclose(f);
		}
	}

	printf("Time used: %fs\n", ((double) (clock() - start)) / CLOCKS_PER_SEC);
}
