defmodule MyMusic.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use MyMusic.Web, :controller
      use MyMusic.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: MyMusic.Web
      import Plug.Conn
      import MyMusic.Web.Router.Helpers
      import MyMusic.Web.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/my_music/web/templates",
                        namespace: MyMusic.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import MyMusic.Web.Router.Helpers
      import MyMusic.Web.ErrorHelpers
      import MyMusic.Web.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
