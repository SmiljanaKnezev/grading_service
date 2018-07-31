defmodule GradingService.Router do

  require Logger
  use Plug.Router

  plug Plug.Logger
#   plug Plug.Parsers, parsers: [:urlencoded, :json],
#                      pass:  ["*/*"],
#                      json_decoder: Poison

plug Plug.Parsers, parsers: [:json],
                    pass:  ["application/json"],
                    json_decoder: Poison
                  #  json_decoder: Jason #probam sa poison-om


#- Use usvc
#- Use plain JSON
#- Use curl as a client (edited)

#da li ja response treba da vracam kao json? - da

  plug :match
  plug :dispatch


  post "/register" do
    {:ok, username} = Map.fetch(conn.body_params, "username")
    GradingService.Server.register(username)
    #treba da vrati handle koji je jedinstven
    send_resp(conn, 200, "Successfully registered #{username}!")
  end

  post "/ask_question" do
    {:ok, username} = Map.fetch(conn.body_params, "username")
    question = GradingService.Server.ask_for_question(username)
    send_resp(conn, 200, "How much is #{question}")
  end

  post "/statistics" do
    {:ok, username} = Map.fetch(conn.body_params, "username")
    stat = GradingService.Server.get_statistics(username)
    send_resp(conn, 200, "Statistics for #{username} : #{inspect stat}")
  end

  post "/answer" do
    {:ok, username} = Map.fetch(conn.body_params, "username")
    {:ok, question} = Map.fetch(conn.body_params, "question")
    {:ok, answer} = Map.fetch(conn.body_params, "answer")
    answ = GradingService.Server.answer_question(username, question, answer)
    send_resp(conn, 200, "#{answ}")
  end

  #post "/hello" do
  #  IO.inspect conn.body_params
  #  send_resp(conn, 200, "Success!")
  #end

  get "/grading-service" do
    send_resp(conn, 200, "Hello micro-service!")
  end

  get "/health_check/ping" do
    send_resp(conn, 200, "pong")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

end
