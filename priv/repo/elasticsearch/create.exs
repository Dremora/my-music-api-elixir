import Tirexs.HTTP

defmodule Main do
  def main do
    put!("/music", %{
      "mappings" => %{
        "album" => %{
          "properties" => %{
            "artist" => %{
              "analyzer" => "autocomplete",
              "search_analyzer" => "folding",
              "type" => "string"
            },
            "title" => %{
              "analyzer" => "autocomplete",
              "search_analyzer" => "folding",
              "type" => "string"
            },
            "year_search" => %{
              "analyzer" => "autocomplete",
              "search_analyzer" => "folding",
              "type" => "string"
            },
            "year" => %{
              "type" => "integer"
            }
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
