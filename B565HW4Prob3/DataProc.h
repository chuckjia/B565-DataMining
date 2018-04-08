/*
 * DataProc.h
 *
 *  Created on: Apr 3, 2018
 *      Author: chuckjia
 */

#ifndef DATAPROC_H_
#define DATAPROC_H_

#include "FileIO.h"
#include "DistFcn.h"
#include "SmallestMembers.h"

TwoDimArray<double> preprocTrain(int num_user, int num_item, TwoDimArray<int> &raw_train) {
	clock_t start = clock();

	assert(raw_train.ncol() == 3);
	TwoDimArray<double> train(num_user, num_item);
	memset(train.dataPtr(), 0, sizeof(double) * num_user * num_item);

	int nrow = raw_train.nrow();
	for (int i = 0; i < nrow; ++i) {
		// if (i % 1000000 == 0) printf("Preprocessing %1.2f%%\n", double(i) / nrow * 100);
		int user = raw_train[i][0], item = raw_train[i][1], rating = raw_train[i][2];
		train[user][item] = (double) rating;
	}

	printf("\n>> Time used on preprocessing data: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return train;
}


TwoDimArray<double> calcUserDissim(TwoDimArray<double> &train, double (*dist_fcn)(int, double*, double*)) {
	clock_t start = clock();

	int num_user = train.nrow(), num_item = train.ncol();
	TwoDimArray<double> ans(num_user, num_user);
	double max_double = std::numeric_limits<double>::max();
	// memset(ans.dataPtr(), max_double, sizeof(double) * num_user * num_user);
	for (int i = 0; i < num_user; ++i)
		ans[i][i] = max_double;

	printf("\n>> Calculating dissimilarity matrix:\n");

	clock_t start_loop = clock();
	double total_num_calc_inv = 1. / (num_user * num_user);

	for (int i = 0; i < num_user; ++i) {
		if (i % 8 == 1) {
			double prog_ratio =  (2 * num_user - i - 2) * (i + 1) * total_num_calc_inv;
			printf("\r  - Dissimilarity progress: %1.4f%%. | ", prog_ratio * 100);
			double time_left = (double)(clock() - start_loop) / CLOCKS_PER_SEC * (1 / prog_ratio - 1);
			printf("Estimated time left: %1.6fs", time_left);
			fflush(stdout);
		}

		for (int j = i + 1; j < num_user; ++j) {
			double dist = (*dist_fcn)(num_item, train[i], train[j]);
			ans[i][j] = dist;
			ans[j][i] = dist;
		}
	}

	printf("\n>> Time used on calculating disimilarity matrix: %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return ans;
}

TwoDimArray<bool> createWatchRecord(TwoDimArray<double> &train) {
	int num_user = train.nrow(), num_item = train.ncol();
	TwoDimArray<bool> watch_record(num_item, num_user);
	for (int user = 0; user < num_user; ++user)
		for (int item = 0; item < num_item; ++item)
			watch_record[item][user] = train[user][item] > 0;
	return watch_record;
}

vector<double> predict(TwoDimArray<double> &train, TwoDimArray<int> &raw_test,
		TwoDimArray<double> &user_dissim, TwoDimArray<bool> &watch_record,
		int num_neighbor, int default_val) {
	clock_t start = clock();

	int num_user = train.nrow();
	int nrow_test = raw_test.nrow();
	vector<double> pred_result(nrow_test);

	for (int test_row = 0; test_row < nrow_test; ++test_row) {
		int userid = raw_test[test_row][0], itemid = raw_test[test_row][1];

		bool* watched_this_item = watch_record[itemid];
		double* dissim_to_this_user = user_dissim[userid];

		SmallestMembers neighbor(num_neighbor);
		for (int i = 0; i < num_user; ++i)
			if (watched_this_item[i])  // If the user has seen the movie itemid
				neighbor.add(i, dissim_to_this_user[i]);

		// neighbor.printSummary();
		int* closest_users = neighbor.dpIdArrPtr();
		int actual_num_neighbor = neighbor.actualLength();
		if (actual_num_neighbor > 0){
			double sum_rating = 0;
			for (int i = 0; i < actual_num_neighbor; ++i)
				sum_rating += train[closest_users[i]][itemid];
			pred_result[test_row] = sum_rating / actual_num_neighbor;
		} else
			pred_result[test_row] = default_val;
	}

	printf("Time used on prediction = %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return pred_result;
}

vector<double> predict(TwoDimArray<double> &train, TwoDimArray<int> &test,
		double (*dist_fcn)(int, double*, double*), int num_neighbor, int default_val) {
	TwoDimArray<double> user_dissim = calcUserDissim(train, dist_fcn);
	TwoDimArray<bool> watch_record = createWatchRecord(train);
	return predict(train, test, user_dissim, watch_record, num_neighbor, default_val);
}

vector<double> predict(TwoDimArray<double> &train, TwoDimArray<int> &test, double (*dist_fcn)(int, double*, double*),
		int num_neighbor) {
	return predict(train, test, dist_fcn, num_neighbor, 3.);
}

double evaluate(vector<double> &pred, TwoDimArray<int> &test) {
	int n = test.nrow();

	double ans = 0;
	for (int i = 0; i < n; ++i)
		ans += fabs(pred[i] - test[i][2]);

	return ans / n;
}

#endif /* DATAPROC_H_ */
