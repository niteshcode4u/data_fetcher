defmodule DataFetcher.Helpers.UrlHelper do
  def validate_url(url) do
    uri = URI.parse(url)

    if uri.scheme != nil && uri.host =~ "." do
      {:ok, uri}
    else
      {:error, :invalid_url}
    end
  end

  def parse_urls_for_http_attrs(page_response, attr, tag, host) do
    page_response
    |> Floki.parse_document!()
    |> Floki.find(attr)
    |> Enum.map(fn {^attr, tags, _} ->
      {^tag, url} = Enum.find(tags, &(&1 |> elem(0) == tag))

      get_valid_url(url, host)
    end)
  end

  defp get_valid_url(url, host) do
    url
    |> validate_url()
    |> case do
      {:ok, %URI{}} -> url
      {:error, :invalid_url} -> Path.join(host, url)
    end
  end
end
