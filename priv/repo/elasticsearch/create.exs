import Tirexs.HTTP

defmodule Main do
  def main do
    put!("/music", %{
      "mappings" => %{
        "properties" => %{
          "artist" => %{
            "analyzer" => "autocomplete",
            "search_analyzer" => "folding",
            "type" => "text"
          },
          "title" => %{
            "analyzer" => "autocomplete",
            "search_analyzer" => "folding",
            "type" => "text"
          },
          "year" => %{
            "type" => "integer",
            "fields" => %{
              "search" => %{
                "analyzer" => "autocomplete",
                "search_analyzer" => "folding",
                "type" => "text"
              }
            }
          },
          "first_played" => %{
            "type" => "date",
            "format" => "yyyy-M-d||yyyy-M||yyyy||epoch_second"
          }
        }
      },
      "settings" => %{
        "analysis" => %{
          "analyzer" => %{
            "autocomplete" => %{
              "filter" => ["lowercase", "asciifolding", "autocomplete_filter"],
              "tokenizer" => "standard",
              "type" => "custom"
            },
            "folding" => %{
              "filter" => ["lowercase", "asciifolding"],
              "tokenizer" => "standard",
              "type" => "custom"
            }
          },
          "filter" => %{
            "autocomplete_filter" => %{
              "max_gram" => 20,
              "min_gram" => 1,
              "type" => "edge_ngram"
            }
          }
        },
        "number_of_shards" => 1
      }
    })
  end
end

Main.main()
