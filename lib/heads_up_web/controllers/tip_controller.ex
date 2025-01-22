defmodule HeadsUpWeb.TipController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Tips

  def index(conn, _opts) do
    tips = Tips.list_tips()
    render(conn, :index, tips: tips)
  end
end
