#ifndef INSTIGATE_CLP_UTILITIS_HPP
#define INSTIGATE_CLP_UTILITIS_HPP

#include <cassert>
#include <stdio.h>
#include <iostream>
//#include <cutil.h>

//#define START_TIMER(A) double time__##A = clock(); static double total__##A = 0.0; static int callcount__##A = 1;

//#define REPORT_TIMER(A) time__##A = (clock() - time__##A) / CLOCKS_PER_SEC; total__##A += time__##A; std::cout << "Local Time "#A": " << time__##A << std::endl; std::cout << "Static Time "#A": " << total__##A << std::endl; std::cout << "Calls count "#A": " << callcount__##A++ << std::endl;

#define CUDA_CHECK_ERROR(err) if (err != cudaSuccess) { printf("Cuda error: %s(%d)\n", cudaGetErrorString(err), err); printf("Error details:\nfunction name: %s,\nline in file: %i\n", __FUNCTION__, __LINE__);  exit(1); }

#define START_CUDA_TIMER(A) unsigned int __timer##A=0; CUT_SAFE_CALL(cutCreateTimer(&__timer##A)); CUT_SAFE_CALL(cutStartTimer(__timer##A)); 
        
#define CUDA_START_TIMER(A) unsigned int __timer##A=0; CUT_SAFE_CALL(cutCreateTimer(&__timer##A)); CUT_SAFE_CALL(cutStartTimer(__timer##A)); 

#define CUDA_TIMER_START(A) unsigned int __timer##A=0; CUT_SAFE_CALL(cutCreateTimer(&__timer##A)); CUT_SAFE_CALL(cutStartTimer(__timer##A)); 

#define REPORT_CUDA_TIMER(A) CUT_SAFE_CALL(cutStopTimer(__timer##A)); printf("\n"#A"\tProcessing time=%f(ms)\n",cutGetTimerValue(__timer##A)); CUT_SAFE_CALL(cutDeleteTimer(__timer##A)); 

#define CUDA_REPORT_TIMER(A) CUT_SAFE_CALL(cutStopTimer(__timer##A)); printf("\n"#A"\tProcessing time=%f(ms)\n",cutGetTimerValue(__timer##A)); CUT_SAFE_CALL(cutDeleteTimer(__timer##A)); 

#define CUDA_TIMER_REPORT(A) CUT_SAFE_CALL(cutStopTimer(__timer##A)); printf("\n"#A"\tProcessing time=%f(ms)\n",cutGetTimerValue(__timer##A)); CUT_SAFE_CALL(cutDeleteTimer(__timer##A)); 

#define STATIC_HOST_TO_DEVICE(A, B, S, T) static size_t size##A = S; if(0 == A) { CUDA_CHECK_ERROR(cudaMalloc((void**)&A, S * sizeof(T))); } if(size##A < S) { CUDA_CHECK_ERROR(cudaFree(A)); size##A = S; CUDA_CHECK_ERROR(cudaMalloc((void**)&A, S * sizeof(T))); } CUDA_CHECK_ERROR(cudaMemcpy(A, B, S * sizeof(T), cudaMemcpyHostToDevice));

#define STATIC_DEVICE_MALLOC(A, S, T) if(0 == A) { CUDA_CHECK_ERROR(cudaMalloc((void**)&A, S * sizeof(T))); }

void print_last_error()
{
        cudaError_t t = cudaGetLastError();
        CUDA_CHECK_ERROR(t);
}

