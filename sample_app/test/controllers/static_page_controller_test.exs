defmodule SampleApp.StaticPageControllerTest do
  use SampleApp.ConnCase

  test "GET /home", %{conn: conn} do
    conn = get conn, "/home"
    assert html_response(conn, 200) =~ "Welcome to Static Pages Home!"
  end

  test "GET /help", %{conn: conn} do
    conn = get conn, "/help"
    assert html_response(conn, 200) =~ "Welcome to Static Pages Help!"
  end

  test "GET /about", %{conn: conn} do
    conn = get conn, "/about"
    assert html_response(conn, 200) =~ "Welcome to Static Pages About!"
  end
end
