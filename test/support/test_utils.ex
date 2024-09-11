defmodule P2pLoan.TestUtils do

  def to_map_except_fields(struct1, struct2, fields_to_ignore) do
    map1 = Map.drop(Map.from_struct(struct1), fields_to_ignore)
    map2 = Map.drop(Map.from_struct(struct2), fields_to_ignore)
    {map1, map2}
  end
end
