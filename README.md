Create db indexes from rails console:
```
BankAccount.create_indexes
AccountTxn.create_indexes
```

Create few bank accounts from rails console:
```
BankAccount.create(:account_no => "acc1")
BankAccount.create(:account_no => "acc2")
BankAccount.create(:account_no => "acc3")
```

You can deposit using api:
```
http://localhost:3000/banking/deposit?account_no=<account_no>&amount=<amount>
```

You can withdraw using api:
```
http://localhost:3000/banking/withdraw?account_no=<account_no>&amount=<amount>
```

You can get to know for current balance using api:
```
http://localhost:3000/banking/enquiry?account_no=<account_no>
```

Note: You will be getting proper error message with status code 422 if you are making a wrong request
