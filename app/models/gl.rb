class Gl < ActiveRecord::Base
  has_many :acc_trans, :class_name => 'AccTrans', :foreign_key => 'trans_id', :dependent => :destroy

  set_table_name 'gl'
  set_sequence_name 'id'
end
