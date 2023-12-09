#include <iostream>
#include <algorithm>

#include "../common.h"

int extrapolate(std::vector<int>& nums) {
  if (std::all_of(nums.begin(), nums.end(), [](int n) { return n == 0; })) return 0;
  int last = nums[nums.size() - 1];
  for (size_t i = 0; i < nums.size() - 1; ++i) {
    nums[i] = nums[i + 1] - nums[i];
  }
  nums.pop_back();
  return last + extrapolate(nums);
}

int main() {
  std::string line;
  int sum = 0;
  while (std::getline(std::cin, line)) {
    std::vector<int> nums;
    for (auto& n : util::split_string(line, ' ')) nums.push_back(std::stoi(n));
    sum += extrapolate(nums);
  }
  std::cout << sum << std::endl;
}