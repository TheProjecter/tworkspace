
#ifndef OPENCL_UTILITY_HPP
#define OPENCL_UTILITY_HPP

#define MAX_SOURCE_SIZE (0x100000)

#define __NO_STD_VECTOR
#define __NO_STD_STRING

#include <CL/cl.h>
#include <iostream>
#include <iterator>
#include <map>
#include <cassert>
#include <fstream>

std::string get_error_string(cl_int err);

class opencl_utility
{
public:
	cl_uint platforms_count;
	cl_device_id device_id;
	cl_uint devices_count;
	cl_context context;
	cl_command_queue command_queue;
	cl_program program;
	cl_kernel kernel;
	cl_platform_id platform_id; 

	std::multimap<cl_mem, size_t> mem_obj;
	size_t arguments_count;

public:
	template<typename T>
	void add_kernel_argument(const T* a, size_t s)
	{
		cl_int e = CL_SUCCESS;
		cl_mem m = clCreateBuffer(context, CL_MEM_COPY_HOST_PTR, 
			s * sizeof(T), (void*)a, &e);
		check_error(e);
		e = clEnqueueWriteBuffer(command_queue, m, CL_TRUE, 0, 
				s * sizeof(T), (void*)a, 0, NULL, NULL);
		e = clSetKernelArg(kernel, arguments_count, sizeof(cl_mem), 
				(void*)&m);
		check_error(e);
		mem_obj.insert(std::pair<cl_mem, size_t>(m, s));
		++arguments_count;
	}

	void run (const size_t* g, const size_t* l, const size_t d)
	{
		cl_event end;
		cl_int e = CL_SUCCESS;
		e = clEnqueueNDRangeKernel(command_queue, kernel, d, NULL, 
				g, l, 0, NULL, &end);
		check_error(e);
		clWaitForEvents(1, &end);
	}

public:
	template <typename T>
	void get_kernel_argument(T* a, size_t n)
	{
		typename std::multimap<cl_mem, size_t>::iterator i;
		i = mem_obj.begin();
		advance(i, n - 1);
		clEnqueueReadBuffer(command_queue, (*i).first, CL_TRUE, 0, 
				(*i).second *  sizeof(T), a, 0,  NULL, NULL);
	}

        void read_kernel_file(const std::string& f, std::string& s)
                throw(const std::string&)
        {
                std::ifstream a(f.c_str());
                if(! a.is_open()) {
                        throw std::string("Can't read the kernel file");
                }
                std::string t;
                while(! a.eof()) {
                        std::getline(a, t);
                        s += t + "\n";
                }
                s.erase(s.end() - 1);
        }

        void read_binary_kernel(const std::string& f, unsigned char*& c, 
                        size_t& n)
        {
                FILE* input = fopen(f.c_str(), "rb");
                if( input == NULL )
                {
                    fprintf( stderr, "Unable to open %s for reading.\n", f.c_str() );
                }

                fseek( input, 0L, SEEK_END );    
                size_t size = ftell( input );
                rewind( input );
                unsigned char* binary = (unsigned char *)malloc( size );
                fread( binary, sizeof(char), size, input );
                fclose( input );
                n = size;
                c = binary;
        }

	void check_error(cl_int e)
	{
		if(e != CL_SUCCESS) {
			std::cerr << "Error: " << e << std::endl; 
			std::cerr << get_error_string(e) << std::endl; 
			exit(1);
		}
	}

        void save_to_file(const unsigned char* c, const size_t& z, 
                        const std::string& s) throw(const std::string&)
        {
                std::ofstream f(s.c_str());
                if(! f.is_open()) {
                        throw std::string("Cannot open the file ") + s + 
                                std::string("to store kernel.");
                }
                std::copy(c, c + z, std::ostream_iterator<unsigned char>(f));
                f.close();
        }

private:
	void create_program_object(const std::string& s) 
	{
                try {
                        std::string f;
		        read_kernel_file(s, f);
                        const char* cs = f.c_str();
                        size_t ns = f.size();
                        cl_int e = CL_SUCCESS;
                        program = clCreateProgramWithSource(context, 1, 
                                        (const char **)&cs,
                                        (const size_t *)&ns,
                                        &e);
                        check_error(e);
                } catch (const std::string& s) {
                        std::cout << s << std::endl;
                        exit(1);
                }
	}

