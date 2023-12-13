#include <iostream>
#include <string>
#include <vector>

typedef std::vector<std::vector<char>> Map;

// search for column mirror
size_t find_index(Map& map) {
  for (size_t i = 0; i + 1 < map.size(); i++) {
    bool mirror = true;
    size_t left = i + 1, right = i;
    do {
      left--;
      right++;
      if (map[left] != map[right]) {
        mirror = false;
        break;
      }
    } while (left != 0 && right + 1 < map.size());
    if (mirror) return i + 1;
  }
  return 0;
}

Map transpose(Map& map) {
  Map transposed(map[0].size(), std::vector<char>(map.size()));
  for (size_t i = 0; i < map.size(); i++) {
    for (size_t j = 0; j < map[i].size(); j++) {
      transposed[j][i] = map[i][j];
    }
  }
  return transposed;
}

size_t count(Map& map) {
  size_t result = find_index(map);
  if (result > 0) return 100 * result;
  Map transposed = transpose(map);
  return find_index(transposed);
}

int main() {
  Map map;
  size_t result = 0;
  std::string line;
  while (std::getline(std::cin, line)) {
    if (line != "")
      map.emplace_back(line.begin(), line.end());
    else {
      result += count(map);
      map = Map();
    }
  }
  result += count(map);
  std::cout << result << std::endl;
}