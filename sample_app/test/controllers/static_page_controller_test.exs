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

  test "GET /home in floki", %{conn: conn} do
    get(conn, "/home")
    |> html_response(200)
    |> Floki.find("h2")
    |> Floki.DeepText.get
    |> assert("Welcome to Static Pages Home!")
  end

  test "GET /home 2 in floki", %{conn: conn} do
    get(conn, "/home")
    |> html_response(200)
    |> Floki.find("ul li")
    |> Floki.find("li a")
    |> Floki.attribute("href")
  end
end
