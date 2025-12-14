defmodule ElixirTodoList.Task do
  use Ecto.Schema
  import Ecto.Changeset

  # "schema" espelha a tabela "tasks" no banco
  schema "tasks" do
    field(:title, :string)
    field(:completed, :boolean, default: false)
    timestamps(type: :utc_datetime)
  end

  # Define como validar os dados antes de salvar
  def changeset(task_struct, attrs) do
    task_struct
    |> cast(attrs, [:title, :completed])
    |> validate_required([:title])
  end
end
