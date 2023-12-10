#include <iostream>
#include <unordered_map>

#include "../common.h"

typedef std::pair<int, int> Point;
constexpr Point left = {0, -1};
constexpr Point right = {0, 1};
constexpr Point up = {-1, 0};
constexpr Point down = {1, 0};

const std::vector<Point> dirs = {up, right, down, left};

const std::unordered_map<char, std::pair<Point, Point>> dir_map = {
    {'|', {up, down}}, {'-', {right, left}}, {'L', {up, right}},
    {'J', {up, left}}, {'7', {down, left}},  {'F', {right, down}}};

void guessStartPos(std::vector<std::vector<char>>& map, Point& start) {
  std::vector<Point> connected_dirs;
  for (const auto& dir : dirs) {
    if (start.first + dir.first < 0 || start.second + dir.second < 0 ||
        (size_t)start.first + dir.first >= map.size() ||
        (size_t)start.second + dir.second >= map[0].size())
      continue;

    const char pipe = map[start.first + dir.first][start.second + dir.second];
    if (pipe == '.') continue;

    Point required = {-dir.first, -dir.second};
    if (dir_map.at(pipe).first == required ||
        dir_map.at(pipe).second == required) {
      connected_dirs.push_back(dir);
    }
  }
  if (connected_dirs.size() == 2) {
    std::pair<Point, Point> node = {connected_dirs[0], connected_dirs[1]};
    for (const auto& [c, ps] : dir_map)
      if (ps == node) map[start.first][start.second] = c;
  }
}

std::vector<Point> getPath(std::vector<std::vector<char>>& map, Point& start) {
  std::vector<std::pair<int, int>> path;
  path.push_back(start);
  Point curr;
  do {
    curr = path.back();
    std::pair<int, int> prevPos{path.size() == 1 ? std::pair<int, int>(-1, -1)
                                                 : *(path.end() - 2)};
    char pipe{map[curr.first][curr.second]};

    std::pair<Point, Point> edges{dir_map.at(pipe)};
    if (prevPos != std::pair<int, int>(curr.first + edges.first.first,
                                       curr.second + edges.first.second)) {
      path.push_back(
          {curr.first + edges.first.first, curr.second + edges.first.second});
    } else {
      path.push_back(
          {curr.first + edges.second.first, curr.second + edges.second.second});
    }

  } while (path.back() != start);
  return path;
}

int main() {
  Point start;
  std::vector<std::vector<char>> map;
  std::string line;
  while (std::getline(std::cin, line)) {
    size_t spos = line.find('S');
    if (spos != std::string::npos) {
      start = {map.size(), spos};
    }
    map.emplace_back();
    for (const char& c : line) map.back().push_back(c);
  }
  guessStartPos(map, start);
  auto p = getPath(map, start);
  size_t res = (p.size() + 1) / 2 - 1;
  std::cout << res << std::endl;
}