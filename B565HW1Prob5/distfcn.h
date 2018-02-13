/*
 * distfcn.h
 *
 * 	This file contains all the distance functions needed in Problem 5
 *
 *  Created on: Feb 3, 2018
 *      Author: chuckjia
 */

#ifndef DISTFCN_H_
#define DISTFCN_H_

#include <math.h>
#include <stdio.h>

// Returns the Euclidean distance, i.e. 2-norm metric, between two k-dimensional vectors
double euclidean_dist(int k, double a[], double b[]) {
	double ans = 0;
	for (int i = 0; i < k; ++i) {
		double x = a[i] - b[i];
		ans += x * x;
	}
	return sqrt(ans);
}

// Returns the cityblock distance, i.e. 1-norm metric, between two k-dimensional vectors
double cityblock_dist(int k, double a[], double b[]) {
	double ans = 0;
	for (int i = 0; i < k; ++i)
		ans += fabs(a[i] - b[i]);
	return ans;
}

// Returns the Minkowski distance with p = 3, i.e. 3-norm metric, between two k-dimensional vectors
double minkowski_3_dist(int k, double a[], double b[]) {
	double ans = 0;
	for (int i = 0; i < k; ++i) {
		double x = fabs(a[i] - b[i]);
		ans += x * x * x;
	}
	return std::cbrt(ans);
}

// Returns the distance between two k-dimensional vectors using the metric in Problem 4
double prob4_dist(int k, double a[], double b[]) {
	double sum1 = 0, sum2 = 0;
	for (int i = 0; i < k; ++i) {
		double x = a[i] - b[i];
		sum1 += (x > 0) ? x : 0;
		sum2 += (x < 0) ? x : 0;
	}
	return sqrt(sum1 * sum1 + sum2 * sum2);
}

// Returns the cosine distance between two k-dimensional vectors, i.e. d(x,y) = 1 - cos(x,y)
double cos_dist(int k, double a[], double b[]) {
	double dot_prod = 0, a_len = 0, b_len = 0;
	for (int i = 0; i < k; ++i) {
		dot_prod += a[i] * b[i];
		a_len += a[i] * a[i];
		b_len += b[i] * b[i];
	}
	return 1 - dot_prod / sqrt(a_len * b_len);
}

#endif /* DISTFCN_H_ */
