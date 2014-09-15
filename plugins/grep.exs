defmodule ElixgrepPlugin do
  
  @module_doc """
    This is a test plugin that should work exactly the same as the default
    functions used in elixgrep. All plugins must send the :all_done_boss 
    message after finalization. 
  """
  
  def reduce(options) do 
        receive do
          { :item, path, results } ->  
            results |> Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
            gr_reduce(options)

          { :finalize } -> 
            send options.master_pid, { :all_done_boss }
            exit(:normal)

        end 
  end 

  def map(options,path) do
    %{ search: string } = options 
      File.stream!(path)
    |>
      Stream.filter(fn(line) -> String.contains?(line,string) end )
    |> 
      Enum.map( fn(x) -> x end )
  end 

end 