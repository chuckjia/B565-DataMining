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

const double random_seed = 200;  // Random seed used in random number generators

// Returns the Euclidean distance, i.e. 2-norm metric, between two k-dimensional vectors
double euclidean_dist_squared(int k, double *a, double *b) {
	double ans = 0;
	for (int i = 0; i < k; ++i) {
		double x = a[i] - b[i];
		ans += x * x;
	}
	return ans;
}

// Returns the cosine distance between two k-dimensional vectors, i.e. d(x,y) = 1 - cos(x,y)
double cos_dist(int k, double *a, double *b) {
	double dot_prod = 0, a_len = 0, b_len = 0;
	for (int i = 0; i < k; ++i) {
		dot_prod += a[i] * b[i];
		a_len += a[i] * a[i];
		b_len += b[i] * b[i];
	}
	return 1 - dot_prod / sqrt(a_len * b_len);
}

double new_dist_squared(int k, double *a, double *b) {
	double sum1 = 0, sum2 = 0;
	for (int i = 0; i < k; ++i) {
		double x = a[i] - b[i];
		sum1 += (x > 0) ? x : 0;
		sum2 += (x < 0) ? x : 0;
	}
	return sum1 * sum1 + sum2 * sum2;
}

double new_normalized_dist_squared(int k, double *a, double *b) {
	double num_sum1 = 0, num_sum2 = 0;  // Sums in the numerator
	double denom_sum = 0;  // Sums in the denominator
	for (int i = 0; i < k; ++i) {
		double a_val = a[i], b_val = b[i], diff = a_val - b_val;

		// Numerator
		num_sum1 += diff > 0 ? diff : 0;
		num_sum2 += diff > 0 ? 0 : diff;

		// Denominator
		a_val = a_val > 0 ? a_val : -a_val;
		b_val = b_val > 0 ? b_val : -b_val;
		diff = diff > 0 ? diff : -diff;
		double max = a_val > b_val ? a_val : b_val;
		denom_sum += max > diff ? max : diff;
	}
	return (num_sum1 * num_sum1 + num_sum2 * num_sum2) / (denom_sum * denom_sum);
}

void generate_data_uniform(const TwoDimArray<double> &data_pts) {
	// Generate random numbers as data points
	std::default_random_engine generator(random_seed);
	std::uniform_real_distribution<double> distribution(0., 1.);

	int n = data_pts.nrow(), k = data_pts.ncol();
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < k; ++j)
			data_pts[i][j] = distribution(generator);
}

void generate_data_normal(const TwoDimArray<double> &data_pts) {
	// Generate random numbers as data points
	std::default_random_engine generator(random_seed);
	std::normal_distribution<double> distribution(0., 1.);

	int n = data_pts.nrow(), k = data_pts.ncol();
	for (int i = 0; i < n; ++i)
		for (int j = 0; j < k; ++j)
			data_pts[i][j] = distribution(generator);
}

// Generate n x k data matrix and calculate the full distance matrix, with the diagonal elements being max_double
// Returns the distribution matrix
TwoDimArray<double> get_dist_matrix(int n, int k, double (*dist_fcn)(int, double[], double[]), int distr_no) {
	TwoDimArray<double> data_pts(n, k);
	if (distr_no == 2)
		generate_data_normal(data_pts);
	else
		generate_data_uniform(data_pts);

	TwoDimArray<double> ans(n, n);
	// memset(ans.data_ptr(), 0, sizeof(double) * n * n);

	printf("Distance Progress: ");
	for (int i = 0; i < n - 1; ++i) {
		if (i % 1000 == 0) { printf("%d%% | ", i / 100); fflush (stdout); }
		for (int j = i + 1; j < n; ++j) {
			double distance = (*dist_fcn)(k, data_pts[i], data_pts[j]);
			ans[i][j] = ans[j][i] = distance;
		}
	}
	printf("100%%\n");

	double max_double = std::numeric_limits<double>::max();
	for (int i = 0; i < n; ++i)
		ans[i][i] = max_double;

	return ans;
}

TwoDimArray<bool> find_neighbors(const TwoDimArray<double> &dist_mat, int num_neigh) {
	int n = dist_mat.nrow();
	TwoDimArray<bool> ans(n, n);
	memset(ans.data_ptr(), 0, sizeof(bool) * n * n);  // Set all elements to be false

	for (int i = 0; i < n; ++i) {
		NearestNeighbors nb(num_neigh);
		for (int j = 0; j < n; ++j)
			nb.add(j, dist_mat[i][j]);

		int *nb_index_arr = nb.dp_num_ptr();  // Data points
		for (int j = 0; j < num_neigh; ++j)
			ans[i][nb_index_arr[j]] = true;
	}

	return ans;
}

// Calculate the occurrences in nearest neighbors
void calc_occur_in_neighbor(TwoDimArray<bool> neighbor_matrix, const char *filename) {
	int n = neighbor_matrix.nrow();
	FILE *f = fopen(filename, "wb");
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

	int rand_gen = 1;  // 1 for uniform and 2 for normal

	if (rand_gen == 2)
		printf("[Computing with NORMAL random number generator]\n");
	else
		printf("[Computing with UNIFORM random number generator]\n");

	int num_data_pts = 10000;
	double (*dist_fcn_set[])(int, double*, double*) = { &euclidean_dist_squared, &cos_dist, &new_dist_squared, &new_normalized_dist_squared };
	int dim_set[] = { 3, 30, 300, 3000 };

	for (int dd = 0; dd < 4; ++dd) {
		int num_dim = dim_set[dd];
		for (int dist_fcn_no = 0; dist_fcn_no < 4; ++dist_fcn_no) {
			printf("\n>> Working on k = %d, with distance function no. %d\n", num_dim, dist_fcn_no + 1);
			clock_t start_one_run = clock();

			char filename[30];  // Name of the result file
			sprintf(filename, "k_%d_dist_%d.csv", num_dim, dist_fcn_no + 1);

			double (*dist_fcn)(int, double*, double*) = dist_fcn_set[dist_fcn_no];

			TwoDimArray<double> dist_matrix = get_dist_matrix(num_data_pts, num_dim, dist_fcn, rand_gen);
			TwoDimArray<bool> nb_mat = find_neighbors(dist_matrix, 5);
			calc_occur_in_neighbor(nb_mat, filename);
			printf("Time used = %1.2fs\n", (double) (clock() - start_one_run) / CLOCKS_PER_SEC);
		}
	}

	printf("\n>> Time used in total= %1.2fs", (double) (clock() - start) / CLOCKS_PER_SEC);
}
