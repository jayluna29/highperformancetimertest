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
	void cudaMal(ArrayType_T *a, ArrayType_T *b, ArrayType_T *c, int size);


	int size = 1000;
	double accumulatedTime = 0.0;
	HighPrecisionTime htp;

	ArrayType_T * a = nullptr;
	ArrayType_T * b = nullptr;
	ArrayType_T * c = nullptr;


	if (argc > 1)
	{
		size = stoi(argv[1]);
	}

	cout << argv[0] << endl;
	cout << endl;
	cout << "Array size will be " << size << endl;


	try
	{
		if (!initialize(&a, &b, &c, size))
			throw("CPU memory allocation error ");
		cout << "CPU memory has been allocated" << endl;
		assign(a, b, c, size);

		cout << *a << endl;
		cout << *b << endl;
		cout << *c << endl;

		accumulatedTime = 0.0;

		for (int i = 0; i < 100; i++)
		{
			htp.TimeSinceLastCall();
			addVector(a, b, c, size);
			accumulatedTime += htp.TimeSinceLastCall();
		}
		cout << "Average time: to compute c = a+b: " << accumulatedTime / 100.0 << endl;

		
	
	}
	catch (char * errMessage)
	{
		cout << "An exception occured " << endl;
		cout << errMessage << endl;
	}
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
// Helper function for using CUDA to add vectors in parallel.
void cudaMal(ArrayType_T *a, ArrayType_T *b, ArrayType_T *c, int size)
{
	int *dev_a = 0;
	int *dev_b = 0;
	int *dev_c = 0;

	cudaError_t cudaStatus;

	// Choose which GPU to run on, change this on a multi-GPU system.
	cudaStatus = cudaSetDevice(0);

	try
	{
		// Allocate GPU buffers for three vectors (two inputs A and B, one output C)    
		if (cudaStatus != cudaSuccess) {
			throw("cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
		}


		cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(int)); //mallocs in devA memory
		if (cudaStatus != cudaSuccess) {
			throw("cudaSetDevice a has failed");
		}

		cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(int)); //mallocs in devB memory
		if (cudaStatus != cudaSuccess) {
			throw("cudaSetDevice b has failed");
		}


		cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(int)); //mallocs in devC memory
		if (cudaStatus != cudaSuccess) {
			throw("cudaSetDevice c has failed");
		}
																	 // Copy input vectors from memory to GPU buffers. Not including C because
		cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
		if (cudaStatus != cudaSuccess) {
			throw("cudaMemcpy a has failed");
		}
		
		cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);
		if (cudaStatus != cudaSuccess) {
			throw("cudaMemcpy b has failed");
		}

	}
	catch(char * errMessage)
	{
		cout << "An exception occured " << endl;
		cout << errMessage << endl;
	}

	cudaFree(dev_c); //cleaning up after yourself
	cudaFree(dev_a);
	cudaFree(dev_b);
}
