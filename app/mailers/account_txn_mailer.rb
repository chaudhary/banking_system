class ::AccountTxnMailer < ::ApplicationMailer

  def amount_deposited_email(txn)
    @txn = txn
    @to = txn.bank_account.user_email
    @subject = "#{txn.amount} deposited to your account: #{txn.bank_account.account_no}"

    send_mail
  end

  def amount_withdrawn_email(txn)
    @txn = txn
    @to = txn.bank_account.user_email
    @subject = "#{txn.amount} withdrawn from your account: #{txn.bank_account.account_no}"

    send_mail
  end
end
