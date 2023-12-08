#include <iostream>
#include <set>
#include <algorithm>
#include <numeric>

#include "../common.h"

int main() {
  std::vector<int> matches;
  std::string line;
  while (std::getline(std::cin, line)) {
    auto split = util::split_string(util::split_string(line, ':')[1], '|');
    auto winning = util::split_string(split[0], ' ');
    int score = 0;
    for (auto num : util::split_string(split[1], ' ')) {
      if (std::find(winning.begin(), winning.end(), num) != winning.end()) {
        ++score;
      }
    }
    matches.push_back(score);
  }

  std::vector<int> card_count(matches.size(), 1);
  for (size_t i = 0; i < matches.size(); ++i) {
    for (size_t j = i + 1; j < i + 1 + matches[i]; ++j) {
        card_count[j] += card_count[i];
    }
  }

  std::cout << std::reduce(card_count.begin(), card_count.end()) << std::endl;
}