#include <iostream>
#include <string>
#include <vector>

typedef std::vector<std::vector<char>> Map;

// search for column mirror
size_t find_index(Map& map, size_t forbidden_result) {
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
    if (mirror && forbidden_result != i+1) return i + 1;
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

enum Dir { HORIZ, VERT, };

std::pair<Dir, size_t> count(Map& map, size_t forbidden_vert = 0, size_t forbidden_horiz = 0) {
  size_t result = find_index(map, forbidden_horiz);
  if (result > 0) return std::make_pair(HORIZ, result);
  Map transposed = transpose(map);
  return std::make_pair(VERT, find_index(transposed, forbidden_vert));
}

void swap(char* c) {
  if (*c == '#')
    *c = '.';
  else if (*c == '.')
    *c = '#';
  else
    exit(1);
}

size_t try_smudges(Map& map) {
  const auto orig_count = count(map);
  size_t forbidden_horiz = orig_count.first == HORIZ ? orig_count.second : 0;
  size_t forbidden_vert = orig_count.first == VERT ? orig_count.second : 0;
  for (size_t i = 0; i < map.size(); i++) {
    for (size_t j = 0; j < map[i].size(); j++) {
      swap(&map[i][j]);
      auto new_count = count(map, forbidden_vert, forbidden_horiz);
      if (new_count.second > 0 && new_count != orig_count) {
        return (new_count.first == HORIZ ? 100 : 1) * new_count.second;
      }
      swap(&map[i][j]);
    }
  }
  exit(2);
}

int main() {
  Map map;
  size_t result = 0;
  std::string line;
  while (std::getline(std::cin, line)) {
    if (line != "")
      map.emplace_back(line.begin(), line.end());
    else {
      result += try_smudges(map);
      map = Map();
    }
  }
  result += try_smudges(map);
  std::cout << result << std::endl;
}