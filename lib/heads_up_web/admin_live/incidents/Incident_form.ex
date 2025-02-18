defmodule HeadsUpWeb.AdminLive.Incidents.Incidentform do
  alias HeadsUp.Admin
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do
    IO.inspect(socket)
    {:ok, assign(socket, page_title: "New Incident")}
  end

  def handle_params(_unsigned_params, _uri, socket) when socket.assigns.live_action == :create do
    changeset = to_form(Admin.changeset(%Incident{}, %{}))

    {:noreply, assign(socket, :form, changeset)}
  end

  def handle_params(%{"id" => id}, _uri, socket) when socket.assigns.live_action == :edit do
    incident = Admin.get_incident(id)
    changeset = to_form(Admin.changeset(incident))
    socket = assign(socket, form: changeset, incident: incident)

    {:noreply, assign(socket, :form, changeset)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      {@page_title}
    </.header>
    <.simple_form id="incident" for={@form} phx-change="validate" phx-submit="save">
      <.input label="name" field={@form[:name]} />
      <.input label="description" type="textarea" field={@form[:description]} />
      <.input
        label="status"
        field={@form[:status]}
        type="select"
        options={[:pending, :resolved, :canceled]}
      />
      <.input label="priority" type="number" field={@form[:priority]} />
      <:actions>
        <.button>Save</.button>
      </:actions>
    </.simple_form>
    """
  end

  def handle_event("validate", %{"incident" => params}, socket) do
    changeset = Admin.validate(params)
    IO.inspect(changeset)
    socket = assign(socket, :form, to_form(changeset))
    {:noreply, socket}
  end

  def handle_event("save", %{"incident" => params}, socket)
      when socket.assigns.live_action == :create do
    case Admin.create_incident(params) do
      {:ok, _raffle} ->
        IO.inspect("zewpew", label: "ok")

        socket =
          socket
          |> put_flash(:info, "Incident Created")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket =
          socket
          |> put_flash(:error, "Incident can't be created")

        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("save", %{"incident" => params}, socket)
      when socket.assigns.live_action == :edit do
    case Admin.edit_incident(socket.assigns.incident, params) do
      {:ok, _raffle} ->
        socket =
          socket
          |> put_flash(:info, "Incident edited")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{}} ->
        socket =
          socket
          |> put_flash(:error, "Incident can't be edited")

        {:noreply, socket}
    end
  end
end
