#include <cmath>
#include <iostream>
#include <vector>

#include "../common.h"

std::vector<int> parse_line() {
  std::string line;
  std::getline(std::cin, line);
  std::vector<std::string> tokens = util::split_string(line, ' ');
  std::vector<int> out;
  for (size_t i = 1; i < tokens.size(); ++i)
    out.push_back(std::stoi(tokens[i]));
  return out;
}

int main() {
  std::vector<int> times = parse_line(), distances = parse_line();
  int result = 1;
  for (size_t i = 0; i < times.size(); ++i) {
    const double root = std::sqrt(times[i] * times[i] - 4 * distances[i]);
    const double left0 = (times[i] - root) / 2.0;
    const double right0 = (times[i] + root) / 2.0;
    result *= std::ceil(right0 - 1) - std::floor(left0 + 1) + 1;
  }
  std::cout << result << std::endl;
}