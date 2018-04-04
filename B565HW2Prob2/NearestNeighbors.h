/*
 * NearestNeighbors.h
 *
 *  Created on: Feb 14, 2018
 *      Author: chuckjia
 */

#include <limits>

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
			for (int i = 0; i < len; ++i)
				dist_arr_[i] = max_double;
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

	void add(int dp_num, double dist) {
		if (dist >= max_dist_)
			return;

		dist_arr_[max_index_] = dist;
		dp_id_arr_[max_index_] = dp_num;
		recalcMax();
	}

	inline int* dpIdArrPtr() { return dp_id_arr_; }
	inline int length() { return len_; }

	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Destructor
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	~SmallestMembers() {
		if (dp_id_arr_) {
			delete[] dp_id_arr_;
			delete[] dist_arr_;

			dp_id_arr_ = 0;
			dist_arr_ = 0;
		};
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


