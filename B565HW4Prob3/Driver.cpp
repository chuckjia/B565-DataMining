/*
 * Driver.cpp
 *
 *  Created on: Apr 1, 2018
 *      Author: chuckjia
 */

#include "Predict.h"

void printMsg(int selection) {
	if (selection == 1) {
		printf("===== ===== ===== ===== ===== ===== ===== ===== ===== ===== \n");
		printf(">> Movie Recommendation\n");
		printf("===== ===== ===== ===== ===== ===== ===== ===== ===== ===== \n");
		return;
	}
}

int main() {
	clock_t start = clock();
	printMsg(1);

	string dset = "10m";  // "100k" or "10m"
	string method = "naive";  // "naive" or "nnb"
	string use_user_demography = "no";

	string train_file = "data/10m/r5.train", test_file = "data/10m/r5.test";

	//string train_file = "data/100k/u5.base",
	//		test_file = "data/100k/u5.test";
	string user_demo_file = "data/100k/user_info.csv";
	double (*dist_fcn)(int, double*, double*) = cosDist;


	if (dset == "100k") {  // 100K Data Set
		int numNeighborLow = 50,
				numNeighborHigh = 54;

		if (method == "nnb")   // Nearest Neighbor
			run_100k(train_file, test_file, user_demo_file, dist_fcn, numNeighborLow, numNeighborHigh, use_user_demography == "yes");
		else if (method == "naive")  // Naive
			run_naive_100k(train_file, test_file);

	} else if (dset == "10m") {  // Nearest Neighbor: 10M Data Set

		string all_data_file = "data/10m/ratings.dat",
				movie_file = "data/10m/movies.dat";
		vector<int> userid_map = generateUserIdMap(all_data_file.c_str(), 71567);
		vector<int> itemid_map = generateItemIdMap(movie_file.c_str(), 65133);
		// vector<int> itemid_map = generateItemIdMap2(all_data_file.c_str(), 65133);

		if (method == "nnb")
			run_10m(train_file, test_file, userid_map, itemid_map, dist_fcn, 22, 22);
		else if (method == "naive")
			run_naive_10m(train_file, test_file, userid_map, itemid_map);

	}

	/*
	 * Total Time
	 */
	printf("Total time used: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
}




