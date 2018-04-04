/*
 * DistFcn.h
 *
 *  Created on: Apr 1, 2018
 *      Author: chuckjia
 */

#ifndef DISTFCN_H_
#define DISTFCN_H_
#include <math.h>

// Returns the Euclidean distance, i.e. 2-norm metric, between two k-dimensional vectors
double euclideanDistSquared(int k, int* a, int* b) {
	int ans = 0;
	for (int i = 0; i < k; ++i) {
		int x = a[i] - b[i];
		ans += x * x;
	}
	return (double) ans;
}

double distFcn1(int k, int* a, int* b) {
	int ans = 0;
	for (int i = 0; i < k; ++i) {
		int x = a[i] > 0 && b[i] > 0 ? a[i] - b[i] : 0;
		ans += x * x;
	}
	return (double) ans;
}



#endif /* DISTFCN_H_ */
