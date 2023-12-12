#include <iostream>
#include <string>
#include <unordered_map>

#include "../common.h"

typedef struct key {
  std::vector<int> gs;
  size_t i;
  bool in_block;
} keyy_t;

struct key_hash {
  std::size_t operator()(const keyy_t& k) const {
    size_t hash = k.gs.size() ^ k.i ^ k.in_block;
    for (size_t i = 0; i < k.gs.size(); ++i) hash ^= k.gs[i] << i;
    return hash;
  }
};

bool operator==(const keyy_t& k1, const keyy_t& k2) {
  return k1.gs == k2.gs && k1.i == k2.i && k1.in_block == k2.in_block;
}

typedef std::unordered_map<keyy_t, size_t, key_hash> cache_t;

size_t count(cache_t& cache, const std::string& s, std::vector<int>& gs,
             size_t i = 0, bool in_block = false);

size_t count_dot(cache_t& cache, const std::string& s, std::vector<int> gs,
                 size_t i, bool in_block) {
  if (in_block) return 0;
  if (!gs.empty() && gs.back() == 0) gs.pop_back();
  return count(cache, s, gs, i + 1, in_block);
}

size_t count_hs(cache_t& cache, const std::string& s, std::vector<int> gs,
                size_t i, bool) {
  if (gs.empty() || gs.back() == 0) return 0;
  --gs.back();
  return count(cache, s, gs, i + 1, gs.back() != 0);
}

size_t count(cache_t& cache, const std::string& s, std::vector<int>& gs,
             size_t i, bool in_block) {
  if (cache.find({gs, i, in_block}) != cache.end()) {
    return cache[{gs, i, in_block}];
  }
  size_t result;
  if (i == s.size())
    result = (gs.empty() || (gs.size() == 1 && gs[0] == 0)) ? 1 : 0;
  else if (s[i] == '.')
    result = count_dot(cache, s, gs, i, in_block);
  else if (s[i] == '#')
    result = count_hs(cache, s, gs, i, in_block);
  else if (s[i] == '?')
    result = count_dot(cache, s, gs, i, in_block) +
             count_hs(cache, s, gs, i, in_block);
  else
    result = 0;
  cache[{gs, i, in_block}] = result;
  return result;
}

int main() {
  std::string s;
  std::vector<std::string> strings;
  std::vector<std::vector<int>> groups;
  while (std::cin >> s) {
    strings.push_back(s + '?' + s + '?' + s + '?' + s + '?' + s);
    groups.emplace_back();
    std::cin >> s;
    for (size_t i = 0; i < 5; ++i)
      for (auto& c : util::split_string(s, ','))
        groups.back().push_back(std::stoi(c));

    std::reverse(groups.back().begin(), groups.back().end());
  }

  size_t result = 0;
  for (size_t i = 0; i < strings.size(); ++i) {
    cache_t cache;
    result += count(cache, strings[i], groups[i]);
  }
  std::cout << result << std::endl;
}