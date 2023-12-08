#include <iostream>

#include "../common.h"

int main() {
  unsigned int id, sum = 0;
  while (std::scanf("Game %u: ", &id) == 1) {
    std::string line;
    std::getline(std::cin, line);
    auto sets = util::split_string(line, "; ");
    size_t max_r = 0, max_g = 0, max_b = 0;
    for (const std::string& set : sets) {
      auto cubes = util::split_string(set, ", ");
      for (const std::string& cube : cubes) {
        auto elem = util::split_string(cube, ' ');
        auto num = std::stoul(elem[0]);
        if (elem[1] == "red" && num > max_r) {
          max_r = num;
        } else if (elem[1] == "green" && num > max_g) {
          max_g = num;
        } else if (elem[1] == "blue" && num > max_b) {
          max_b = num;
        }
      }
    }
    sum += max_r * max_g * max_b;
  }
  std::cout << sum << std::endl;
}