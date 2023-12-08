#include <vector>
#include <string>
#include <iostream>

#include "../common.h"

struct Range {
  size_t dest_start;
  size_t source_start;
  size_t len;
};

typedef std::vector<Range> Map;

size_t translate(const size_t input, const Map& map) {
  for (auto range : map) {
    if (input >= range.source_start && input < range.source_start + range.len)
      return range.dest_start + (input - range.source_start);
  }
  return input;
}

int main() {
  std::vector<size_t> seeds;
  std::string line;
  std::getline(std::cin, line);
  line = line.substr(7); // len("seeds: ")
  for (auto seed : util::split_string(line, ' '))
    seeds.push_back(std::stoull(seed));

  std::vector<Map> maps;
  while (std::getline(std::cin, line)) {
    if (line == "") continue;
    if (line.substr(line.size() - 4) == "map:") {
      maps.emplace_back();
      continue;
    }
    auto parts = util::split_string(line, ' ');
    auto dest = std::stoull(parts[0]);
    auto source = std::stoull(parts[1]);
    auto len = std::stoull(parts[2]);
    maps.back().push_back({dest, source, len});
  }

  size_t min = -1;
  for (auto seed : seeds) {
    for (auto map : maps) {
      seed = translate(seed, map);
    }
    if (seed < min) min = seed;
  }
  std::cout << min << std::endl;
}