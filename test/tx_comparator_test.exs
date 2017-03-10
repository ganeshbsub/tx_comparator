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
    
  end

  test "comparison produces correct score on no match" do
    
  end

  test "comparison produces correct score on partial match" do
    
  end

  test "entire flow works correctly and the correct score is produced" do
    
  end
end
