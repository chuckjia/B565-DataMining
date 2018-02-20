/*
 * NearestNeighbors.h
 *
 *  Created on: Feb 14, 2018
 *      Author: chuckjia
 */

#include <limits>

class NearestNeighbors {
public:

	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Constructors
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	NearestNeighbors() {
		_len = 0;
		dist_array = 0;
		dp_num_array = 0;

		_max_dist = 0;
		_max_index = -1;
	}

	NearestNeighbors(int len) {
		if (len > 0) {
			_len = len;
			dist_array = new double[len];
			dp_num_array = new int[len];

			double max_double = std::numeric_limits<double>::max();
			for (int i = 0; i < len; ++i)
				dist_array[i] = max_double;
			_max_dist = max_double;
			_max_index = 0;
		} else {
			_len = 0;
			dp_num_array = 0;
			dist_array = 0;
			_max_dist = 0;
			_max_index = -1;
		}
	}

	void add(int dp_num, double dist) {
		if (dist >= _max_dist)
			return;

		dist_array[_max_index] = dist;
		dp_num_array[_max_index] = dp_num;
		recalc_max();
	}

	inline int* dp_num_ptr() { return dp_num_array; }
	inline int length() { return _len; }

	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Destructor
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	~NearestNeighbors() {
		if (dp_num_array) {
			delete[] dp_num_array;
			delete[] dist_array;

			dp_num_array = 0;
			dist_array = 0;
		};
	}

protected:

	void recalc_max() {
		double max_dist = 0;
		int max_index = 0;
		for (int i = 0; i < _len; ++i)
			if (dist_array[i] > max_dist) {
				max_dist = dist_array[i];
				max_index = i;
			}

		_max_dist = max_dist;
		_max_index = max_index;
	}

	int _len;
	int *dp_num_array;  // The array of data point numbers
	double *dist_array;  // The array of distances

	double _max_dist;
	int _max_index;
};


