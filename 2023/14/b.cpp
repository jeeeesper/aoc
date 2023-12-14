#include <iostream>
#include <string>
#include <tuple>
#include <unordered_map>
#include <vector>

typedef std::vector<std::vector<char>> Map;

void roll_clockwise(Map& map) {
  if (map.size() != map[0].size()) exit(1);
  const size_t n = map.size();
  for (size_t i = 0; i < n / 2; ++i) {
    for (size_t j = i; j < n - i - 1; ++j) {
      char tmp = map[i][j];
      map[i][j] = map[n - j - 1][i];
      map[n - j - 1][i] = map[n - i - 1][n - j - 1];
      map[n - i - 1][n - j - 1] = map[j][n - i - 1];
      map[j][n - i - 1] = tmp;
    }
  }
}

void iterate(Map& map) {
  for (size_t k = 0; k < 4; ++k) {
    for (size_t row = 0; row < map.size(); ++row)
      for (size_t col = 0; col < map[row].size(); ++col) {
        if (map[row][col] != 'O') continue;
        for (size_t i = row; i != 0 && map[i - 1][col] == '.'; --i)
          std::swap(map[i][col], map[i - 1][col]);
      }
    roll_clockwise(map);
  }
}

std::string board_to_string(Map& map) {
  std::string s = "";
  for (auto& line : map) s += std::string(line.begin(), line.end());
  return s;
}

int main() {
  Map map;
  std::string line;
  while (std::cin >> line) map.emplace_back(line.begin(), line.end());

  std::unordered_map<std::string, size_t> known_maps;
  size_t iter = 0;
  for (; true; ++iter) {
    iterate(map);
    auto map_str = board_to_string(map);
    if (known_maps.count(map_str)) {
      for (size_t i = 1;
           i < (1000000000ul - iter) % (iter - known_maps[map_str]); ++i)
        iterate(map);
      break;
    }
    known_maps[map_str] = iter;
  }

  size_t result = 0;
  for (size_t row = 0; row < map.size(); ++row)
    for (char c : map[row])
      if (c == 'O') result += map.size() - row;

  std::cout << result << std::endl;
}