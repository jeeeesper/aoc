#include <iostream>
#include <string>

int main() {
  std::string line;
  int result = 0;
  while (std::getline(std::cin, line)) {
    bool init = false;
    int first, last;
    for (const char c : line) {
      if (c >= '0' && c <= '9') {
        if (!init) {
          first = c - '0';
          init = !init;
        }
        last = c - '0';
      }
    }
    result += 10 * first + last;
  }
  std::cout << result << std::endl;
}