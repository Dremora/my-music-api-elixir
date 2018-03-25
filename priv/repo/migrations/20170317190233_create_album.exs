defmodule MyMusic.Repo.Migrations.CreateMyMusic.Libary.Album do
  use Ecto.Migration

  def change do
    create table(:albums, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :artist, :string
      add :comments, :string
      add :first_played_timestamp, :utc_datetime
      add :first_played_date, {:array, :integer}
      add :title, :string
      add :year, :integer

      timestamps()
    end
  end
end
