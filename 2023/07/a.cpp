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

Type get_type(std::string hand) {
  std::sort(hand.begin(), hand.end());
  size_t counts[5] = {0};
  char last = hand[0];
  int count = 1;
  for (size_t i = 1; i < hand.size(); ++i) {
    if (last != hand[i]) {
      ++counts[count - 1];
      count = 1;
    } else
      ++count;
    last = hand[i];
  }
  ++counts[count - 1];
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
    case 'J':
      return 11;
    case 'T':
      return 10;
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

  int res = 0;
  for (size_t i = 0; i < hands.size(); ++i) 
    res += hands[i].bid * (i + 1);
  
  std::cout << res << std::endl;
}