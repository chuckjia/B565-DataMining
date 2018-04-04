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

TwoDimArray<int> preprocess(int num_user, int num_item, TwoDimArray<int> raw_data) {
	clock_t start = clock();

	assert(raw_data.ncol() == 3);
	TwoDimArray<int> train(num_user, num_item);
	memset(train.dataPtr(), 0, sizeof(int) * num_user * num_item);

	int nrow = raw_data.nrow();
	for (int i = 0; i < nrow; ++i) {
		int user = raw_data[i][0] - 1, item = raw_data[i][1] - 1, rating = raw_data[i][2];
		train[user][item] = rating;
	}

	printf("Time used on preprocessing data = %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return train;
}


TwoDimArray<double> calcUserDissim(TwoDimArray<int> train, double (*dist_fcn)(int, int*, int*)) {
	int num_user = train.nrow(), num_item = train.ncol();
	TwoDimArray<double> ans(num_user, num_user);
	memset(ans.dataPtr(), INT_MAX, sizeof(double) * num_user * num_user);

	for (int i = 0; i < num_user; ++i)
		for (int j = i + 1; j < num_user; ++j) {
			double dist = (*dist_fcn)(num_item, train[i], train[j]);
			ans[i][j] = dist;
			ans[j][i] = dist;
		}

	return ans;
}

TwoDimArray<bool> createWatchRecord(TwoDimArray<int> train) {
	int num_user = train.nrow(), num_item = train.ncol();
	TwoDimArray<bool> watch_record(num_item, num_user);
	for (int user = 0; user < num_user; ++user)
		for (int item = 0; item < num_item; ++item)
			watch_record[item][user] = train[user][item] > 0;
	return watch_record;
}

vector<double> predict(TwoDimArray<int> &train, TwoDimArray<int> &test,
		TwoDimArray<double> &user_dissim, TwoDimArray<bool> &watch_record,
		double (*dist_fcn)(int, int*, int*), int num_neighbor, int default_val) {
	clock_t start = clock();

	int num_user = train.nrow();
	int nrow_test = test.nrow();
	vector<double> pred_result(nrow_test);

	for (int test_row = 0; test_row < nrow_test; ++test_row) {
		int userid = test[test_row][0] - 1, itemid = test[test_row][1] - 1;

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
			int sum_rating = 0;
			for (int i = 0; i < actual_num_neighbor; ++i)
				sum_rating += train[closest_users[i]][itemid];
			pred_result[test_row] = double(sum_rating) / actual_num_neighbor;
		} else
			pred_result[test_row] = default_val;
	}

	printf("Time used on prediction = %1.2f ms.\n", (double)(clock() - start) / CLOCKS_PER_SEC * 1000);
	return pred_result;
}

vector<double> predict(TwoDimArray<int> &train, TwoDimArray<int> &test,
		double (*dist_fcn)(int, int*, int*), int num_neighbor, int default_val) {
	TwoDimArray<double> user_dissim = calcUserDissim(train, dist_fcn);
	TwoDimArray<bool> watch_record = createWatchRecord(train);
	return predict(train, test, user_dissim, watch_record, dist_fcn, num_neighbor, default_val);
}

vector<double> predict(TwoDimArray<int> &train, TwoDimArray<int> &test, double (*dist_fcn)(int, int*, int*),
		int num_neighbor) {
	return predict(train, test, dist_fcn, num_neighbor, 3.);
}

double evaluate(vector<double> &pred, TwoDimArray<int> &test) {
	int n = test.nrow();

	double ans = 0;
	for (int i = 0; i < n; ++i) {
		ans += fabs(pred[i] - test[i][2]);
	}
	return ans / n;
}

#endif /* DATAPROC_H_ */
