defmodule Lodestone do
  def get_page_data(url) do
    {:ok, response} = HTTPoison.get(url)

    playersOnPage = Floki.find(response.body, ".area_inner_header")
                    |> Floki.find(".player_name_area")
                    |> Floki.find("a")
                    |> Enum.map(&(Floki.text &1))

    ranksOnPage = Floki.find(response.body, ".area_inner_header")
                  |> Floki.find(".player_name_area")
                  |> Floki.find(".fc_member_status")
                  |> Enum.map(&(Floki.text &1))
                  |> Enum.map(&(String.strip &1))

    List.zip([playersOnPage, ranksOnPage])
  end

  @doc ~S"""
  Return preformed urls
  ## Examples
    iex> Lodestone.generate_pages("")
    ["?page=1", "?page=2", "?page=3", "?page=4", "?page=5", "?page=6", "?page=7",
    "?page=8", "?page=9", "?page=10"]
  """
  def generate_pages(url) do
    Enum.to_list 1..10
    |> Enum.map(&("#{url}?page=#{&1}"))
  end

  def get_freecompany_data(fc_id) do
    generate_pages("http://na.finalfantasyxiv.com/lodestone/freecompany/#{fc_id}/member/")
    |> Enum.map(&(get_page_data &1))
    |> Enum.reduce(fn(x, acc) -> acc = x ++ acc end)
  end
end
