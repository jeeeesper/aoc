#include "common.h"

std::vector<std::string> util::split_string(const std::string& s, char delim) {
  std::vector<std::string> v;
  std::istringstream iss(s);
  for (std::string tmp; std::getline(iss, tmp, delim);) {
    if (tmp.empty()) continue;
    v.push_back(tmp);
  }
  return v;
}

std::vector<std::string> util::split_string(const std::string& s,
                                            const std::string& delim) {
  std::vector<std::string> v;
  std::string::size_type pos1 = 0, pos2;
  while ((pos2 = s.find(delim, pos1)) != std::string::npos) {
    v.push_back(s.substr(pos1, pos2 - pos1));
    pos1 = pos2 + delim.size();
  }
  if (pos1 < s.length()) v.push_back(s.substr(pos1));
  return v;
}

template <typename T>
void util::set_surroundings(std::vector<std::vector<T>>& map, size_t i,
                            size_t j, T value, size_t radius) {
  for (size_t k = i - radius; k <= i + radius; ++k)
    for (size_t l = j - radius; l <= j + radius; ++l)
      if (k < map.size() && l < map[k].size()) map[k][l] = value;
}