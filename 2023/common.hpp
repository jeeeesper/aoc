#pragma once
#include <sstream>
#include <string>
#include <vector>


namespace util {
std::vector<std::string> split_string(const std::string& s, char delim = ' ');
std::vector<std::string> split_string(const std::string& s,
                                      const std::string& delim = " ");
} // namespace util