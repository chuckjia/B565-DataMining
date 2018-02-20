/*
 * TwoDimArray.h
 *
 *  Created on: Feb 13, 2018
 *      Author: chuckjia
 */

#ifndef TWODIMARRAY_H_
#define TWODIMARRAY_H_
#include <assert.h>
// #include <string.h>

template<class T> class TwoDimArray {
public:

	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Constructors
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	TwoDimArray() {
		data_slices = 0;
		data_area = 0;
		_nrow = _ncol = 0;
	}

	TwoDimArray(int nrow, int ncol) {
		_nrow = nrow;
		_ncol = ncol;

		data_slices = 0;
		data_area = 0;

		initialize_storage();
	}

	TwoDimArray(int nrow, int ncol, const T *array) {
		_nrow = nrow;
		_ncol = ncol;

		data_slices = 0;
		data_area = 0;

		initialize_storage();

		memcpy(data_area, array, _nrow * _ncol * sizeof(T));
	}

	TwoDimArray(const TwoDimArray<T> &other) {
		assert(this != &other);

		data_slices = 0;
		data_area = 0;

		*this = other;
	}


	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Destructor
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	~TwoDimArray() {
		deallocate_storage();
	}


	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Assignment Operator
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	TwoDimArray<T> &operator=(const TwoDimArray<T> &other) {
		if(this == &other)
			return *this;

		if(!data_slices || _nrow != other.nrow() || _ncol != other.ncol()) {
			_nrow = other.nrow();
			_ncol = other.ncol();

			initialize_storage();
		}

		memcpy(data_area, other.data_area, _nrow * _ncol * sizeof(T));

		return *this;
	}


	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Element Access
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	inline T *operator[](int row) const { return data_slices[row]; }


	/* ===== ===== ===== ===== ===== ===== ===== =====
	 * Informational
	 * ===== ===== ===== ===== ===== ===== ===== ===== */

	inline int nrow() const { return _nrow; }
	inline int ncol() const { return _ncol; }
	inline T *data_ptr() const { return data_area; }
	inline T **row_pointers() const { return data_slices; }


protected:

	void deallocate_storage() {
		if(data_slices) {
			delete[] data_slices;
			delete[] data_area;

			data_slices = 0;
			data_area = 0;
		}
	}

	void initialize_storage() {
		if(data_slices)
			deallocate_storage();

		if(_nrow > 0) {
			data_slices = new T *[_nrow];
			data_area = new T[_nrow * _ncol];
		} else {
			data_slices = 0;
			data_area = 0;
		}

		T *curr_ptr = data_area;
		for(int i = 0; i < _nrow; i++, curr_ptr += _ncol)
			data_slices[i] = curr_ptr;
	}

	// Size of the matrix
	int _nrow, _ncol;

	// Array of pointers to the beginning of each matrix row in data_area
	T **data_slices;

	// Pointer to actual matrix data
	T *data_area;
};


#endif /* TWODIMARRAY_H_ */
