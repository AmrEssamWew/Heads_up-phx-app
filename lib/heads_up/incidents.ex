defmodule HeadsUp.Incidents do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id), do: Repo.get!(Incident, id)

  def filtered_incidents(filter) do
    list =
      Incident
      |> search(filter["q"])
      |> filter_status(filter["status"])
      |> sort_by(filter["priority"])
      |> Repo.all()

    IO.inspect(list)
    list
  end

  defp search(query, filter) when not is_nil(filter) and filter != "",
    do: query |> where([r], ilike(r.name, ^"%#{filter}%"))

  defp search(query, _), do: query

  defp filter_status(query, filter) when filter in ~w(pending resolved canceled),
    do: query |> where([r], r.status == ^filter)

  defp filter_status(query, _), do: query
  defp sort_by(query, "asc_priority"), do: query |> order_by(asc: :priority)
  defp sort_by(query, "dsc_priority"), do: query |> order_by(desc: :priority)
  defp sort_by(query, _), do: query

  def urgent_incidents(incident) do
    Process.sleep(2000)

    Incident
    |> where([r], r.id != ^incident.id)
    |> order_by(desc: :priority)
    |> limit(3)
    |> Repo.all()
  end
end
