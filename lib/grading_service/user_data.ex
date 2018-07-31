defmodule UserData do

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: User)
  end

  def add_user(username) do
    #imam slucaj ako je mapa prazna, onda za id stavim 0, u suprotnom izvucem id poslednjeg clana koji je dodat i povecam za 1
    Agent.update(User, fn(state) ->
      Map.put(state, username, %{questions: 0, correct: 0, handle: UUID.uuid4()})
    end)
    Agent.get(User, fn(state) -> Map.get(Map.get(state, username), :handle) end)
  end

  def add_question_asked(username) do
    Agent.update(User, fn(state) ->
      count = get_in(state, [username, :questions])   #dodam i listu sa question_handles?
      put_in(state, [username, :questions], count + 1)
    end)
  end

  def add_correct_answer(username) do
    Agent.update(User, fn(state) ->
      count = get_in(state, [username, :correct])
      put_in(state, [username, :correct], count + 1)
    end)
  end

  def watch(username) do
    Agent.get(User, fn(state) ->
      Map.get(state, username)
    end)
  end

  def watch_all() do
    Agent.get(User, fn(state) ->
      state
    end)
  end

end
