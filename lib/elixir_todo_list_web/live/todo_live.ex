defmodule ElixirTodoListWeb.TodoLive do
  use ElixirTodoListWeb, :live_view

  alias ElixirTodoList.Repo
  alias ElixirTodoList.Task
  import ElixirTodoListWeb.CoreComponents

  @impl true
  def mount(_params, _session, socket) do
    tasks = Repo.all(Task)
    changeset = Task.changeset(%Task{}, %{})
    form = to_form(changeset)

    socket =
      assign(socket,
        tasks: tasks,
        form: form,
        editing_task_id: nil
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("update_form", %{"title" => new_title}, socket) do
    socket = assign(socket, new_task_title: new_title)
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset = Task.changeset(%Task{}, task_params)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("save_task", %{"task" => task_params}, socket) do
    case %Task{} |> Task.changeset(task_params) |> Repo.insert() do
      {:ok, _task} ->
        socket_atualizado =
          assign(socket,
            tasks: Repo.all(Task),
            form: to_form(Task.changeset(%Task{}, %{}))
          )
          |> put_flash(:info, "Tarefa criada com sucesso!")

        {:noreply, socket_atualizado}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    case Repo.get(Task, id) do
      nil -> socket
      task -> Repo.delete(task)
    end

    socket_atualizado =
      assign(socket, :tasks, Repo.all(Task))
      |> put_flash(:info, "Tarefa removida com sucesso!")

    {:noreply, socket_atualizado}
  end

  @impl true
  def handle_event("toggle_complete", %{"id" => id, "task" => task_params}, socket) do
    task = Repo.get!(Task, id)

    changeset = Task.changeset(task, task_params)

    Repo.update(changeset)

    socket = assign(socket, tasks: Repo.all(Task))

    {:noreply, socket}
  end

  @impl true
  def handle_event("edit_task", %{"id" => id}, socket) do
    {:noreply, assign(socket, editing_task_id: String.to_integer(id))}
  end

  @impl true
  def handle_event("cancel_edit", _params, socket) do
    {:noreply, assign(socket, editing_task_id: nil)}
  end

  @impl true
  def handle_event("save_edit", %{"id" => id, "task" => task_params}, socket) do
    task = Repo.get!(Task, id)

    case Task.changeset(task, task_params) |> Repo.update() do
      {:ok, _task} ->
        socket =
          assign(socket,
            tasks: Repo.all(Task),
            editing_task_id: nil
          )
          |> put_flash(:info, "Tarefa atualizada!")

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Erro ao atualizar tarefa.")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full max-w-lg mx-auto mt-12 p-6 bg-white rounded-lg shadow-md">
      <h1 class="text-3xl font-bold mb-6 text-center text-gray-800">
        Minha Lista de Tarefas
      </h1>

      <.form for={@form} id="task-form" phx-change="validate" phx-submit="save_task">
        <.input
          field={@form[:title]}
          type="text"
          label="Nova Tarefa"
          placeholder="O que precisa ser feito?"
        />
        <.button phx-disable-with="Salvando...">Adicionar Tarefa</.button>
      </.form>

      <div class="mt-8">
        <ul id="task-list">
          <li
            :for={task <- @tasks}
            id={"task-#{task.id}"}
            class="flex justify-between items-center p-3 border-b"
          >
            <%= if @editing_task_id == task.id do %>
              <% task_form = Task.changeset(task, %{}) |> to_form() %>
              <.form
                for={task_form}
                phx-submit="save_edit"
                phx-value-id={task.id}
                id={"edit-form-#{task.id}"}
                class="flex-grow flex items-center gap-2 w-full"
              >
                <.input
                  field={task_form[:title]}
                  type="text"
                  class="flex-grow input input-bordered input-sm w-full"
                  id={"edit-input-#{task.id}"}
                  placeholder="Editar tarefa..."
                />
                <div class="flex gap-2 shrink-0">
                  <.button type="submit" class="btn btn-sm btn-success text-white">
                    Salvar
                  </.button>
                  <.button
                    type="button"
                    phx-click="cancel_edit"
                    class="btn btn-sm btn-ghost"
                  >
                    Cancelar
                  </.button>
                </div>
              </.form>
            <% else %>
              <% task_form = Task.changeset(task, %{}) |> to_form() %>

              <.form
                for={task_form}
                phx-change="toggle_complete"
                phx-value-id={task.id}
                id={"task-item-form-#{task.id}"}
                class="flex-grow"
              >
                <div class="flex items-center space-x-4">
                  <.input
                    type="checkbox"
                    field={task_form[:completed]}
                    id={"task-#{task.id}-completed"}
                    class="flex-shrink-0"
                  />

                  <label
                    class={
                      if task.completed,
                        do: "line-through text-gray-400 italic",
                        else: "text-gray-900 font-medium"
                    }
                    for={"task-#{task.id}-completed"}
                  >
                    {task.title}
                  </label>
                </div>
              </.form>

              <div class="flex space-x-2">
                <.button
                  type="button"
                  phx-click="edit_task"
                  phx-value-id={task.id}
                  class="!p-2 !bg-blue-500 hover:!bg-blue-700 text-white font-bold rounded-full"
                >
                  ✏️
                </.button>
                <.button
                  type="button"
                  phx-click="delete"
                  phx-value-id={task.id}
                  class="!p-2 !bg-red-600 hover:!bg-red-700 text-white font-bold rounded-full"
                >
                  &times;
                </.button>
              </div>
            <% end %>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
