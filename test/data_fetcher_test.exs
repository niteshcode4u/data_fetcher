defmodule DataFetcherTest do
  use ExUnit.Case
  doctest DataFetcher

  describe "DataFetcher.fetch/1" do
    test "Success: when url is correct" do
      assert {:ok, %{assets: _asssets, links: _links}} =
               DataFetcher.fetch("http://httparrot.herokuapp.com")

      assert {:ok, %{assets: _asssets, links: _links}} =
               DataFetcher.fetch("https://www.google.com")
    end

    test "Error: when url is incorrect" do
      assert {:error, "Invalid URL"} == DataFetcher.fetch("google.com")
      assert {:error, "Invalid URL"} == DataFetcher.fetch("this is not an url")
    end

    test "Error: when domain is not available" do
      assert {:error, :nxdomain} == DataFetcher.fetch("https://www.googleeee.ceeom/")
      assert {:error, :nxdomain} == DataFetcher.fetch("https://faceeebook.coma")
    end

    test "Error: time and unknown error" do
      # set up
      url1 = "http://example.com:81"
      url2 = "https://faceeebook.com"

      assert {:error, :timeout} == DataFetcher.fetch(url1)
      assert {:error, "302: Unknown error while fetching data"} == DataFetcher.fetch(url2)
    end

    test "Note: return empty incase url not for html page" do
      # set up
      url1 = "https://help.tableau.com/settings.json"
      url2 = "https://cdn.sstatic.net/clc/clc.min.js"

      assert {:ok, %{assets: [], links: []}} = DataFetcher.fetch(url1)
      assert {:ok, %{assets: [], links: []}} = DataFetcher.fetch(url2)
    end
  end
end
