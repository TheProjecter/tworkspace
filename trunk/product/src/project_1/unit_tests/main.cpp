
#include <dlfcn.h>
#include <iostream>

int main()
{
	void* h = dlopen("/u/thovhann/Desktop/gnu_make/tworkspace/trunk/product/src/project_1/i686_linux_2.6.9/debug/lib_project_1.so", RTLD_LAZY);
	if (!h ) {
		std::cerr << "Cannot open library: " << dlerror() << "\n";
		return 1;
	}
	dlclose(h);
	return 0;
}

