/*
 * p2.cpp
 *
 *  Created on: Feb 14, 2018
 *      Author: chuckjia
 */

#include "methods.h"

int main() {

	int rand_gen = 1;  // 1 for uniform and 2 for normal

	if (rand_gen == 2)
		printf("[Computing with NORMAL random number generator]\n");
	else
		printf("[Computing with UNIFORM random number generator]\n");

	perform_experiment(rand_gen);
}
