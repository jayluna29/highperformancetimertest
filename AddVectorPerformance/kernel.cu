#include <iostream>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "string"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "../highperformancetimertest/highperformancetimer.h"

using namespace std;

typedef int ArrayType_T;

int main(int argc, char * argv[])
{
	srand((unsigned)time(NULL));

	bool initialize(ArrayType_T ** a, ArrayType_T  ** b, ArrayType_T ** c, int size);
	void clearMem(ArrayType_T * a, ArrayType_T * b, ArrayType_T * c);
	void assign(ArrayType_T * a, ArrayType_T  * b, ArrayType_T * c, int size);
	void addVector(ArrayType_T *a, ArrayType_T *b, ArrayType_T *c, int size);


	int size = 1000;
	
	ArrayType_T * a = nullptr;
	ArrayType_T * b = nullptr;
	ArrayType_T * c = nullptr;

	double accumulatedTime = 0.0;

	//HighPrecisionTime htp;


	try
	{

		if (!initialize(&a, &b, &c, size))
			throw("CPU memory allocation error ");
		cout << "CPU memory has been allocated" << endl;

		//accumulatedTime = 0.0;

		//for (int i = 0; i < 100; i++)
		//{
			//htp.TimeSinceLastCall();
			//addVector(a, b, c, size);
			//accumulatedTime += htp.TimeSinceLastCall();
		//}

	}
	catch (char * errMessage)
	{
		cout << "An exception occured " << endl;
		cout << errMessage << endl;
	}
	cout << argc << endl;

	std::stoi(argv[1]);

	if (argc > 1)
	{
		size = stoi(argv[1]);
	}

	cout << argv[0] << endl;
	cout << endl;
	cout << "Array size will be " << size << endl;

	assign(a, b, c, size);

	cout << *a << endl;
	cout << *b << endl;
	cout << *c << endl;

	addVector(a, b, c, size);

	cout << "Adding the vectors by taking the random int of a and b and adding them and placing them into c" << endl;
	cout << *a << endl;
	cout << *b << endl;
	cout << *c << endl;

	clearMem(a, b, c);

	system("pause");


}


bool initialize(ArrayType_T ** a, ArrayType_T ** b, ArrayType_T ** c, int size)
{
	bool retVal = true;

	*a = (ArrayType_T*)malloc(size * sizeof(ArrayType_T));
	*b = (ArrayType_T*)malloc(size * sizeof(ArrayType_T));
	*c = (ArrayType_T*)malloc(size * sizeof(ArrayType_T));

	if (*a == nullptr || *b == nullptr || *c == nullptr)
	{
		retVal = false;
	}

	return retVal;
}

void assign(ArrayType_T * a, ArrayType_T  * b, ArrayType_T * c, int size)
{
	cout << "Starting loop" << endl;
	for (int i = 0; i < size; i++)
	{
		a[i] = rand() % size;
		b[i] = rand() % size;
		c[i] = 0;

	}

}

void clearMem(ArrayType_T * a, ArrayType_T * b, ArrayType_T * c)
{
	if (a != nullptr)
	{
		free(a);
	}
	if (b != nullptr)
	{
		free(b);
	}
	if (c != nullptr)
	{
		free(c);
	}

}

void addVector(ArrayType_T *a, ArrayType_T *b, ArrayType_T *c, int size)
{
	for (int i = 0; i < size; i++)
	{
		c[i] = a[i] + b[i];
	}
}