#include <iostream>
#include <list>
#include <string>
#include <vector>

#include "../common.h"

typedef std::pair<std::string, int> lens;
typedef std::vector<std::list<lens>> HashMap;

size_t hash(const std::string& str) {
  size_t current = 0;
  for (char c : str) {
    current += c;
    current *= 17;
    current %= 256;
  }
  return current;
}

int main() {
  std::string input;
  std::cin >> input;

  auto map = HashMap(256);
  for (auto& str : util::split_string(input, ",")) {
    size_t equalsign = str.find("=");
    if (equalsign != std::string::npos) {
      auto label = str.substr(0, equalsign);
      auto h = hash(label);
      auto elem = std::find_if(map[h].begin(), map[h].end(),
                               [&](const lens& l) { return l.first == label; });
      if (elem != map[h].end())
        elem->second = std::stoi(str.substr(equalsign + 1));
      else
        map[h].push_back(lens(label, std::stoi(str.substr(equalsign + 1))));
    } else {  // label-
      auto label = str.substr(0, str.size() - 1);
      auto h = hash(label);
      map[h].remove_if([&](const lens& l) { return l.first == label; });
    }
  }

  size_t result = 0;
  for (size_t i = 0; i < map.size(); ++i) {
    size_t pos = 0;
    for (auto& [_, focal_length] : map[i])
      result += (i + 1) * (++pos) * focal_length;
  }
  std::cout << result << std::endl;
}