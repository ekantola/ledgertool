class Id < ActiveRecord::Base
  set_table_name 'id'
  set_primary_key :sequence_name
end
