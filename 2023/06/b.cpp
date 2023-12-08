#include <cmath>
#include <iostream>
#include <vector>

unsigned long long parse_line() {
  std::string line;
  std::getline(std::cin, line);
  unsigned long long result = 0;
  for (char token : line) {
    if (token >= '0' && token <= '9') {
      result *= 10;
      result += token - '0';
    }
  }
  return result;
}

int main() {
  unsigned long long time = parse_line(), distance = parse_line();
  const double root = std::sqrt(time * time - 4 * distance);
  const double left0 = (time - root) / 2.0;
  const double right0 = (time + root) / 2.0;
  int result = std::ceil(right0 - 1) - std::floor(left0 + 1) + 1;
  std::cout << result << std::endl;
}