	void create_program_object(const std::string& s, const std::string& bs) 
	{
                try {
                        std::string f;
		        read_kernel_file(s, f);
                        const char* cs = f.c_str();
                        size_t ns = f.size();
                        cl_int e = CL_SUCCESS;
                        cl_int status;
                        program = clCreateProgramWithSource(context, 1, 
                                        (const char **)&cs,
                                        (const size_t *)&ns,
                                        &e);
                        check_error(e);
                        e = clBuildProgram(program, 1, &device_id, 
                                        "-w", NULL, NULL);
                        check_error(e);
                        size_t z = 0;
                        e = clGetProgramInfo(program, 
                                        CL_PROGRAM_BINARY_SIZES,
                                        sizeof(size_t), (void*)&z, NULL);
                        check_error(e);
                        unsigned char* c = new unsigned char[z];
                        e = clGetProgramInfo(program, 
                                CL_PROGRAM_BINARIES,
                                sizeof(unsigned char*), (void*)&c, NULL);
                        check_error(e);
                        //save_to_file(c, z, bs);
                        delete[] c;
                        unsigned char* cs2 = 0;
                        read_binary_kernel(bs, cs2, ns);
		        //read_kernel_file(bs, f);
                        //cs = f.c_str();
                        //ns = f.size();
                        //std::cout << "binary size: " << ns << std::endl;
                        //std::cout << "binary: " << cs2 << std::endl;
                        program = clCreateProgramWithBinary(context, 1, 
                                        &device_id, (const size_t*)&ns,
                                        (const unsigned char**)&cs2, 
                                        &status, &e);
                        check_error(e);
                } catch (const std::string& s) {
                        std::cout << s << std::endl;
                        exit(1);
                }
	}

	size_t get_global_mem_size()
	{
		cl_ulong l = 0;
		size_t r = 0;
		clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_SIZE, 
				sizeof(cl_ulong), &l, &r);
		assert(0 != r);
		return (size_t)l;
	}

	size_t get_local_mem_size()
	{
		cl_ulong l = 0;
		size_t r = 0;
		clGetDeviceInfo(device_id, CL_DEVICE_LOCAL_MEM_SIZE, 
				sizeof(cl_ulong), &l, &r);
		assert(0 != r);
		return (size_t)l;
	}

	void get_max_work_item_sizes(size_t*& k, cl_uint& n)
	{
		size_t r = 0;
		clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, 
			sizeof(cl_uint), &n, &r);
		assert(n != 0);
		k = new size_t[n]; 
		clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_SIZES, 
			sizeof(size_t) * n, k, &r);
	}
	
public:
        opencl_utility(const std::string& s)
	{
		arguments_count = 0;
		cl_int e = clGetPlatformIDs(1, &platform_id, &platforms_count);
		check_error(e);
		e = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_GPU, 1, 
				&device_id, &devices_count);
		check_error(e);
		context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &e);
		check_error(e);
		create_program_object(s);
		e = clBuildProgram(program, 1, &device_id, "-w", NULL, NULL);
		check_error(e);
		command_queue = clCreateCommandQueue(context, device_id, 0, &e);
		check_error(e);
		kernel = clCreateKernel(program, "opencl_test_kernel", &e);
		check_error(e);
		size_t* k;
		cl_uint n;
		get_max_work_item_sizes(k, n);
	}

        opencl_utility(const std::string& s, const std::string& bs)
	{
		arguments_count = 0;
		cl_int e = clGetPlatformIDs(1, &platform_id, &platforms_count);
		check_error(e);
		e = clGetDeviceIDs(platform_id, CL_DEVICE_TYPE_GPU, 1, 
				&device_id, &devices_count);
		check_error(e);
		context = clCreateContext(NULL, 1, &device_id, NULL, NULL, &e);
		check_error(e);
		command_queue = clCreateCommandQueue(context, device_id, 0, &e);
		check_error(e);
		create_program_object(s, bs);
		e = clBuildProgram(program, 1, &device_id, "-w", NULL, NULL);
		check_error(e);
		kernel = clCreateKernel(program, "opencl_test_kernel", &e);
		check_error(e);
		size_t* k;
		cl_uint n;
		get_max_work_item_sizes(k, n);
	}

        ~opencl_utility()
	{
		cl_int e = CL_SUCCESS;
		e = clReleaseKernel(kernel);
		check_error(e);
		e = clReleaseCommandQueue(command_queue);
		check_error(e);
		e = clReleaseContext(context);
		check_error(e);
		std::multimap<cl_mem, size_t>::iterator i;
		for(i = mem_obj.begin(); i != mem_obj.end(); ++i) {
			clReleaseMemObject((*i).first);
		}
	}
};

