#include <cmath>
#include <iostream>
#include <string>
#include <vector>

std::vector<std::vector<char>> get_map() {
  std::vector<std::string> map;
  bool is_first = true;
  std::vector<bool> is_col_empty;
  std::string line;
  while (std::getline(std::cin, line)) {
    if (is_first) {
      is_col_empty = std::vector<bool>(line.size(), true);
      is_first = false;
    }
    bool is_line_empty = true;
    for (size_t i = 0; i < line.size(); i++) {
      is_col_empty[i] = is_col_empty[i] && line[i] == '.';
      is_line_empty = is_line_empty && line[i] == '.';
    }
    map.push_back(line);
    if (is_line_empty) {
      map.push_back(line);
    }
  }
  std::vector<std::vector<char>> expanded;
  for (size_t i = 0; i < map.size(); i++) {
    expanded.emplace_back();
    for (size_t j = 0; j < map[i].size(); j++) {
      expanded.back().push_back(map[i][j]);
      if (is_col_empty[j]) {
        expanded.back().push_back(map[i][j]);
      }
    }
  }
  return expanded;
}

int main() {
  auto map = get_map();
  std::vector<std::pair<size_t, size_t>> universes;
  for (size_t i = 0; i < map.size(); i++) {
    for (size_t j = 0; j < map[i].size(); j++) {
      if (map[i][j] == '#') {
        universes.emplace_back(i, j);
      }
    }
  }

  size_t sum = 0;
  for (size_t x = 0; x < universes.size(); x++) {
    for (size_t y = x + 1; y < universes.size(); y++) {
      sum += std::abs((int)universes[x].first - (int)universes[y].first) +
             std::abs((int)universes[x].second - (int)universes[y].second);
    }
  }
  std::cout << sum << std::endl;
}