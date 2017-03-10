defmodule TxComparator do
  @doc """
  compare(string1, string2, synonyms_map, words_to_skip_list) tokenises both strings, removes unnecessary words,
  replaces tokens with synonyms where possible and provides a score based on the comparison of the final list of tokens
  """
  def compare(string1, string2, synonyms, words_to_skip) do
    token_list_1 = 
      string1
      |> String.downcase
      |> tokeniser
      |> remove_words(words_to_skip)
      |> generalise(synonyms)
      |> MapSet.new

    token_list_2 = 
      string2
      |> String.downcase
      |> tokeniser
      |> remove_words(words_to_skip)
      |> generalise(synonyms)
      |> MapSet.new

    comparator(token_list_1, token_list_2)
  end

  @doc """
  tokeniser(string) tokenises a string and returns a list of tokens
  """
  def tokeniser(string), do: String.split(string, ~r/[^\p{L}'-]/u, trim: true)

  @doc """
  remove_words(token_list, words_to_skip_list) removes unnecesaary tokens from token_list using the words_to_skip_list
  """
  def remove_words(tokens, words_to_skip), do: Enum.reject(tokens, fn(token) -> Enum.member?(words_to_skip, token) end)

  @doc """
  generalise(token_list, synonym_map) replaces tokens in token_list using synonym_map where possible.
  synonym map should be in the following format: %{"token" => "synonym"}. Please avoid colon-notation for the key-value pairs.
  """
  def generalise(tokens, synonyms) do
    Enum.reduce(tokens, [],
      fn(token, new_tokens) -> 
        case Map.get(synonyms, token) do
          nil -> new_tokens ++ [token]
          synonym -> new_tokens ++ [synonym]
        end
      end
    )
  end

  @doc """
  comparator(token_mapset_1, token_mapset_2) compares two mapsets and returns a score between 0 and 1 based on how much they match.
  """
  def comparator(token_list_1, token_list_2) do
      cond do 
        MapSet.equal?(token_list_1, token_list_2) ->
          1.0
        MapSet.disjoint?(token_list_1, token_list_2) ->
          0.0
        true ->
          common_tokens = MapSet.intersection(token_list_1, token_list_2)
          sizeof_token_list_1 = MapSet.size(token_list_1)
          sizeof_token_list_2 = MapSet.size(token_list_2)
          if sizeof_token_list_1 >= sizeof_token_list_2 do
            MapSet.size(common_tokens)/sizeof_token_list_1
          else
            MapSet.size(common_tokens)/sizeof_token_list_2
          end
      end
  end
end
