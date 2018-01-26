class BankAccount
  include Mongoid::Document

  MAX_LOCK_DURATION = 10.minutes

  field :account_no, type: String
  field :name, type: String
  field :current_balance, type: Float

  field :locked_at, type: Time

  has_many :txns, class_name: 'AccountTxn', inverse_of: :bank_account

  index({account_no: 1}, {background: true, unique: true})

  def deposit(amount)
    raise ::AppException.new("Amount is invalid") if !(amount.is_a?(::Integer) || amount.is_a?(::Float))
    raise ::AppException.new("Amount is invalid") if amount <= 0
    raise ::AppException.new("Another txn is happening, plz try again later") if !(create_lock)

    latest_txn = ::AccountTxn.where(:bank_account_id => self.id).order_by(:txn_time => :desc).first
    old_closing_balance = latest_txn.try(:closing_balance).to_f
    amount = amount.to_f
    closing_balance = old_closing_balance + amount

    txn = ::AccountTxn.new(:amount => amount, :txn_type => AccountTxn::DEPOSIT, :txn_time => Time.now.utc, :bank_account => self, :closing_balance => closing_balance)
    txn.save!

    ::BankAccount.collection.find(account_no: account_no).update_many({"$unset" => {locked_at: true}, "$set" => {current_balance: closing_balance}}, {safe: true})
    return closing_balance
  end

  def withdraw(amount)
    raise ::AppException.new("Amount is invalid") if !(amount.is_a?(::Integer) || amount.is_a?(::Float))
    raise ::AppException.new("Amount is invalid") if amount <= 0
    raise ::AppException.new("Amount to be withdrawn is greater than current balance") if amount > current_balance
    raise ::AppException.new("Another txn is happening, plz try again later") if !(create_lock)

    latest_txn = ::AccountTxn.where(:bank_account_id => self.id).order_by(:txn_time => :desc).first
    old_closing_balance = latest_txn.try(:closing_balance).to_f
    amount = amount.to_f
    closing_balance = old_closing_balance - amount

    txn = ::AccountTxn.new(:amount => amount, :txn_type => AccountTxn::WITHDRAW, :txn_time => Time.now.utc, :bank_account => self, :closing_balance => closing_balance)
    txn.save!

    ::BankAccount.collection.find(account_no: account_no).update_many({"$unset" => {locked_at: true}, "$set" => {current_balance: closing_balance}}, {safe: true})
    return closing_balance
  end

  private

  def create_lock
    selector = ::BankAccount.where(:account_no => account_no).or(:locked_at => nil).or(:locked_at.lt => MAX_LOCK_DURATION.ago).selector
    query_result = ::BankAccount.collection.find(selector).update_many({"$set" => {locked_at: Time.now.utc}}, {safe: true})
    return false if query_result.modified_count == 0
    return true
  end

end
