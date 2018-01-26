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
