#pragma once
#include <algorithm>
#include <sstream>
#include <string>
#include <vector>

namespace util {
std::vector<std::string> split_string(const std::string& s, char delim = ' ');
std::vector<std::string> split_string(const std::string& s,
                                      const std::string& delim = " ");
template <typename T>
void set_surroundings(std::vector<std::vector<T>>& map, size_t i, size_t j,
                      T value, size_t radius = 1);
}  // namespace util