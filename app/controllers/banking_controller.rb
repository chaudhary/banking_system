class BankingController < ApplicationController

  def index
  end

  def deposit
    closing_balance = bank_account.deposit(params[:amount].to_f)
    render(json: {closing_balance: closing_balance}, status: 200)
  end

  def withdraw
    closing_balance = bank_account.withdraw(params[:amount].to_f)
    render(json: {closing_balance: closing_balance}, status: 200)
  end

  def enquiry
    render(json: {current_balance: bank_account.current_balance}, status: 200)
  end

  def download_txns_history
    if params[:account_no].present?
      bank_account = ::BankAccount.where(:account_no => params[:account_no]).first
      raise ::AppException.new("Wrong account no provided") if bank_account.blank?
    end

    txns = AccountTxn.all
    txns = txns.where(:bank_account_id => bank_account.id) if bank_account.present?
    txns = txns.where(:txn_time.gte => Time.parse(params[:from])) if params[:from].present?
    txns = txns.where(:txn_time.lte => Time.parse(params[:to])) if params[:to].present?
    txns = txns.order_by(:txn_time => :asc)

    csv_export = CsvExport.new('txns_history')
    txns.each do |txn|
      csv_export.export_data({
        "Txn Date" => txn.txn_time.strftime("%d/%m/%Y"),
        "Txn Type" => txn.txn_type,
        "Amount" => txn.amount,
        "Closing Balance" => txn.closing_balance
      })
    end
    filepath = csv_export.build
    send_file(filepath, :type => 'text/csv; charset=iso-8859-1; header=present', :disposition => "attachment;data=txns_history.csv")
  end

  private

  def bank_account
    return @bank_account if @bank_account.present?
    raise ::AppException.new("Account no is blank") if params[:account_no].blank?

    @bank_account = ::BankAccount.where(:account_no => params[:account_no]).first
    raise ::AppException.new("Wrong account no provided") if @bank_account.blank?
    return @bank_account
  end


end
