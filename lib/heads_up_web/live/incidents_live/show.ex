defmodule HeadsUpWeb.IncidentLive.Show do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident(id)

    {:noreply,
     assign(socket, incident: incident, urgent_incidents: Incidents.urgent_incidents(incident))}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-show">
      <div class="incident">
        <img src={@incident.image_path} />
        <section>
          <div class="... text-lime-600 border-lime-600">
            {@incident.status}
          </div>
          <header>
            <h2>Flat Tire</h2>
            <div class="priority">
              {@incident.priority}
            </div>
          </header>
          <div class="description">
            <HeadsUpWeb.CustomComponents.badge status={@incident.status} />
          </div>
        </section>
      </div>
      <div class="activity">
        <div class="left"></div>
        <div class="right">
          <.urgent_incidents incidents={@urgent_incidents} />
        </div>
      </div>
    </div>
    """
  end

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <ul class="incidents">
        <li :for={incident <- @incidents}>
          <.link navigate={~p"/incidents/#{incident.id}"}>
            <img src={incident.image_path} /> {incident.name}
          </.link>
        </li>
      </ul>
    </section>
    """
  end
end
