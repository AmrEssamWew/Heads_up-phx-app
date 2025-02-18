defmodule HeadsUpWeb.AdminLive.Incidents.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Admin Incidents List")}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    socket = assign(socket, incidents: Admin.list_incidents())
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Incidnets
      <.link class="button" navigate="/admin/incidents/create">
        Create an incidents
      </.link>
    </.header>
    <div class="admin-index">
      <.table id="incidents" rows={@incidents}>
        <:col :let={incidents} label="Name">{incidents.name}</:col>

        <:col :let={incidents} label="status">
          <HeadsUpWeb.CustomComponents.badge status={incidents.status}>
            {incidents.status}
          </HeadsUpWeb.CustomComponents.badge>
        </:col>

        <:col :let={incidents} label="priority">{incidents.priority}</:col>
        <:col :let={incidents}>
          <.link navigate={~p"/admin/incidents/#{incidents.id}"}> edit </.link>
        </:col>
      </.table>
    </div>
    """
  end
end
