nbb100k:
	g++ p3.cpp -o out
	./out nnb mink1 no_use 100k data/100k/u3.base data/100k/u3.test data/100k/user_info.csv 10 30

naive100k:
	g++ p3.cpp -o out
	./out naive mink1 no_use 100k data/100k/u1.base data/100k/u1.test data/100k/user_info.csv 22 22

naive10m:
	g++ p3.cpp -o out
	./out naive mink1 no_use 10m data/10m/r1.train data/10m/r1.test data/100k/user_info.csv 22 22

userdemo100k:
	./out nnb mink1 use 100k data/100k/u1.base data/100k/u1.test data/100k/user_info.csv 22 22

all:
	nbb100k