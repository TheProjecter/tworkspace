
#include <iostream>

int test_func();

class A
{
public:
	A(int a)
	{
		std::cout << a << std::endl;
	}
private:
	A();
};

int main()
{
	void* r = operator new[](10 * sizeof(A));
	A* b = static_cast<A*>(r);
	for (size_t i = 0; i < 10; ++i) {
		new (static_cast<void*>(&b[i])) A(i);
	}
	delete[] b;
	return 0;
}
