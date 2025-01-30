defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    socket = stream(socket, :incidents, Incidents.list_incidents())

    socket =
      attach_hook(socket, :log_stream, :after_render, fn
        socket ->
          # inspect the stream
          IO.inspect(socket, lable: "After_render")
          socket
      end)

    {:ok, assign(socket, page_title: "Incidents")}
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

      <div class="incidents" id="incidents" phx-update="stream">
        <HeadsUpWeb.CustomComponents.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end
end
