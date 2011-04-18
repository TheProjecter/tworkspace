
#ifndef TEST_UTILITIES_HPP
#define TEST_UTILITIES_HPP

#include <fstream>

#define INPUT(e) TEST_ROOT"/inputs/"#e
#define OUTPUT(e) TEST_ROOT"/outputs/"#e 
#define WRITE_TO_OUTOUTS(e,r) write_in_file(OUTPUT(e), r); 

void write_in_file(const std::string& s, std::string& r) 
                        throw(const std::string&)
{
        std::ofstream f(s.c_str());
        if ( f.is_open()) {
                f << r;
        } else {
                throw std::string("Can't open output file ") + s;
        }
        f.close();
}

#endif // TEST_UTILITIES_HPP
