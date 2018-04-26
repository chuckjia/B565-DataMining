/*
 * DistFcn.h
 *
 *  Created on: Apr 1, 2018
 *      Author: chuckjia
 */

#ifndef DISTFCN_H_
#define DISTFCN_H_

#define _MAX_MINK_DIST 1e200
#include <math.h>

// Returns the Euclidean distance, i.e. 2-norm metric, between two k-dimensional vectors
double euclideanDistSquared(int k, double* a, double* b) {
	double ans = 0;
	for (int i = 0; i < k; ++i) {
		double x = a[i] - b[i];
		ans += x * x;
	}
	return ans;
}

double minkDist2(int k, double* a, double* b) {
	double ans = 0;
	int count = 0;
	for (int i = 0; i < k; ++i) {
		bool used = a[i] > 0 && b[i] > 0;
		double x = used ? a[i] - b[i] : 0;
		count += used;
		ans += x * x;
	}
	return count ? ans / (count * count) : _MAX_MINK_DIST;
}

double minkDist1(int k, double* a, double* b) {
	double ans = 0;
	int count = 0;
	for (int i = 0; i < k; ++i) {
		bool used = a[i] > 0 && b[i] > 0;
		double x = used ? fabs(a[i] - b[i]) : 0;
		count += used;
		ans += x;
	}
	return count ? ans / count : _MAX_MINK_DIST;
}

double minkDist3(int k, double* a, double* b) {
	double ans = 0;
	int count = 0;
	for (int i = 0; i < k; ++i) {
		bool used = a[i] > 0 && b[i] > 0;
		double x = used ? fabs(a[i] - b[i]) : 0;
		count += used;
		ans += x * x * x;
	}
	return count ? ans / (count * count * count) : _MAX_MINK_DIST;
}

double minkDist7(int k, double* a, double* b) {
	double ans = 0;
	int count = 0;
	for (int i = 0; i < k; ++i) {
		bool used = a[i] > 0 && b[i] > 0;
		double x = used ? fabs(a[i] - b[i]) : 0;
		count += used;
		ans += pow(x, 7);
	}
	return count ? ans : _MAX_MINK_DIST;
}

double minkDistInf(int k, double* a, double* b) {
	double max = 0;
	int count = 0;
	for (int i = 0; i < k; ++i) {
		bool used = a[i] > 0 && b[i] > 0;
		double x = used ? a[i] - b[i] : 0;
		max = used && (max < x) ? x : max;
		count += used;
	}
	return count ? max : _MAX_MINK_DIST;
}

// Returns the cosine distance between two k-dimensional vectors, i.e. d(x,y) = 1 - cos(x,y)
double cosDist(int k, double* a, double* b) {
	double dot_prod = 0, a_len = 0, b_len = 0;
	int count = 0;
	for (int i = 0; i < k; ++i) {
		double aval = a[i], bval = b[i];
		bool isused = aval > 0 && bval > 0;
		dot_prod += isused ? aval * bval : 0;
		a_len += isused ? aval * aval : 0;
		b_len += isused ? bval * bval : 0;
		count += isused;
	}
	return count ? 1 - dot_prod / sqrt(a_len * b_len) : 2;
}

// Returns the cosine distance between two k-dimensional vectors, i.e. d(x,y) = 1 - cos(x,y)
double cosDist_unnormalized(int k, double* a, double* b) {
	double dot_prod = 0, a_len = 0, b_len = 0;
	int count = 0;
	for (int i = 0; i < k; ++i) {
		double aval = a[i], bval = b[i];
		bool isused = aval > 0 && bval > 0;
		dot_prod += aval * bval;
		a_len += aval * aval;
		b_len += bval * bval;
		count += isused;
	}
	return count ? 1 - dot_prod / sqrt(a_len * b_len) : 2;
}



#endif /* DISTFCN_H_ */
