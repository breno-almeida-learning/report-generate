defmodule GenReport do
  alias GenReport.Parser

  def build(fileName) when is_bitstring(fileName) do
    fileName |> Parser.parse_file() |> handle_report()
  end

  def build(), do: {:error, "Insira o nome de um arquivo"}

  defp handle_report(result) do
    %{
      "all_hours" => handle_total_hours(result),
      "hours_per_month" => handle_hours_per_month(result),
      "hours_per_year" => handle_hours_per_year(result)
    }
  end

  # GenReport.build("gen_report.csv")
  defp handle_total_hours(data) do
    data
    |> Enum.reduce(%{}, fn [name, hours, _day, _month, _year], result ->
      Map.put(result, name, (result[name] || 0) + hours)
    end)
  end

  defp handle_hours_per_month(data) do
    data
    |> Enum.reduce(%{}, fn [name, hours, _day, month, _year], result ->
      Map.put(
        result,
        name,
        Map.put(result[name] || %{}, month, (result[name][month] || 0) + hours)
      )
    end)
  end

  defp handle_hours_per_year(data) do
    data
    |> Enum.reduce(%{}, fn [name, hours, _day, _month, year], result ->
      Map.put(
        result,
        name,
        Map.put(result[name] || %{}, year, (result[name][year] || 0) + hours)
      )
    end)
  end
end
