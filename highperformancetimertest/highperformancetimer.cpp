#include "highperformancetimer.h"

HighPrecisionTime::HighPrecisionTime()
{
#if	defined(WIN32) || defined(_WIN64)
	QueryPerformanceFrequency(&this->ticksPerSecond); //finds out the rated clock speed of the CPU and puts it in ticksPerSecond
	QueryPerformanceCounter(&this->initializationTicks); //every ticksPerSecond initializationTicks changes
	previousTicks = initializationTicks; //store in previousTicks
#endif
}

double HighPrecisionTime::TimeSinceLastCall()
{
	double result = 0.0;
#if	defined(WIN32) || defined(_WIN64)
	LARGE_INTEGER now;
	LARGE_INTEGER t;

	QueryPerformanceCounter(&now);
	t.QuadPart = now.QuadPart - previousTicks.QuadPart;
	result = ((double)t.QuadPart) / ((double)ticksPerSecond.QuadPart);
	previousTicks = now;
#endif
	return result;
}

double HighPrecisionTime::TotalTime() //returns # of sec. program has been running
{
	double result = 0.0;
#if	defined(WIN32) || defined(_WIN64)
	LARGE_INTEGER now;
	LARGE_INTEGER t;

	QueryPerformanceCounter(&now);
	t.QuadPart = now.QuadPart - initializationTicks.QuadPart;
	result = ((double)t.QuadPart) / ((double)ticksPerSecond.QuadPart);
#endif
	return result;
}