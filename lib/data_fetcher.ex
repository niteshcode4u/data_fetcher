defmodule DataFetcher do
  @moduledoc """
  Documentation for `DataFetcher`.
  """

  alias DataFetcher.Helpers.UrlHelper

  @doc """
  Fetch data based on provided URL and return an object with keys {`assets` & `links`}.

  PS: Only worls for valid URLs which return HTML page as response containing `<img>` & `<a>` tags

  Examples:

      iex> url = "http://httparrot.herokuapp.com"
      iex> DataFetcher.fetch(url)
      {:ok,
        %{
          assets: ["https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"],
          links: ["http://github.com/edgurgel/httparrot",
            "http://httparrot.herokuapp.com", "https://httparrot.herokuapp.com",
            "http://httparrot.herokuapp.com", "http://httparrot.herokuapp.com/ip",
            "http://httparrot.herokuapp.com/user-agent",
            "http://httparrot.herokuapp.com/headers",
            "http://httparrot.herokuapp.com/response-headers?k1=v1&k2=v2",
            "http://httparrot.herokuapp.com/get", "http://httparrot.herokuapp.com/gzip",
            "http://httparrot.herokuapp.com/status/418",
            "http://httparrot.herokuapp.com/redirect/6",
            "http://httparrot.herokuapp.com/redirect-to?url=http://example.com",
            "http://httparrot.herokuapp.com/relative-redirect/6",
            "http://httparrot.herokuapp.com/cookies",
            "http://httparrot.herokuapp.com/cookies/set?k1=v1&k2=v2",
            "http://httparrot.herokuapp.com/cookies/delete?k1&k2",
            "http://httparrot.herokuapp.com/basic-auth/user/passwd",
            "http://httparrot.herokuapp.com/hidden-basic-auth/user/passwd",
            "http://httparrot.herokuapp.com/stream/20",
            "http://httparrot.herokuapp.com/delay/3",
            "http://httparrot.herokuapp.com/html",
            "http://httparrot.herokuapp.com/robots.txt",
            "http://httparrot.herokuapp.com/deny",
            "http://httparrot.herokuapp.com/cache",
            "http://httparrot.herokuapp.com/stream-bytes/1024",
            "http://httparrot.herokuapp.com/base64/LytiYXNlNjQrLw",
            "http://httparrot.herokuapp.com/image", "http://postbin.org",
            "http://httpbin.org"]
        }}

      iex> url = "https://help.tableau.com/settings.json"
      iex> DataFetcher.fetch(url)
      {:ok, %{assets: [], links: []}}
  """

  # Assuming this url will return only html data
  def fetch(url) do
    with {:ok, %URI{host: host, scheme: scheme}} <- UrlHelper.validate_url(url),
         {:ok, %HTTPoison.Response{body: page_response, status_code: 200}} <- HTTPoison.get(url),
         assets <-
           UrlHelper.parse_urls_for_http_attrs(page_response, "img", "src", "#{scheme}://#{host}"),
         links <-
           UrlHelper.parse_urls_for_http_attrs(page_response, "a", "href", "#{scheme}://#{host}") do
      {:ok, %{assets: assets, links: links}}
    else
      {:error, :invalid_url} ->
        {:error, "Invalid URL"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "#{status_code}: Unknown error while fetching data"}
    end
  end
end
