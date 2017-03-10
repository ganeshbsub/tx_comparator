defmodule TxComparatorTest do
  use ExUnit.Case
  doctest TxComparator

  test "strings are tokenised" do
    test_string = "i am a hoo-man (not 2 gorillas)."
    tokens = ["i", "am", "a", "hoo-man", "not", "2", "gorillas"]
    assert TxComparator.tokeniser(test_string) == tokens
  end

  test "words are removed correctly" do
    tokens = ["i", "am", "a", "hoo-man", "not", "2", "gorillas"]
    skip_words = ["am", "2", "not", "blah", "blah2", "a"]
    new_tokens = ["i", "hoo-man", "gorillas"]
    assert TxComparator.remove_words(tokens, skip_words) == new_tokens
  end

  test "tokens are replaced with correct synonyms" do
    tokens = ["gorilla", "hoo-man", "car"]
    synonyms = %{"hoo-man" => "human", "huge-ass-car" => "truck"}
    new_tokens = ["gorilla", "human", "car"]
    assert TxComparator.generalise(tokens, synonyms) == new_tokens
  end

  test "comparison produces correct score on exact match" do
    tokens_mapset_1 = MapSet.new(["ape", "monkey"])
    tokens_mapset_2 = MapSet.new(["monkey", "ape"])
    assert TxComparator.comparator(tokens_mapset_1, tokens_mapset_2) == 1.0
  end

  test "comparison produces correct score on no match" do
    tokens_mapset_1 = MapSet.new(["ape", "monkey"])
    tokens_mapset_2 = MapSet.new(["car", "bluetooth"])
    assert TxComparator.comparator(tokens_mapset_1, tokens_mapset_2) == 0.0
  end

  test "comparison produces correct score on partial match" do
    tokens_mapset_1 = MapSet.new(["ape", "monkey"])
    tokens_mapset_2 = MapSet.new(["monkey", "bluetooth"])
    assert TxComparator.comparator(tokens_mapset_1, tokens_mapset_2) == 0.5
  end

  test "entire flow works correctly and the correct score is produced" do
    string_1 = "Sat-Nav, Radio (including bluetooth), Weed"
    string_2 = "NavSystem, Wi-Fi"
    synonyms = %{"sat-nav" => "navigation", "navsystem" => "navigation", "weed" => "illegal"}
    skip_words = ["including", "a", "the"]
    expected_score = 0.25
    assert TxComparator.compare(string_1, string_2, synonyms, skip_words) == expected_score
  end
end
