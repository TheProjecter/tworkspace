
#include <iostream>

int test_func();

class A
{
private:
	int m_a;
public:
	A(int a)
	{
		m_a = a;
		std::cout << a << std::endl;
	}

	const int& get_value() const throw()
	{
		return m_a;
	}

	//int operator new(size_t a)
	//{
	//	std::cout << a << std::endl;
	//}

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
	A a(5);
	const int& c = a.get_value();
	std::cout << a.get_value() << std::endl;
	return 0;
}
