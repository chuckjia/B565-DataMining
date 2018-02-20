/*
 * p2.cpp
 *
 *  Created on: Feb 14, 2018
 *      Author: chuckjia
 */

#include <stdio.h>
#include <iostream>
#include <math.h>
#include <random>
#include <time.h>

#include "NearestNeighbors.h"
#include "TwoDimArray.h"

// Returns the Euclidean distance, i.e. 2-norm metric, between two k-dimensional vectors
double euclidean_dist_squared(int k, double *a, double *b) {
	double ans = 0;
	for (int i = 0; i < k; ++i) {
		double x = a[i] - b[i];
		ans += x * x;
	}
	return ans;
}

const double random_seed = 200;  // Random seed used in random number generators

void generate_data_pts_uniform(const TwoDimArray<double> &data_pts) {
	// Generate random numbers as data points
	std::default_random_engine generator(random_seed);
	std::uniform_real_distribution<double> distribution(0., 1.);

	int n = data_pts.nrow(), k = data_pts.ncol();
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < k; ++j)
			data_pts[i][j] = distribution(generator);
}

void generate_data_pts_normal(const TwoDimArray<double> &data_pts) {
	// Generate random numbers as data points
	std::default_random_engine generator(random_seed);
	std::normal_distribution<double> distribution(0., 1.);

	int n = data_pts.nrow(), k = data_pts.ncol();
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < k; ++j)
			data_pts[i][j] = distribution(generator);
}

TwoDimArray<double> get_dist_matrix(int n, int k, double (*dist_fcn)(int, double[], double[]), int gen_distr) {
	TwoDimArray<double> data_pts(n, k);
	if (gen_distr == 2)
		generate_data_pts_normal(data_pts);
	else
		generate_data_pts_uniform(data_pts);

	TwoDimArray<double> ans(n, n);
	// memset(ans.data_ptr(), 0, sizeof(double) * n * n);

	for (int i = 0; i < n - 1; ++i) {
		if (i % 500 == 0)
			printf("Distance Progress %d%%\n", i / 100);
		for (int j = i + 1; j < n; ++j) {
			double dist = (*dist_fcn)(k, data_pts[i], data_pts[j]);
			ans[i][j] = dist;
			ans[j][i] = dist;
		}
	}
	double max_double = std::numeric_limits<double>::max();
	for (int i = 0; i < n; ++i)
		ans[i][i] = max_double;

	return ans;
}

TwoDimArray<bool> find_neighbors(TwoDimArray<double> &dist_mat, int num_neigh) {
	int n = dist_mat.nrow();
	TwoDimArray<bool> ans(n, n);
	memset(ans.data_ptr(), 0, sizeof(bool) * n * n);

	for (int i = 0; i < n; ++i) {
		NearestNeighbors nb(num_neigh);
		for (int j = 0; j < n; ++j)
			nb.add(j, dist_mat[i][j]);
		int *dp_list = nb.dp_num_ptr();  // Data points
		for (int j = 0; j < num_neigh; ++j)
			ans[i][dp_list[j]] = true;
	}

	return ans;
}

void calc_occur_in_neighbor(TwoDimArray<bool> neighbor_matrix) {
	int n = neighbor_matrix.nrow();
	FILE *f = fopen("result.csv", "wb");
	for (int j = 0; j < n; ++j) {
		int sum = 0;
		for (int i = 0; i < n; ++i)
			sum += neighbor_matrix[i][j];
		fprintf(f, "%d\n", sum);
	}
	fprintf(f, "\n");
	fclose(f);
}

int main() {
	clock_t start = clock();
	TwoDimArray<double> test_dist_mat = get_dist_matrix(10000, 3, euclidean_dist_squared, 1);
	TwoDimArray<bool> nb_mat = find_neighbors(test_dist_mat, 5);
	calc_occur_in_neighbor(nb_mat);
	/*for (int i = 0; i < ans.nrow(); ++i) {
		for (int j = 0; j < ans.ncol(); ++j)
			printf("%d ", ans[i][j]);
		printf("\n");
	}*/

	printf("Time used = %1.2fs", (double) (clock() - start) / CLOCKS_PER_SEC);
}
