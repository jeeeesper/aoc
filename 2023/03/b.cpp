#include <iostream>
#include <string>
#include <vector>

#include "../common.h"

typedef std::vector<int> gear_t;

inline bool is_num(const char c) { return c >= '0' && c <= '9'; }
inline bool is_symbol(const char c) { return !is_num(c) && c != '.'; }

int main() {
  std::vector<std::vector<char>> schematic;
  std::string line;
  while (std::getline(std::cin, line))
    schematic.push_back(std::vector<char>(line.begin(), line.end()));

  std::vector<gear_t*> gears;
  std::vector<std::vector<gear_t*>> gears_map(
      schematic.size(), std::vector<gear_t*>(schematic[0].size(), nullptr));

  for (size_t i = 0; i < schematic.size(); ++i) {
    for (size_t j = 0; j < schematic[i].size(); ++j) {
      if (schematic[i][j] == '*') {
        gear_t* gear = new gear_t();
        gears.push_back(gear);
        util::set_surroundings(gears_map, i, j, gear);
      }
    }
  }

  for (size_t i = 0; i < schematic.size(); ++i) {
    for (size_t j = 0; j < schematic[i].size(); ++j) {
      auto num = 0;
      gear_t* gp = nullptr;
      while (j < schematic[i].size() && is_num(schematic[i][j])) {
        num = num * 10 + (schematic[i][j] - '0');
        if (gears_map[i][j]) gp = gears_map[i][j];
        ++j;
      }
      if (gp) gp->push_back(num);
    }
  }

  unsigned int sum = 0;
  for (auto gear : gears) {
    if (gear->size() != 2) continue;
    sum += (*gear)[0] * (*gear)[1];
  }
  std::cout << sum << std::endl;
  for (auto gear : gears) delete gear;
}