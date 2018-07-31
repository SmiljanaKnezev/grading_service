defmodule GradingService.Server do



  def check_answer(question, answer) do
    generate_questions_map()
    |> Enum.find(fn {_key, val} -> String.equivalent?(List.first(Map.keys(val)), question) end)
    |> Tuple.to_list()
    |> List.last()
    |> Map.values()
    |> Enum.member?(answer)
  end

  def generate_questions_map() do
    %{ 1 => %{"2 + 2 = ?" => 4},
    2 => %{"10 - 5 = ?" => 5},
    3 => %{"5 + 6 = ?" => 11},
    4 => %{"2 + 28 = ?" => 30},
    5 => %{"11 - 7 = ?" => 4},
    6 => %{"19 - 6 = ?" => 3},
    7 => %{"14 + 5 = ?" => 19},
    8 => %{"20 - 2 = ?" => 18},
    9 => %{"5 + 5 = ?" => 10},
    10 => %{"13 - 3 = ?" => 10},
   11 => %{"9 + 9 = ?" => 18}
  }
  end

  def generate_question() do
    Map.get(generate_questions_map(), Enum.random(1..11))
  end

  def register(username) do
     UserData.add_user(username)
  end

  def ask_for_question(username) do
    UserData.add_question_asked(username)  #treba mi neka veza izmedju username i question handle-a
    {{:question, Map.keys(generate_question())}, {:question_handle, UUID.uuid4()}} #treba da vrati i question handle, vraca tuple?
  end

  def answer_question(question_handle, question, answer) do  #trebalo bi da zabranim da se ponovo odgovara na pitanje ako je jednom vec odgovoreno
    if check_answer(question, answer) do
      UserData.add_correct_answer(username)
      "The answer is correct"
    else
      "Sorry, wrong answer"
    end
  end

  #ovo cu morati da modifikujem, i ovo da ide preko handle?
  def get_statistics(username) do
    data = UserData.watch(username)
    "questions: " <> Integer.to_string(Map.get(data, :questions)) <> " correct: " <> Integer.to_string(Map.get(data, :correct))
  end

end
