#include "../common.cpp"
#include <iostream>

int main() {
    unsigned int id, sum = 0;
    while (std::scanf("Game %u: ", &id) == 1) {
      std::string line;
      std::getline(std::cin, line);
      auto sets = util::split_string(line, "; ");
      bool possible = true;
      for (const std::string& set : sets) {
        auto cubes = util::split_string(set, ", ");
        for (const std::string& cube : cubes) {
          auto elem = util::split_string(cube, ' ');
          auto num = std::stoul(elem[0]);
          if (elem[1] == "red") {
            possible &= num <= 12;
          } else if (elem[1] == "green") {
            possible &= num <= 13;
          } else if (elem[1] == "blue") {
            possible &= num <= 14;
          }
        }
      }
      if (possible) sum += id;
    }
    std::cout << sum << std::endl;
}