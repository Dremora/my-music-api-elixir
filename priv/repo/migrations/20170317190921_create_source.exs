defmodule MyMusic.Repo.Migrations.CreateMyMusic.Source do
  use Ecto.Migration

  def change do
    create table(:sources) do
      add :accurate_rip, :string
      add :comments, :string
      add :cue_issues, :string
      add :discs, :integer
      add :download, :string, size: 1000
      add :edition, :string
      add :format, :string
      add :location, :string
      add :mbid, :binary_id
      add :tag_issues, :string
      add :album_id, references(:albums, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:sources, [:album_id])
  end
end
