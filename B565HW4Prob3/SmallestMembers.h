/*
 * SmallestMemebers.h
 *
 *  Created on: Apr 3, 2018
 *      Author: chuckjia
 */

#ifndef SMALLESTMEMBERS_H_
#define SMALLESTMEMBERS_H_

#include <limits>
#include <string>
#include <math.h>

class SmallestMembers {
public:

	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Constructors
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	SmallestMembers() {
		len_ = 0;
		dist_arr_ = 0;
		dp_id_arr_ = 0;

		max_dist_ = 0;
		max_index_ = -1;
	}

	SmallestMembers(int len) {
		if (len > 0) {
			len_ = len;
			dist_arr_ = new double[len];
			dp_id_arr_ = new int[len];

			double max_double = std::numeric_limits<double>::max();
			for (int i = 0; i < len; ++i) {
				dist_arr_[i] = max_double;
				dp_id_arr_[i] = -1;
			}
			max_dist_ = max_double;
			max_index_ = 0;
		} else {
			len_ = 0;
			dp_id_arr_ = 0;
			dist_arr_ = 0;

			max_dist_ = 0;
			max_index_ = -1;
		}
	}

	void add(int dp_id, double dist) {
		if (dist >= max_dist_)
			return;

		dist_arr_[max_index_] = dist;
		dp_id_arr_[max_index_] = dp_id;
		recalcMax();
	}

	int actualLength() {
		int ans = 0;
		for (int i = 0; i < len_; ++i)
			ans += dp_id_arr_[i] >= 0;
		return ans;
	}

	void deallocateStorage() {
		if (dp_id_arr_) {
			delete[] dp_id_arr_;
			delete[] dist_arr_;

			dp_id_arr_ = 0;
			dist_arr_ = 0;
		};
	}

	void resize() {
		int actual_len = actualLength();
		if (actual_len == len_)
			return;

		int* new_dp_id_arr = new int[actual_len];
		double* new_dist_arr = new double[actual_len];

		memcpy(new_dp_id_arr, dp_id_arr_, sizeof(int) * actual_len);
		memcpy(new_dist_arr, dist_arr_, sizeof(double) * actual_len);

		deallocateStorage();

		len_ = actual_len;
		dp_id_arr_ = new_dp_id_arr;
		dist_arr_ = new_dist_arr;
		recalcMax();
	}

	double mean() {
		double ans = 0;
		int actual_len = 0;
		for (int i = 0; i < len_; ++i)
			if (dp_id_arr_[i] >= 0) {
				++actual_len;
				ans += dist_arr_[i];
			}
		if (actual_len == 0)
			return 0;
		ans /= actual_len;
		return ans;
	}

	void printSummary() {
		printf("This set has %d elements.\nElement IDs = { ", len_);
		int last_index = len_ - 1;
		for (int i = 0; i < last_index; ++i)
			printf("%d, ", dp_id_arr_[i]);
		printf("%d }\nSet of All Distances = { ", dp_id_arr_[last_index]);
		for (int i = 0; i < last_index; ++i)
			printf("%1.6e, ", dist_arr_[i]);
		printf("%1.6e }\n", dist_arr_[last_index]);
		printf("Max = %1.6e, with ID = %d and internal index = %d\n", max_dist_, dp_id_arr_[max_index_], max_index_);
		printf("Actual length = %d, ", actualLength());
		printf("Mean = %1.6e\n", mean());
	}

	inline int* dpIdArrPtr() { return dp_id_arr_; }
	inline int length() { return len_; }

	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Destructor
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	~SmallestMembers() {
		deallocateStorage();
	}

protected:

	void recalcMax() {
		double max_dist = 0;
		int max_index = 0;
		for (int i = 0; i < len_; ++i)
			if (dist_arr_[i] > max_dist) {
				max_dist = dist_arr_[i];
				max_index = i;
			}

		max_dist_ = max_dist;
		max_index_ = max_index;
	}

	int len_;
	int *dp_id_arr_;  // The array of data point numbers
	double *dist_arr_;  // The array of distances

	double max_dist_;
	int max_index_;
};


#endif /* SMALLESTMEMBERS_H_ */
