defmodule Markov.Chain do


	@resolution 100

	def next_state(init_state, trans_matrix) do
		get_prob_state(trans_matrix, init_state, :rand.uniform(@resolution))
	end

	def run_chain({init_state, prob, num_iterations} = model) do

		:rand.seed(:exs1024, {DateTime.utc_now |> DateTime.to_unix, DateTime.utc_now |> DateTime.to_unix, 42})

		Enum.reduce_while(Stream.cycle([:ok]), {0, num_iterations, [], prob}, fn _, acc ->
			{cur_state, n, c, p} = acc
			next_state = get_prob_state(prob, cur_state, :rand.uniform(@resolution)-1)
			c = c ++ [next_state]
			cond do
			  n > 0 ->
					{:cont, {next_state, n-1, c, p}}
				true ->
				{:halt, {cur_state, next_state, c, p}}
			end
		end)

	end

	defp get_prob_state(p,i,j) do
		Enum.at(Enum.at(p,i), j)
	end

end
