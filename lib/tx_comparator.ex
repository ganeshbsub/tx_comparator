defmodule TxComparator do
  def compare(string1, string2, synonyms, words_to_skip) do
    token_list_1 = 
      string1
      |> String.downcase
      |> tokeniser
      |> Enum.uniq
      |> analyser(synonyms, words_to_skip)

    token_list_2 = 
      string1
      |> String.downcase
      |> tokeniser
      |> Enum.uniq
      |> analyser(synonyms, words_to_skip)

    comparator(token_list_1, token_list_2)
  end

  defp tokeniser(string), do: String.split(string, ~r/[^\p{L}'-]/u, trim: true)

  defp analyser(string, synonyms, words_to_skip) do
    
  end

  defp comparator(token_list_1, token_list_2) do
    
  end
end
