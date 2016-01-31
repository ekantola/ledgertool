class Chart < ActiveRecord::Base
  has_many :acc_trans

  set_table_name 'chart'
end
