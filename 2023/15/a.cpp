#include <iostream>
#include <string>

#include "../common.h"

size_t hash(const std::string& str) {
  size_t current = 0;
  for (char c : str) {
    current += c;
    current *= 17;
    current %= 256;
  }
  return current;
}

int main() {
  std::string input;
  std::cin >> input;
  size_t result = 0;
  for (auto& str : util::split_string(input, ",")) result += hash(str);
  std::cout << result << std::endl;
}