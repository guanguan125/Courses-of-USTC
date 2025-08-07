
function set_index = lifting_size_table_lookup(Z)

first_element = bitshift(Z, -ntz(Z));

lut = [1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8];

if first_element > 15
  error('wrong input parameter Z in lift_size_table_lookup.');    
end

set_index = lut(first_element);

if set_index == 0
  error('wrong input parameter Z in lift_size_table_lookup.');    
end

end