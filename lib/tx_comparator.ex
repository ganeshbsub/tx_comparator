defmodule TxComparator do
  def compare(string1, string2, synonyms, words_to_skip) do
    token_list_1 = 
      string1
      |> String.downcase
      |> tokeniser
      |> remove_words(words_to_skip)
      |> generalise(synonyms)
      |> MapSet.new

    token_list_2 = 
      string1
      |> String.downcase
      |> tokeniser
      |> remove_words(words_to_skip)
      |> generalise(synonyms)
      |> MapSet.new

    comparator(token_list_1, token_list_2)
  end

  defp tokeniser(string), do: String.split(string, ~r/[^\p{L}'-]/u, trim: true)

  defp remove_words(tokens, words_to_skip), do: Enum.reject(tokens, fn(token) -> Enum.member?(words_to_skip, token) end)

  defp generalise(tokens, synonyms) do
    Enum.reduce(tokens, fn(token, new_tokens) -> 
                          case Map.get(synonyms, token) do
                            nil -> new_tokens ++ [token]
                            synonym -> new_tokens ++ [synonym]
                          end
                        end)
  end

  defp comparator(token_list_1, token_list_2) do
    
  end
end
