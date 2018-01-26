class AccountTxn
  include Mongoid::Document

  DEPOSIT = "deposit"
  WITHDRAW = "withdraw"
  TXN_TYPES = [DEPOSIT, WITHDRAW]

  field :amount, type: Float
  validates :amount, presence: true

  field :closing_balance, type: Float
  validates :closing_balance, presence: true

  field :txn_type, type: String
  validates :txn_type, inclusion: {in: TXN_TYPES}

  field :txn_time, type: Time
  validates :txn_time, presence: true

  belongs_to :bank_account, class_name: 'BankAccount', inverse_of: :txns
  validates :bank_account_id, presence: true

  index({bank_account_id: 1}, {background: true})

  after_save do |doc|
    if doc.txn_type == DEPOSIT
      ::AccountTxnMailer.amount_deposited_email(doc).deliver_now
    else
      ::AccountTxnMailer.amount_withdrawn_email(doc).deliver_now
    end
  end
end
