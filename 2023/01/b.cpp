#include <iostream>
#include <string>

std::string numStr(int num) {
  switch (num) {
    case 1:
      return "one";
    case 2:
      return "two";
    case 3:
      return "three";
    case 4:
      return "four";
    case 5:
      return "five";
    case 6:
      return "six";
    case 7:
      return "seven";
    case 8:
      return "eight";
    case 9:
      return "nine";
    default:
      exit(1);
  }
}

int main() {
  std::string line;
  int result = 0;
  while (std::getline(std::cin, line)) {
    std::string line_ = line;
    for (size_t i = 0; i < line.size(); i++)
      for (int n = 1; n < 10; n++)
        if (line.substr(i, numStr(n).length()) == numStr(n))
          line.replace(i, numStr(n).length(), std::to_string(n));
    for (size_t i = 0; i < line_.size(); i++)
      for (int n = 1; n < 10; n++)
        if (line_.substr(line_.size() - i - 1, numStr(n).length()) ==
            numStr(n)) {
          line_.replace(line_.size() - i - 1, numStr(n).length(),
                        std::to_string(n));
          i -= numStr(n).length();
        }
    int first, last;


    for (int i = 0;; i++) {
      if (line[i] >= '0' && line[i] <= '9') {
        first = line[i] - '0';
        break;
      }
    }
    for (int i = line_.size() - 1;; i--) {
      if (line_[i] >= '0' && line_[i] <= '9') {
        last = line_[i] - '0';
        break;
      }
    }
    result += 10 * first + last;
  }
  std::cout << result << std::endl;
}