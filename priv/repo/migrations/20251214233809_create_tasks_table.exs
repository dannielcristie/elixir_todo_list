defmodule ElixirTodoList.Repo.Migrations.CreateTasksTable do
  use Ecto.Migration

    def change do
    create table(:tasks) do
      add :title, :string
      add :completed, :boolean, default: false

      timestamps() # Adiciona inserted_at e updated_at
    end
  end
end