template <typename T, typename size_type>
T* host_to_device(const T*const a, size_type m)
{
        T* A = 0;
        cudaError_t t = cudaMalloc((void**)&A, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        t = cudaMemcpy(A, a, m * sizeof(T), cudaMemcpyHostToDevice);
        CUDA_CHECK_ERROR(t);
        return A;
}

template <typename T, typename size_type>
void host_to_device(T*& A, const T*const a, size_type m)
{
        cudaError_t t = cudaMalloc((void**)&A, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        t = cudaMemcpy(A, a, m * sizeof(T), cudaMemcpyHostToDevice);
        CUDA_CHECK_ERROR(t);
}

template <typename T, typename size_type>
T* device_to_device(const T*const a, size_type m)
{
        T* A = 0;
        cudaError_t t = cudaMalloc((void**)&A, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        t = cudaMemcpy(A, a, m * sizeof(T), cudaMemcpyDeviceToDevice);
        CUDA_CHECK_ERROR(t);
        return A;
}

template <typename T, typename size_type>
T* device_to_host(T* a, size_type m)
{
        T* f = new T [m]; 
        assert(0 != f);
        cudaError_t t = cudaMemcpy(f, a, m * sizeof(T),
                        cudaMemcpyDeviceToHost);
        CUDA_CHECK_ERROR(t);
        return f;
}

template <typename T, typename size_type>
void device_to_host(T* dest, T* src, size_type m)
{
        assert(0 != dest);
        cudaError_t t = cudaMemcpy(dest, src, m * sizeof(T),
                        cudaMemcpyDeviceToHost);
        CUDA_CHECK_ERROR(t);
}

template <typename T, typename size_type>
T* allocate_on_device(size_type m)
{
        T* A = 0;
        cudaError_t t = cudaMalloc((void**)&A, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        return A;
}

template <typename T, typename size_type>
T* allocate_on_device_zeros(size_type m)
{
        T* A = 0;
        cudaError_t t = cudaMalloc((void**)&A, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        t = cudaMemset(A, 0, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        return A;
}

template <typename T, typename size_type>
T* memset_on_device(size_type m, T v)
{
        T* A = 0;
        cudaError_t t = cudaMalloc((void**)&A, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        t = cudaMemset(A, v, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
        return A;
}

template <typename T, typename size_type>
void initialize_device_memory(T* A, size_type m)
{
        cudaError_t t = cudaMemset(A, 0, m * sizeof(T));
        CUDA_CHECK_ERROR(t);
}

template<typename T, typename U>
T div_up(const T s, const U t)
{
        return s % t ? s / t + 1 : s / t;
}

int get_devices_count()
{
        int* c = 0;
        cudaError_t t = cudaGetDeviceCount(c);
        CUDA_CHECK_ERROR(t);
        return *c;
}

unsigned int get_total_global_memory(const unsigned int i)
{
        cudaDeviceProp deviceProp;
        cudaError_t t = cudaGetDeviceProperties(&deviceProp, i);
        CUDA_CHECK_ERROR(t);
        return deviceProp.totalGlobalMem;
}

void dump_device_details(size_t i)
{
        cudaDeviceProp deviceProp;
        cudaError_t t = cudaGetDeviceProperties(&deviceProp, i);
        CUDA_CHECK_ERROR(t);
        printf("\nDevice name: %s\n", deviceProp.name);
        printf("Total global memory: %zu\n", deviceProp.totalGlobalMem);
        printf("Shared memory per block: %zu \n", 
                deviceProp.sharedMemPerBlock);
        printf("Registers per block: %d \n", deviceProp.regsPerBlock);
        printf("Warp size: %d\n", deviceProp.warpSize);
        printf("Memory pitch: %zu\n", deviceProp.memPitch);
        printf("Max threads per block: %d\n", deviceProp.maxThreadsPerBlock);
        printf("Max threads dimensions: x = %d, y = %d, z = %d\n",
                deviceProp.maxThreadsDim[0], 
                deviceProp.maxThreadsDim[1],
                deviceProp.maxThreadsDim[2]);
        printf("Max grid size: x = %d, y = %d, z = %d\n",
                deviceProp.maxGridSize[0], 
                deviceProp.maxGridSize[1],
                deviceProp.maxGridSize[2]);
        printf("Clock rate: %d\n", deviceProp.clockRate);
        printf("Total constant memory: %zu\n", deviceProp.totalConstMem);
        printf("Compute capability: %d.%d\n", deviceProp.major, 
                deviceProp.minor);
        printf("Texture alignment: %zu\n", deviceProp.textureAlignment);
        printf("Device overlap: %d\n", deviceProp.deviceOverlap);
        printf("Multiprocessor count: %d\n", deviceProp.multiProcessorCount);
        printf("Kernel execution timeout enabled: %s\n",
                deviceProp.kernelExecTimeoutEnabled ? "true" : "false");
}

void set_device(int i)
{
        int d = 0;
        cudaError_t t = cudaGetDevice(&d);
        CUDA_CHECK_ERROR(t);
        if(d != i) {
                t = cudaSetDevice(i);
                CUDA_CHECK_ERROR(t);
        }
}

template <typename T>
void cuda_free(T a)
{
        cudaError_t t = cudaFree((void*)a);
        CUDA_CHECK_ERROR(t);
}

template <typename T1, typename T2>
void cuda_free(T1 a, T2 b)
{
        cudaError_t t = cudaFree((void*)a);
        CUDA_CHECK_ERROR(t);
        t = cudaFree((void*)b);
        CUDA_CHECK_ERROR(t);
}

template <typename T1, typename T2, typename T3>
void cuda_free(T1 a, T2 b, T3 c)
{
        cudaError_t t = cudaFree((void*)a);
        CUDA_CHECK_ERROR(t);
        t = cudaFree((void*)b);
        CUDA_CHECK_ERROR(t);
        t = cudaFree((void*)c);
        CUDA_CHECK_ERROR(t);
}

#endif // INSTIGATE_CLP_UTILITIS_HPP
