defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, responders: 0, minutes_per_responder: 10)

    if connected?(socket) do
      Process.send_after(self(), :update, 2000)
    end

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Community Love</h1>
      <section>
        <button phx-click="add">
          + 3
        </button>
        <div>
          {@responders}
          <%!-- render the number of responders here --%>
        </div>
        &times;
        <div>
          {@minutes_per_responder}
          <%!-- render the average minutes per responder here --%>
        </div>
        =
        <div>
          {@minutes_per_responder * @responders}
          <%!-- render the total effort (in minutes) here --%>
        </div>
      </section>
      <form phx-submit="set-minutes">
        <label>Minutes Per Responder:</label>
        <input type="number" name="minutes" value={@minutes_per_responder} />
      </form>
    </div>
    """
  end

  def handle_event("add", _unsigned_params, socket) do
    {:noreply, update(socket, :responders, &(&1 + 3))}
  end

  def handle_event("set-minutes", %{"minutes" => minutes}, socket) do
    {:noreply, update(socket, :minutes_per_responder, fn _ -> String.to_integer(minutes) end)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 2000)
    {:noreply, update(socket, :responders, &(&1 + 3))}
  end
end
