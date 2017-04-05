defmodule Markov.Utils do

	@moduledoc """
		Markov matrix utilities
	"""

	@resolution 100

	@doc """
		 build a state transition matrix from a probability matrix
		 for example, given 3 nodes in a chain
		 prob([[0.5, 0.25, 0.25],[0.5, 0.25, 0.25],[0.5, 0.25, 0.25]])

	"""
	def prob(m) do
		cond do
			is_valid? m ->
				Enum.reduce(0..length(m) - 1, [], fn r, acc ->
					acc ++ [prob_row(Enum.at(m,r))] end)
			true ->
				 :invalid_matrix
		end
	end

	defp prob_row(r) do
		p = Enum.reduce(0..length(r)-1, [], fn (n,n_acc) ->
			n_acc ++ Enum.reduce(cum(r, n)..cum(r,n+1)-1, [], fn _,acc-> acc ++ [n] end)
		end)

		# if the list isn't full, add the remaining items randomly to the end
		cond do
			length(p) < @resolution ->
				#IO.puts "list isnt complete #{length(p)} ... adding #{inspect @resolution - length(p)}"
				p ++ Enum.reduce(0..(@resolution - length(p)-1), [], fn _,acc-> acc ++ [rem(:rand.uniform(@resolution),length(r))] end)
			true ->
				#IO.puts "list is complete."
				p
		end
	end

	defp cum(r, 0) when is_list(r), do: 0
	defp cum(r, n) when is_list(r) do
		round(Enum.reduce(1..n, 0, fn n,acc-> acc + Enum.at(r, n - 1)*@resolution end))
	end

	defp is_valid?(p) do
		Enum.all?(p, fn r -> Enum.sum(r) == 1.0 end) && Enum.all?(p, fn r -> length(p) == length(r) end)
	end
end
