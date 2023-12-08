#include <iostream>
#include <string>
#include <vector>

#include "../common.h"

inline bool is_num(const char c) { return c >= '0' && c <= '9'; }
inline bool is_symbol(const char c) { return !is_num(c) && c != '.'; }

int main() {
  std::vector<std::vector<char>> schematic;
  std::string line;
  while (std::getline(std::cin, line))
    schematic.push_back(std::vector<char>(line.begin(), line.end()));

  std::vector<std::vector<bool>> mask(
      schematic.size(), std::vector<bool>(schematic[0].size(), false));
  for (size_t i = 0; i < schematic.size(); ++i) {
    for (size_t j = 0; j < schematic[i].size(); ++j) {
      if (is_symbol(schematic[i][j])) {
        util::set_surroundings(mask, i, j, true);
      }
    }
  }

  unsigned int sum = 0;
  for (size_t i = 0; i < schematic.size(); ++i) {
    for (size_t j = 0; j < schematic[i].size(); ++j) {
      auto num = 0;
      bool count = false;
      while (j < schematic[i].size() && is_num(schematic[i][j])) {
        num = num * 10 + (schematic[i][j] - '0');
        count |= mask[i][j];
        ++j;
      }
      if (count) sum += num;
    }
  }
  std::cout << sum << std::endl;
}