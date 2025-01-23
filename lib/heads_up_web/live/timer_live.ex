defmodule HeadsUpWeb.TimerLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, sec: "00", min: "00", hr: "00")
    if connected?(socket), do: Process.send_after(self(), :update, 1000)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Timer</h1>
      <section>
        Hours:
        <div>
          {@hr}
          <%!-- render the number of responders here --%>
        </div>
        Mintues
        <div>
          {@min}
          <%!-- render the average minutes per responder here --%>
        </div>
        Seconds
        <div>
          {@sec}
        </div>
      </section>
    </div>
    """
  end

  def handle_info(:update, socket) do
    [hr, min, sec] =
      HeadsUp.Timer.update(socket.assigns.hr, socket.assigns.min, socket.assigns.sec)

    Process.send_after(self(), :update, 1000)
    socket = assign(socket, sec: sec, min: min, hr: hr)
    {:noreply, socket}
  end
end
