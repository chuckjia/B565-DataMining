/*
 * P3.cpp
 *
 *  Created on: Apr 1, 2018
 *      Author: chuckjia
 */

#include "DataProc.h"

void run_100k(string train_file, string test_file,
		double (*dist_fcn)(int, double*, double*), int num_neighbor_lower, int num_neighbor_higher) {
	int num_user = 943, num_item = 1682;

	vector<int> userid_map = generateIdMap(num_user),
			itemid_map = generateIdMap(num_item);

	TwoDimArray<int> raw_train = readCSV(train_file.c_str());
	mapId(raw_train, userid_map, itemid_map);
	TwoDimArray<int> test_raw = readCSV(test_file.c_str());
	mapId(test_raw, userid_map, itemid_map);

	TwoDimArray<double> train = preprocTrain(num_user, num_item, raw_train);
	TwoDimArray<double> user_dissim = calcUserDissim(train, dist_fcn);
	TwoDimArray<bool> watch_record = createWatchRecord(train);

	/*
	 * Calculate default rating
	 */
	int num_entry = raw_train.nrow();
	double default_val = 0.;
	for (int i = 0; i < num_entry; ++i)
		default_val += raw_train[i][2];
	default_val /= num_entry;

	double best_eval_score = 5.;
	int best_num_neighbor = 1;
	for (int num_neighbor = num_neighbor_lower; num_neighbor <= num_neighbor_higher; ++num_neighbor) {
		printf("\n>> %d neighbors:\n", num_neighbor);

		vector<double> pred = predict(train, test_raw, user_dissim, watch_record, num_neighbor, default_val);
		double eval_score = evaluate(pred, test_raw);
		printf("Evaluation = %f\n", eval_score);

		if (eval_score < best_eval_score) {
			best_eval_score = eval_score;
			best_num_neighbor = num_neighbor;
		}
	}
	printf("- Best with %d neighbors: score = %f\n", best_num_neighbor, best_eval_score);
}

void run_100k(string train_file, string test_file, double (*dist_fcn)(int, double*, double*), int num_neighbor) {
	run_100k(train_file, test_file, dist_fcn, num_neighbor, num_neighbor);
}

void run_10m(string train_file, string test_file,
		vector<int> userid_map, vector<int> itemid_map,
		double (*dist_fcn)(int, double*, double*), int num_neighbor_lower, int num_neighbor_higher) {

	// int num_user = 71567, num_item = 10681;
	int num_user = 69878, num_item = 10681;
	TwoDimArray<int> raw_train = readCSV2(train_file.c_str());
	mapId(raw_train, userid_map, itemid_map);
	TwoDimArray<int> raw_test = readCSV2(test_file.c_str());
	mapId(raw_test, userid_map, itemid_map);

	TwoDimArray<double> train = preprocTrain(num_user, num_item, raw_train);
	TwoDimArray<double> user_dissim = calcUserDissim(train, dist_fcn);
	TwoDimArray<bool> watch_record = createWatchRecord(train);
}

void debug_run() {
	// int num_user = 5, num_item = 6;

	/*TwoDimArray<int> raw_train = readCSV("data/debug_train");
	vector<int> userid_map = generateUserIdMap(raw_train);
	printToConsole(userid_map);
	vector<int> itemid_map = generateIdMap(num_item);
	printToConsole(raw_train);
	printf("===== \n===== \n");
	mapId(raw_train, userid_map, itemid_map);
	printToConsole(raw_train);
	TwoDimArray<double> train = preprocTrain(num_user, num_item, raw_train);
	TwoDimArray<int> test_raw = readCSV("data/debug_test");*/

	/*vector<int> itemid_map = generateItemIdMap("data/debug_movie");
	printToConsole(itemid_map);*/
}

int main() {
	clock_t start = clock();
	printf("===== ===== ===== ===== ===== ===== ===== ===== ===== ===== \n");
	printf(">> Movie Recommendation\n");
	printf("===== ===== ===== ===== ===== ===== ===== ===== ===== ===== \n");

	int set_no = 2;

	if (set_no == 1) {
		/*
		 * 100K Data Set
		 */
		double (*dist_fcn)(int, double*, double*) = minkDist1;
		string train_file = "data/100k/u3.base", test_file = "data/100k/u3.test";
		run_100k(train_file, test_file, dist_fcn, 10, 30);

	} else {
		/*
		 * 10M Data Set
		 */
		double (*dist_fcn)(int, double*, double*) = minkDist1;
		string train_file = "data/10m/r1.train",
				test_file = "data/10m/r1.test",
				all_data_file = "data/10m/ratings.dat",
				movie_file = "data/10m/movies.dat";
		vector<int> userid_map = generateUserIdMap(all_data_file.c_str(), 71567);
		vector<int> itemid_map = generateItemIdMap(movie_file.c_str(), 65133);
		// vector<int> itemid_map = generateItemIdMap2(all_data_file.c_str(), 65133);

		run_10m(train_file, test_file, userid_map, itemid_map, dist_fcn, 22, 22);
	}

	/*
	 * Total Time
	 */
	printf("Total time used: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
}




