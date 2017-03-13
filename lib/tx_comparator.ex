defmodule TxComparator do
  @doc """
  tokenises both strings, removes unnecessary words,
  replaces tokens with synonyms where possible and provides a score based on the comparison of the final list of tokens

  Returns score.

  ## Examples

      iex> TxComparator.compare("a Sat-Nav", "Navigation", %{"sat-nav" => "navigation"}, ["the", "a"])
      1.0
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
  tokenises a string and returns a list of tokens

  Returns `[tokens]`

  ## Examples

      iex> TxComparator.tokeniser("bla-bla black sheep")
      ["bla-bla", "black", "sheep"]
  """
  def tokeniser(string), do: String.split(string, ~r/[^\p{L}'-\d]/u, trim: true)


  @doc """
  removes unnecesaary tokens from token_list using the words_to_skip_list
  
  Returns `[tokens]`

  ## Examples

      iex> TxComparator.remove_words(["a","navigation","with","bluetooth"], ["a", "with"])
      ["navigation", "bluetooth"]
  
  """
  def remove_words(tokens, words_to_skip), do: Enum.reject(tokens, fn(token) -> Enum.member?(words_to_skip, token) end)


  @doc """
  replaces tokens in token_list using synonym_map where possible.
  synonym map should be in the following format: %{"token" => "synonym"}. Please avoid colon-notation for the key-value pairs.
  
  Returns `[tokens]`

  ## Examples

      iex> TxComparator.generalise(["sat-nav","bluetooth"], %{"sat-nav"=>"navigation"})
      ["navigation", "bluetooth"]
  
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
  compares two mapsets and returns a score between 0 and 1 based on how much they match.
  
  Returns `score`

  ## Examples

      iex> TxComparator.comparator(<["sat-nav","bluetooth"]>, <["sat-nav","radio"]>)
      0.5
  
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
