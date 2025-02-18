defmodule HeadsUp.Admin do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Repo
  import Ecto.Query
  def list_incidents, do: Incident |> order_by(desc: :inserted_at) |> Repo.all()

  def changeset(%Incident{} = incident, attr \\ %{}), do: Incident.changeset(incident, attr)
  def get_incident(id), do: Incident |> Repo.get(id)

  def create_incident(attr) do
    changeset(%Incident{}, attr) |> Repo.insert()
  end

  def edit_incident(incident, params) do
    changeset(incident, params) |> Repo.update()
  end

  def validate(attr), do: Incident.changeset(%Incident{}, attr) |> Map.put(:action, :validate)
end
