defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Incidents",
       form: to_form(%{})
     )}
  end

  def handle_params(params, _uri, socket) do
    socket = stream(socket, :incidents, Incidents.filtered_incidents(params), reset: true)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <.filter_form form={@form} />
      <HeadsUpWeb.CustomComponents.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
      </HeadsUpWeb.CustomComponents.headline>

      <div class="incidents" id="incidents" phx-change="stream">
        <HeadsUpWeb.CustomComponents.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form phx-change="filter" for={@form}>
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[:pending, :resolved, :canceled]}
      />
      <.input
        type="select"
        field={@form[:priority]}
        prompt="sort by"
        options={["Priority: High to low": "dsc_priority", "Priority: low to high": "asc_priority"]}
      />
    </.form>
    """
  end

  def handle_event("filter", params, socket) do
    params = params |> Map.take(~w(q priority status)) |> Map.reject(fn {_, v} -> v == "" end)

    socket =
      socket
      |> assign(:form, to_form(params))
      |> push_patch(to: ~p"/incidents/?#{params}")

    {:noreply, socket}
  end
end
