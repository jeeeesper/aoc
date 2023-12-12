#include <iostream>
#include <string>

#include "../common.h"

size_t count(const std::string& s, std::vector<int>& gs, size_t i = 0,
             bool in_block = false);

size_t count_dot(const std::string& s, std::vector<int> gs, size_t i,
                 bool in_block) {
  if (in_block) return 0;
  if (!gs.empty() && gs.back() == 0) gs.pop_back();
  return count(s, gs, i + 1, in_block);
}

size_t count_hs(const std::string& s, std::vector<int> gs, size_t i, bool) {
  if (gs.empty() || gs.back() == 0) return 0;
  --gs.back();
  return count(s, gs, i + 1, gs.back() != 0);
}

size_t count(const std::string& s, std::vector<int>& gs, size_t i,
             bool in_block) {
  if (i == s.size())
    return (gs.empty() || (gs.size() == 1 && gs[0] == 0)) ? 1 : 0;
  if (s[i] == '.') return count_dot(s, gs, i, in_block);
  if (s[i] == '#') return count_hs(s, gs, i, in_block);
  if (s[i] == '?')
    return count_dot(s, gs, i, in_block) + count_hs(s, gs, i, in_block);
  else
    exit(1);
}

int main() {
  std::string s;
  std::vector<std::string> strings;
  std::vector<std::vector<int>> groups;
  while (std::cin >> s) {
    strings.push_back(s);
    groups.emplace_back();
    std::cin >> s;
    for (auto& c : util::split_string(s, ','))
      groups.back().push_back(std::stoi(c));

    std::reverse(groups.back().begin(), groups.back().end());
  }

  size_t result = 0;
  for (size_t i = 0; i < strings.size(); ++i) {
    result += count(strings[i], groups[i]);
  }
  std::cout << result << std::endl;
}