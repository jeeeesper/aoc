#include <iostream>
#include <string>
#include <vector>

int main() {
  std::vector<std::string> map;
  std::string line;
  while (std::cin >> line) map.push_back(line);

  for (size_t row = 0; row < map.size(); ++row)
    for (size_t col = 0; col < map[row].size(); ++col) {
      if (map[row][col] != 'O') continue;
      for (size_t i = row; i != 0 && map[i - 1][col] == '.'; --i)
        std::swap(map[i][col], map[i - 1][col]);
    }

  for (auto line : map) std::cout << line << std::endl;

  size_t result = 0;
  for (size_t row = 0; row < map.size(); ++row)
    for (char c : map[row])
      if (c == 'O') result += map.size() - row;

  std::cout << result << std::endl;
}