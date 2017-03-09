defmodule TxComparator do
  def compare(string1, string2, synonyms, words_to_skip) do
    token_list_1 = 
      string1
      |> tokenizer
      |> analyzer(synonyms, words_to_skip)
    token_list_2 = 
      string1
      |> tokenizer
      |> analyzer(synonyms, words_to_skip)
    comparator(token_list_1, token_list_2)
  end

  defp tokenizer(string) do
    
  end

  defp analyzer(string, synonyms, words_to_skip) do
    
  end

  defp comparator(token_list_1, token_list_2) do
    
  end
end
