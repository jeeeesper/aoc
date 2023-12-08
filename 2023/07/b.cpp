#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

enum Type {
  HighCard,
  OnePair,
  TwoPairs,
  ThreeOfAKind,
  FullHouse,
  FourOfAKind,
  FiveOfAKind,
};

struct Hand {
  std::string hand;
  int bid;
  Type type;
};

std::vector<std::string> split_string_at_neq(std::string& s) {
  std::vector<std::string> res;
  size_t i = 0;
  while (i < s.size()) {
    size_t j = i + 1;
    while (j < s.size() && s[i] == s[j]) ++j;
    res.push_back(s.substr(i, j - i));
    i = j;
  }
  return res;
}

Type get_type(std::string hand) {
  std::sort(hand.begin(), hand.end());
  size_t counts[5] = {0};
  size_t jokers = 0, max_i = 0;;
  for (const auto& s : split_string_at_neq(hand)) {
    if (s[0] == 'J') jokers += s.size();
    else {
      ++counts[s.size() - 1];
      if (s.size() - 1 > max_i) max_i = s.size() - 1;
    }
  }
  if (jokers >= 4) return FiveOfAKind;
  --counts[max_i];
  ++counts[max_i+jokers];
  if (counts[4] == 1) return FiveOfAKind;
  if (counts[3] == 1) return FourOfAKind;
  if (counts[2] == 1 && counts[1] == 1) return FullHouse;
  if (counts[2] == 1) return ThreeOfAKind;
  if (counts[1] == 2) return TwoPairs;
  if (counts[1] == 1) return OnePair;
  return HighCard;
}

int card_val(const char c) {
  switch (c) {
    case 'A':
      return 14;
    case 'K':
      return 13;
    case 'Q':
      return 12;
    case 'T':
      return 10;
    case 'J':
      return 1;
    default:
      return c - '0';
  }
}

int main() {
  std::vector<Hand> hands;
  std::string hand, bid;
  while (std::cin >> hand && std::cin >> bid)
    hands.push_back({hand, std::stoi(bid), get_type(hand)});

  std::sort(hands.begin(), hands.end(), [](const Hand& a, const Hand& b) {
    if (a.type != b.type) return a.type < b.type;
    for (size_t i = 0; i < a.hand.size(); ++i) {
      if (a.hand[i] != b.hand[i])
        return card_val(a.hand[i]) < card_val(b.hand[i]);
    }
    return false;
  });

  for (const auto& h : hands) std::cout << h.hand << " " << h.bid << " " << h.type << std::endl;

  int res = 0;
  for (size_t i = 0; i < hands.size(); ++i) res += hands[i].bid * (i + 1);

  std::cout << res << std::endl;
}