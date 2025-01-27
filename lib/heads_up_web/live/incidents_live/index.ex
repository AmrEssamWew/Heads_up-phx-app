defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    socket = assign(socket, :incidents, Incidents.list_incidents())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <HeadsUpWeb.CustomComponents.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </HeadsUpWeb.CustomComponents.headline>

      <div class="incidents">
        <HeadsUpWeb.CustomComponents.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end
end
