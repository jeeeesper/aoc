#include <iostream>
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
  size_t i = 0;
  for (std::string curr = "AAA"; curr != "ZZZ";
       curr = ops[i++ % ops.size()] == 'L' ? lines[curr].first
                                           : lines[curr].second)
    ;
  std::cout << i << std::endl;
}