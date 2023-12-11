#include <cmath>
#include <iostream>
#include <string>
#include <vector>

#define FACTOR 1000000

std::vector<std::string> get_map(std::vector<bool>& is_row_empty,
                                 std::vector<bool>& is_col_empty) {
  std::vector<std::string> map;
  bool is_first = true;
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
    is_row_empty.push_back(is_line_empty);
  }
  return map;
}

int main() {
  std::vector<bool> is_row_empty, is_col_empty;
  auto map = get_map(is_row_empty, is_col_empty);

  std::vector<std::pair<size_t, size_t>> universes;
  for (size_t i = 0; i < map.size(); i++) {
    for (size_t j = 0; j < map[i].size(); j++) {
      if (map[i][j] == '#') {
        universes.emplace_back(i, j);
      }
    }
  }

  size_t sum = 0;
  for (size_t a = 0; a < universes.size(); a++) {
    for (size_t b = a + 1; b < universes.size(); b++) {
      auto [x1, y1] = universes[a];
      auto [x2, y2] = universes[b];
      for (size_t x = std::min(x1, x2); x < std::max(x1, x2); x++) {
        sum += is_row_empty[x] ? FACTOR : 1;
      }
      for (size_t y = std::min(y1, y2); y < std::max(y1, y2); y++) {
        sum += is_col_empty[y] ? FACTOR : 1;
      }
    }
  }
  std::cout << sum << std::endl;
}