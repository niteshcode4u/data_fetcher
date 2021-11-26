defmodule DataFetcher.Helpers.UrlHelperTest do
  use ExUnit.Case
  doctest DataFetcher

  alias DataFetcher.Helpers.UrlHelper

  describe "DataFetcher.Helpers.UrlHelper.validate_url/1" do
    test "Success: when url is correct" do
      assert {:ok, %URI{}} = UrlHelper.validate_url("http://example.com")
      assert {:ok, %URI{}} = UrlHelper.validate_url("https://www.google.com")
    end

    test "Error: when url is incorrect" do
      assert {:error, :invalid_url} == UrlHelper.validate_url("google.com")
      assert {:error, :invalid_url} == UrlHelper.validate_url("this is not a valid url")
    end
  end
end