std::string 
get_error_string(cl_int err) {
        switch (err) {
                case CL_SUCCESS: {
                        return std::string("Success!");
                }
                case CL_DEVICE_NOT_FOUND: {
                        return std::string("Device not found.");
                }
                case CL_DEVICE_NOT_AVAILABLE: {
                        return std::string("Device not available");
                }
                case CL_COMPILER_NOT_AVAILABLE: {
                        return std::string("Compiler not available");
                }
                case CL_MEM_OBJECT_ALLOCATION_FAILURE: {
                        return std::string("Memory object allocation failure");
                }
                case CL_OUT_OF_RESOURCES: {
                        return std::string("Out of resources");
                }
                case CL_OUT_OF_HOST_MEMORY: {
                        return std::string("Out of host memory");
                }
                case CL_PROFILING_INFO_NOT_AVAILABLE: {
                        return std::string("Profiling information not "
                                        "available");
                }
                case CL_MEM_COPY_OVERLAP: {
                        return std::string("Memory copy overlap");
                }
                case CL_IMAGE_FORMAT_MISMATCH: {
                        return std::string("Image format mismatch");
                }
                case CL_IMAGE_FORMAT_NOT_SUPPORTED: {
                        return std::string("Image format not supported");
                }
                case CL_BUILD_PROGRAM_FAILURE: {
                        return std::string("Program build failure");
                }
                case CL_MAP_FAILURE: {
                        return std::string("Map failure");
                }
                case CL_INVALID_VALUE: {
                        return std::string("Invalid value");
                }
                case CL_INVALID_DEVICE_TYPE: {
                        return std::string("Invalid device type");
                }
                case CL_INVALID_PLATFORM: {
                        return std::string("Invalid platform");
                }
                case CL_INVALID_DEVICE: {
                        return std::string("Invalid device");
                }
                case CL_INVALID_CONTEXT: {
                        return std::string("Invalid context");
                }
                case CL_INVALID_QUEUE_PROPERTIES: {
                        return std::string("Invalid queue properties");
                }
                case CL_INVALID_COMMAND_QUEUE: {
                        return std::string("Invalid command queue");
                }
                case CL_INVALID_HOST_PTR: {
                        return std::string("Invalid host pointer");
                }
                case CL_INVALID_MEM_OBJECT: {
                        return std::string("Invalid memory object");
                }
                case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR: {
                        return std::string("Invalid image format descriptor");
                }
                case CL_INVALID_IMAGE_SIZE: {
                        return std::string("Invalid image size");
                }
                case CL_INVALID_SAMPLER: {
                        return std::string("Invalid sampler");
                }
                case CL_INVALID_BINARY: {
                        return std::string("Invalid binary");
                }
                case CL_INVALID_BUILD_OPTIONS: {
                        return std::string("Invalid build options");
                }
                case CL_INVALID_PROGRAM: {
                        return std::string("Invalid program");
                }
                case CL_INVALID_PROGRAM_EXECUTABLE: {
                        return std::string("Invalid program executable");
                }
                case CL_INVALID_KERNEL_NAME: {
                        return std::string("Invalid kernel name");
                }
                case CL_INVALID_KERNEL_DEFINITION: {
                        return std::string("Invalid kernel definition");
                }
                case CL_INVALID_KERNEL: {
                        return std::string("Invalid kernel");
                }
                case CL_INVALID_ARG_INDEX: {
                        return std::string("Invalid argument index");
                }
                case CL_INVALID_ARG_VALUE: {
                        return std::string("Invalid argument value");
                }
                case CL_INVALID_ARG_SIZE: {
                        return std::string("Invalid argument size");
                }
                case CL_INVALID_KERNEL_ARGS: {
                        return std::string("Invalid kernel arguments");
                }
                case CL_INVALID_WORK_DIMENSION: {
                        return std::string("Invalid work dimension");
                }
                case CL_INVALID_WORK_GROUP_SIZE: {
                        return std::string("Invalid work group size");
                }
                case CL_INVALID_WORK_ITEM_SIZE: {
                        return std::string("Invalid work item size");
                }
                case CL_INVALID_GLOBAL_OFFSET: {
                        return std::string("Invalid global offset");
                }
                case CL_INVALID_EVENT_WAIT_LIST: {
                        return std::string("Invalid event wait list");
                }
                case CL_INVALID_EVENT: {
                        return std::string("Invalid event");
                }
                case CL_INVALID_OPERATION: {
                        return std::string("Invalid operation");
                }
                case CL_INVALID_GL_OBJECT: {
                        return std::string("Invalid OpenGL object");
                }
                case CL_INVALID_BUFFER_SIZE: {
                        return std::string("Invalid buffer size");
                }
                case CL_INVALID_MIP_LEVEL: {
                        return std::string("Invalid mip-map level");
                }
                default: {
                        return std::string("Unknown");
                }
        }
} 

#endif //  OPENCL_UTILITY_HPP
