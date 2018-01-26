Create db indexes from rails console:
```
BankAccount.create_indexes
AccountTxn.create_indexes
```

Create few bank accounts from rails console:
```
BankAccount.create(:account_no => "acc1", :user_name => "Account Holder 1", :user_email => "acc1@gmail.com")
BankAccount.create(:account_no => "acc2", :user_name => "Account Holder 2", :user_email => "acc2@gmail.com")
BankAccount.create(:account_no => "acc3", :user_name => "Account Holder 3", :user_email => "acc3@gmail.com")
```

You can deposit using api:
```
http://localhost:3000/banking/deposit?account_no=<account_no>&amount=<amount>
```
Returns the final closing balance


You can withdraw using api:
```
http://localhost:3000/banking/withdraw?account_no=<account_no>&amount=<amount>
```
Returns the final closing balance


You can get to know for current balance using api:
```
http://localhost:3000/banking/enquiry?account_no=<account_no>
```
Returns the final closing balance


You can download the csv for txns history using the api:
```
http://localhost:3000/banking/download?account_no=<account_no>&from=<from_date>&to=<to_date>
```
All the parameters in the above api are optional.
from_date and to_date should be in dd/mm/yyyy format.


Note:
You will be getting proper error message with status code 422 if you are making a wrong request
I have not considered any authentication mechanism here.
