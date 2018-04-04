/*
 * P3.cpp
 *
 *  Created on: Apr 1, 2018
 *      Author: chuckjia
 */

#include "DataProc.h"

void run_100k(string train_file, string test_file,
		double (*dist_fcn)(int, int*, int*), int num_neighbor_lower, int num_neighbor_higher) {
	int num_user = 943, num_item = 1682;
	TwoDimArray<int> raw_train = readCSV(train_file.c_str());
	TwoDimArray<int> train = preprocess(num_user, num_item, raw_train);
	TwoDimArray<int> test_raw = readCSV(test_file.c_str());

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

		vector<double> pred = predict(train, test_raw, user_dissim, watch_record, dist_fcn, num_neighbor, default_val);
		double eval_score = evaluate(pred, test_raw);
		printf("Evaluation = %f\n", eval_score);

		if (eval_score < best_eval_score) {
			best_eval_score = eval_score;
			best_num_neighbor = num_neighbor;
		}
	}
	printf("- Best with %d neighbors: score = %f\n", best_num_neighbor, best_eval_score);
}

void run_100k(string train_file, string test_file, double (*dist_fcn)(int, int*, int*), int num_neighbor) {
	run_100k(train_file, test_file, dist_fcn, num_neighbor, num_neighbor);
}

int main() {
	// int num_neighbor = 39;
	double (*dist_fcn)(int, int*, int*) = distFcn1;

	/*
	 * Debug Set 1
	 */
	/*int num_user = 5, num_item = 6;
	TwoDimArray<int> raw_train = readCSV("data/debug_train");
	TwoDimArray<int> train = preprocess(num_user, num_item, raw_train);
	TwoDimArray<int> test_raw = readCSV("data/debug_test");
	vector<double> pred = predict(train, test_raw, dist_fcn, num_neighbor);
	printf("Evaluation: %f\n", evaluate(pred, test_raw));*/

	/*
	 * 100K Data Set
	 */
	string train_file = "data/u3.base", test_file = "data/u3.test";
	run_100k(train_file, test_file, dist_fcn, 48);
}




