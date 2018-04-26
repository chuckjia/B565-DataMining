/*
 * Predict.h
 *
 *  Created on: Apr 10, 2018
 *      Author: chuckjia
 */

#ifndef PREDICT_H_
#define PREDICT_H_

#include "DataProc.h"

void run_pred_helper(TwoDimArray<int> &train_raw, TwoDimArray<int> &test_raw, int num_user, int num_item) {
	TwoDimArray<double> train = preprocTrain(num_user, num_item, train_raw);
	TwoDimArray<bool> watch_record = createWatchRecord(train);

	int default_val = calcDefaultVal(train_raw);

	vector<double> pred = naivePredict(train, test_raw, watch_record, default_val);
	double eval_score = evaluate(pred, test_raw);
	printf("Evaluation = %f\n", eval_score);
}

void run_naive_100k(string train_file, string test_file) {
	int num_user = 943, num_item = 1682;
	vector<int> userid_map = generateIdMap(num_user),
			itemid_map = generateIdMap(num_item);

	TwoDimArray<int> train_raw = readCSV(train_file.c_str());
	mapId(train_raw, userid_map, itemid_map);
	TwoDimArray<int> test_raw = readCSV(test_file.c_str());
	mapId(test_raw, userid_map, itemid_map);

	run_pred_helper(train_raw, test_raw, num_user, num_item);
}

void run_naive_10m(string train_file, string test_file, vector<int> userid_map, vector<int> itemid_map) {
	// int num_user = 71567, num_item = 10681;
	int num_user = 69878, num_item = 10681;


	TwoDimArray<int> train_raw = readCSV2(train_file.c_str());
	mapId(train_raw, userid_map, itemid_map);
	TwoDimArray<int> test_raw = readCSV2(test_file.c_str());
	mapId(test_raw, userid_map, itemid_map);

	run_pred_helper(train_raw, test_raw, num_user, num_item);
}

void run_pred_multi_k(TwoDimArray<int> &train_raw, TwoDimArray<int> &test_raw, TwoDimArray<int> &user_demography,
		int num_user, int num_item, double (*dist_fcn)(int, double*, double*),
		int num_neighbor_lower, int num_neighbor_higher, bool use_user_demography) {

	TwoDimArray<double> train = preprocTrain(num_user, num_item, train_raw);
	TwoDimArray<double> user_dissim;
	if (use_user_demography) {
		user_dissim = calcUserDissim(train, dist_fcn, user_demography);
	} else
		user_dissim = calcUserDissim(train, dist_fcn);

	TwoDimArray<bool> watch_record = createWatchRecord(train);

	int default_val = calcDefaultVal(train_raw);

	double best_eval_score = 5.;
	int best_num_neighbor = 1;
	for (int num_neighbor = num_neighbor_lower; num_neighbor <= num_neighbor_higher; ++num_neighbor) {
		printf("\n>> %d neighbors:\n", num_neighbor);

		vector<double> pred = predict(train, test_raw, user_dissim, watch_record, num_neighbor, default_val);
		double eval_score = evaluate(pred, test_raw);
		printf("Evaluation = %f\n", eval_score);
		// printf("%f,", eval_score);

		if (eval_score < best_eval_score) {
			best_eval_score = eval_score;
			best_num_neighbor = num_neighbor;
		}
	}
	printf("\n- Best with %d neighbors: score = %f\n", best_num_neighbor, best_eval_score);
}

void run_100k(string train_file, string test_file, string user_demo_file, double (*dist_fcn)(int, double*, double*),
		int num_neighbor_lower, int num_neighbor_higher, bool use_user_demography) {

	int num_user = 943, num_item = 1682;

	vector<int> userid_map = generateIdMap(num_user),
			itemid_map = generateIdMap(num_item);

	TwoDimArray<int> train_raw = readCSV(train_file.c_str());
	mapId(train_raw, userid_map, itemid_map);
	TwoDimArray<int> test_raw = readCSV(test_file.c_str());
	mapId(test_raw, userid_map, itemid_map);

	TwoDimArray<int> user_demography = readUserDemography_100k(user_demo_file);

	run_pred_multi_k(train_raw, test_raw, user_demography, num_user, num_item, dist_fcn,
			num_neighbor_lower, num_neighbor_higher, use_user_demography);
}

void run_100k(string train_file, string test_file, string user_demo_file, double (*dist_fcn)(int, double*, double*),
		int num_neighbor, bool use_user_demography) {

	run_100k(train_file, test_file, user_demo_file, dist_fcn, num_neighbor, num_neighbor, use_user_demography);
}

void run_10m(string train_file, string test_file,
		vector<int> &userid_map, vector<int> &itemid_map,
		double (*dist_fcn)(int, double*, double*), int num_neighbor_lower, int num_neighbor_higher) {

	// int num_user = 71567, num_item = 10681;
	int num_user = 69878, num_item = 10681;
	TwoDimArray<int> train_raw = readCSV2(train_file.c_str());
	mapId(train_raw, userid_map, itemid_map);
	TwoDimArray<int> test_raw = readCSV2(test_file.c_str());
	mapId(test_raw, userid_map, itemid_map);

	TwoDimArray<int> user_demography(1, 1);

	run_pred_multi_k(train_raw, test_raw, user_demography, num_user, num_item, dist_fcn,
			num_neighbor_lower, num_neighbor_higher, false);
}

void debug_run() {
	int num_user = 5, num_item = 6;

	TwoDimArray<int> raw_train = readCSV("data/debug_train");
	vector<int> userid_map = generateUserIdMap("data/debug_train", 5);
	printToConsole(userid_map);
	vector<int> itemid_map = generateIdMap(num_item);
	printToConsole(raw_train);
	printf("===== \n===== \n");
	mapId(raw_train, userid_map, itemid_map);
	printToConsole(raw_train);
	TwoDimArray<double> train = preprocTrain(num_user, num_item, raw_train);
	TwoDimArray<int> test_raw = readCSV("data/debug_test");
}

#endif /* PREDICT_H_ */
