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

	printf("\n>> Calculating dissimilarity matrix: ");
	printf("size (%d, %d)\n", ans.nrow(), ans.ncol());

	clock_t start_loop = clock();
	double total_num_calc_inv = 1. / ((double) num_user * (double) num_user);

	for (int i = 0; i < num_user; ++i) {
		if (i % 32 == 1) {
			double num_user_left = num_user - i;
			double prog_ratio = 1 - num_user_left * num_user_left * total_num_calc_inv;
			printf("\r  - Dissimilarity progress: %1.4f%% (i = %d). | ", prog_ratio * 100, i);
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

	printf("\n>> Time used on calculating dissimilarity matrix: %1.2f s.\n", (double)(clock() - start) / CLOCKS_PER_SEC);
	return ans;
}

double calcUserDemographyDist(int* x, int* y) {
	int age_diff = x[1] - y[1];
	age_diff = age_diff >= 0 ? age_diff : (-age_diff);
	bool gender_diff = (x[2] == y[2]);
	return 0.005 * age_diff + 0.0034 * gender_diff;  // mink1
	// return 9.29e-6 * age_diff + 1.5e-6 * gender_diff;  // mink2
	// return -3e-5 * age_diff + 3e-5 * gender_diff;  // Cosine
}

TwoDimArray<double> calcUserDissim(TwoDimArray<double> &train, double (*dist_fcn)(int, double*, double*),
		TwoDimArray<int> &user_demography) {

	TwoDimArray<double> user_dissim = calcUserDissim(train, dist_fcn);
	int num_user = user_demography.nrow();
	for (int i = 0; i < num_user; ++i) {
		for (int j = i + 1; j < num_user; ++j) {
			double demo_dist = calcUserDemographyDist(user_demography[i], user_demography[j]);
			user_dissim[i][j] += demo_dist;
			user_dissim[j][i] += demo_dist;
		}
	}
	return user_dissim;
}

TwoDimArray<bool> createWatchRecord(TwoDimArray<double> &train) {
	int num_user = train.nrow(), num_item = train.ncol();
	TwoDimArray<bool> watch_record(num_item, num_user);
	for (int user = 0; user < num_user; ++user)
		for (int item = 0; item < num_item; ++item)
			watch_record[item][user] = train[user][item] > 0;
	return watch_record;
}

int calcDefaultVal(TwoDimArray<int> &train_raw) {
	int num_entry = train_raw.nrow();
	double default_val = 0.;
	for (int i = 0; i < num_entry; ++i)
		default_val += train_raw[i][2];
	default_val /= num_entry;
	return (int) default_val;
}

// Note that default_val here is an int. This is intentional, as from experiment results, int would give better results.
vector<double> predict(TwoDimArray<double> &train, TwoDimArray<int> &raw_test,
		TwoDimArray<double> &user_dissim, TwoDimArray<bool> &watch_record, int num_neighbor, int default_val) {
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

vector<double> predict(TwoDimArray<double> &train, TwoDimArray<int> &test_raw,
		double (*dist_fcn)(int, double*, double*), int num_neighbor, int default_val) {
	TwoDimArray<double> user_dissim = calcUserDissim(train, dist_fcn);
	TwoDimArray<bool> watch_record = createWatchRecord(train);
	return predict(train, test_raw, user_dissim, watch_record, num_neighbor, default_val);
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

vector<double> naivePredict(TwoDimArray<double> &train, TwoDimArray<int> &test_raw,
		TwoDimArray<bool> &watch_record, int default_val) {
	int nrow_test = test_raw.nrow(),
			num_user = train.nrow(), num_item = train.ncol();
	vector<double> pred_cache(num_item, -1);
	vector<double> pred_result(nrow_test);

	for (int row = 0; row < nrow_test; ++row) {
		int itemid = test_raw[row][1];
		if (pred_cache[itemid] > 0)
			pred_result[row] = pred_cache[itemid];
		else {

			double pred_rating = 0;
			bool* watched_this = watch_record[itemid];
			int num_user_watched_this = 0;
			for (int i = 0; i < num_user; ++i) {
				bool watched_or_not = watched_this[i];
				num_user_watched_this += watched_or_not ? 1 : 0;
				pred_rating += watched_or_not ? train[i][itemid] : 0;
			}
			if (num_user_watched_this > 0)
				pred_rating /= num_user_watched_this;
			else
				pred_rating = default_val;
			pred_result[row] = pred_rating;
			pred_cache[itemid] = pred_rating;

		}
	}

	return pred_result;
}

#endif /* DATAPROC_H_ */
