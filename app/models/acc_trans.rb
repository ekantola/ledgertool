class AccTrans < ActiveRecord::Base
  belongs_to :gl, :foreign_key => 'trans_id'
  belongs_to :chart

  set_table_name 'acc_trans'
end
