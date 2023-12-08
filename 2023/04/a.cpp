#include <iostream>
#include <set>
#include <algorithm>

#include "../common.h"

int main() {
  unsigned int sum;
  std::string line;
  while (std::getline(std::cin, line)) {
    auto split = util::split_string(util::split_string(line, ':')[1], '|');
    auto winning = util::split_string(split[0], ' ');
    int score = 0;
    for (auto num : util::split_string(split[1], ' ')) {
      if (std::find(winning.begin(), winning.end(), num) != winning.end()) {
        score = (score == 0) ? 1 : score * 2;
      }
    }
    sum += score;
  }
  std::cout << sum << std::endl;
}