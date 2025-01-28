defmodule HeadsUpWeb.CustomComponents do
  use HeadsUpWeb, :html

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <.link navigate={~p"/incidents/#{@incident.id}"}>
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
        <div class="details">
          <.badge status={@incident.status} />
          <div class="priority">
            {@incident.priority}
          </div>
        </div>
      </.link>
    </div>
    """
  end

  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :resolved && "text-lime-600 border-lime-600",
      @status == :pending && "text-gray-600 border-gray -600",
      @status == :canceled && "text-amber-600 border-amber-600"
    ]}>
      {@status}
    </div>
    """
  end

  slot :inner_block, required: true
  slot :tagline

  def headline(assigns) do
    assigns = assign_new(assigns, :emoj, fn -> ~w(😎 🤩 🥳) |> Enum.random() end)

    ~H"""
    <div class="headline">
      <h1>
        {render_slot(@inner_block)}
      </h1>
      <div class="tagline">
        {render_slot(@tagline, @emoj)} <%!-- render this div for every tagline slot --%>
      </div>
    </div>
    """
  end
end
