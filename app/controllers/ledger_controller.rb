require 'hpricot'

class String
  def to_date
    day, mon, year = self.split('.')
    Date.parse("#{year}-#{mon}-#{day}", true)
  end
end

class Tx
  TODO_ACCNO = '7110'

  attr_reader :ref, :date, :actor, :type, :message, :amount, :account, :acc_name

  def initialize(ref, dummy, date, actor, type, message, amount, account, *rest)
    @ref = ref.to_i
    raise "Invalid reference: #{@ref}" if (@ref <= 0)
    @ref = @ref.to_s.rjust(3, '0')

    @date = date.to_date
    @actor = actor.strip

    @type = type.strip
    @message = message.strip
    if @message.empty?
      @message = @type
    else
      @message = @type + ": " + @message unless @type.empty?
    end

    @amount = amount.gsub(/[. ]/, '').gsub(',', '.').to_f
    @account = account
    
    chart = (Chart.find_by_accno(account) or Chart.find_by_accno(TODO_ACCNO))
    @acc_name = chart.description
  end

  def <=>(other)
    return @ref <=> other.ref
  end

  def to_s
    s = ""
    self.instance_variables.each do |var|
      fld_name = var[1..-1]
      s += "#{fld_name}=#{self.send(fld_name)} "
    end

    return s
  end
end

class LedgerController < ApplicationController
  skip_before_filter :verify_authenticity_token

  OTHER_ACCNO = '1110'
  EMPLOYEE_ID = 10001

  def index
    redirect_to :action => 'edit'
  end

  def edit
    if session[:data]
      flash[:notice] = "Unconfirmed data was found in session. Confirm or cancel before importing new data!"
      redirect_to :action => 'confirm'
    end
  end

  def submit
    if (params[:data])
      doc = Hpricot(params[:data])

      txs = []
      error_count = 0
      (doc/"//tr").each do |tr|
        args = (tr/"td").collect do |td|
          td.inner_text.gsub(/&nbsp;/i, '').sub(/^\?/, '').sub(/\?$/, '').strip
        end

        begin
          txs << Tx.new(*args)
        rescue
          error_count += 1
          logger.debug "Error creating new tx: " + $!
        end
      end

      if txs.empty?
        flash[:notice] = "Nothing to import, found 0 transactions (#{error_count} errors)"
        redirect_to :action => 'edit'
      else
        session[:data] = txs.sort
        flash[:notice] = "Note: #{error_count} lines could not be parsed (e.g. empty lines?)" if error_count > 0
        redirect_to :action => 'confirm'
      end
    else
      empty_data_error
    end
  end

  def confirm
    if session[:data].nil?
      empty_data_error
    else
      @txs = session[:data]
    end
  end

  def import
    txs = session[:data]

    if txs.nil?
      @txs_size = nil
    else
      @txs_size = txs.size
      errors = insert(session[:data])
      if errors.count > 0
        flash[:notice] = "Import complete, errors:\n#{errors.join("\n")}" if errors.count > 0
      else
        flash[:notice] = "Import complete"
      end

      session[:data] = nil
    end

    redirect_to :action => 'edit'
  end

  def import_json # old JSON version
    # Return JSON data
    headers["Content-Type"] = "text/plain; charset=utf-8"
    txs = session[:data]

    if txs.nil?
      render_text '{"result": "Nothing to import!"}'
    else
      txs_size = txs.size
      success_count = txs_size - insert(session[:data]).size

      session[:data] = nil

      render_text '{"result": "Successfully imported ' + success_count.to_s + ' of total ' + txs_size.to_s + ' transactions."}'
    end
  end

  def cancel
    session[:data] = nil
    flash[:notice] = "Import cancelled"
    redirect_to :action => 'edit'
  end

  def empty_data_error
    flash[:notice] = "Empty data"
    redirect_to :action => 'edit'
  end

  def insert(data)
    errors = []
    other_chart = Chart.find_by_accno(OTHER_ACCNO)

    data.each do |tx|
      begin
        Gl.transaction do
          gl = Gl.new(:reference => tx.ref, :description => tx.message, :transdate => tx.date, :employee_id => EMPLOYEE_ID, :notes => tx.actor)
          gl.save!

          chart = Chart.find_by_accno(tx.account) or raise(ActiveRecord::RecordNotFound, "No account with accno #{tx.account}")

          gl.acc_trans.create(:chart => chart, :amount => tx.amount, :transdate => tx.date, :source => tx.ref)
          gl.acc_trans.create(:chart => other_chart, :amount => -tx.amount, :transdate => tx.date, :source => tx.ref)
        end
      rescue ActiveRecord::ActiveRecordError
        msg = "Could not save gl from #{tx}: #{$!}"
        logger.warn msg
        errors << msg
      end
    end

    return errors
  end
end

