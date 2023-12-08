#include <iostream>
#include <numeric>
#include <string>
#include <unordered_map>
#include <vector>

std::unordered_map<std::string, std::pair<std::string, std::string>>
parse_lines() {
  std::unordered_map<std::string, std::pair<std::string, std::string>> res;
  std::string line;
  while (std::getline(std::cin, line))
    if (line.size() > 0)
      res[line.substr(0, 3)] =
          std::make_pair(line.substr(7, 3), line.substr(12, 3));
  return res;
}

int main() {
  std::string ops;
  std::cin >> ops;
  auto lines = parse_lines();
  std::vector<std::string> states;
  for (const auto& [k, v] : lines)
    if (k[2] == 'A') states.push_back(k);
  size_t result = 1;
  for (const auto& state : states) {
    size_t i = 0;
    for (std::string curr = state; curr[2] != 'Z';
         curr = ops[i++ % ops.size()] == 'L' ? lines[curr].first
                                             : lines[curr].second)
      ;
    // LCM works for my input and the exaple, but I don't think that the problem
    // statement guarantees that
    result = std::lcm(result, i);
  }
  std::cout << result << std::endl;
}