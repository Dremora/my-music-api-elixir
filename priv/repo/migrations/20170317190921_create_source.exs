defmodule MyMusic.Repo.Migrations.CreateMyMusic.Library.Source do
  use Ecto.Migration

  def change do
    create table(:album_sources) do
      add :accurate_rip, :string
      add :comments, :string
      add :cue_issues, :string
      add :discs, :integer
      add :download, :string, size: 1000
      add :edition, :string
      add :format, :string
      add :location, :string, null: false
      add :mbid, :binary_id
      add :tag_issues, :string
      add :album_id, references(:albums, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:album_sources, [:album_id])
  end
end
