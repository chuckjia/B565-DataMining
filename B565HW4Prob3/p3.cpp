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
	} else if (selection == -1) {
		printf("Wrong number of arguments; correct usage: \n");
		printf("p3 [Method] [DistFcn] [IfUseUserDemo] [DataSet] [TrainFile] [TestFile] [UserDemoFile] [Min#Neighbors] [Max#Neighbors]\n");

		printf("Values:\n  - [Method] = naive, nnb\n  - [DistFcn] = euclidean, mink1, mink2, mink3, mink7, minkInf, cosine\n  ");
		printf("- [IfUseUserDemo] = use, no_use\n  - [DataSet] = 100k, 10m\n");
	}
}

int main(int argc, char **argv) {
	clock_t start = clock();
	printMsg(1);

	if (argc < 9) { printMsg(-1); return -1; }

	string method = argv[1],  // "naive" or "nnb"
			dist_fcn_selection = argv[2],
			use_user_demography = argv[3],
			dset = argv[4],  // "100k" or "10m"
			train_file = argv[5],
			test_file = argv[6],
			user_demo_file = argv[7];
	int num_neighbor_low, num_neighbor_high;
	sscanf(argv[8], "%d", &num_neighbor_low);
	sscanf(argv[9], "%d", &num_neighbor_high);

	double (*dist_fcn)(int, double*, double*) = minkDist1;

	if (dist_fcn_selection == "euclidean") { dist_fcn = euclideanDistSquared; }
	else if (dist_fcn_selection == "mink1") { dist_fcn = minkDist1; }
	else if (dist_fcn_selection == "mink2") { dist_fcn = minkDist2; }
	else if (dist_fcn_selection == "mink3") { dist_fcn = minkDist3; }
	else if (dist_fcn_selection == "mink7") {dist_fcn = minkDist7;}
	else if (dist_fcn_selection == "minkInf") {dist_fcn = minkDistInf;}
	else if (dist_fcn_selection == "cosine") { dist_fcn = cosDist;}

	if (dset == "100k") {  // 100K Data Set

		if (method == "nnb")   // Nearest Neighbor
			run_100k(train_file, test_file, user_demo_file, dist_fcn, num_neighbor_low, num_neighbor_high, use_user_demography == "yes");
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




