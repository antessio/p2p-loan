# p2p-loan

**Domain entities:**

Wallet
- owner id
- amount
- currency
- movements
    - amount
    - date
- **findWalletByOwnerId**
- **topUpWallet** (TODO)
- **chargeWallet**: used internally to charge interests

Loan
- status: 
    - requested: initial status, the requester submitted the request
    - approved: an interest rate has been set for the loan and investors can contribute to the loan
    - ready_to_be_issued: the investors covered the loan amount, the loan can be issued to the requester
    - issued: the loan amount is given to the requester
    - refused: the loan can't be approved
    - expired: one or more interest charges have not been payed
- amount
- currency
- interest rate
- Contributions
    - amount
    - contributor id
- **findLoansRequested** (TODO): used by admin to approve loans
- **findMyLoans** (TODO)
- **findMyContributions** (TODO): to get the loans where a user has invested
- **contribute** (TODO)
- **refuseContribution** (TODO): to cancel a loan contribution, if the loan is not issued
- **cancelLoan** (TODO): revert the loan, returns all the contribution to investors

Interested charges
- debtor id
- loan_id
- amount
- status: 
    - paid
    - expired
    - to_pay
- due_date
- **createFromLoanApproved**: not exposed, automatically triggered on loan issuing
- **charge**: use by admins to trigger the charges of loans' interests
- **findByDueDate**: not exposed, used by the charging process
- **getInterestChargesByLoanOwner**
- **getInterestChargesByLoanId**


## Roles

Admin: can admin loans and wallets
User: can see only loans that requested or loans where it contributed, can see its wallet


## Loans page

Both wallets and loans are associated with users. 
There is an action to create a wallet and another to top-up the wallet (of course is a fake top-up). 
When a user submits a loan request a new loan is created with a status REQUESTED. 

Other users can contribute to the loan by clicking on the action “participate”. When clicking on the action the user has to put the amount that wants to put into this loan. 

This amount will be taken out of its wallet and in case the loan will not succeed, the money will go back to its wallet. 
It contains all the requested loans and allows users to participate. It shows also the sum of the loan contributions. When this reaches the requested amount the loan passes to the next stage which is the approval. In this case, only the admin can see it and click on “Approve” or “Refuse”. 

Clicking on “Approve” the admin will choose the interest rate and the loan status will change. Also, the interest charges will be created from the loan for each contributor and the loan owner's wallet will be topped up by the amount of the loan. 

Every month/day/hour/minute after its approval, the system will charge the interest due at that particular date.

When the loan owner pays the interest charge, the money is transferred to the contributor's wallet. 
If the loan owner doesn’t have enough money to pay all the contributors, then the loan status is updated to EXPIRED.

Admin: 
- ~~get all loans~~
- ~~approve a loan~~
- get interest charges
- get expired loans

User: 
- get my loans
- get loans where I contributed
- ~~contribute to a loan~~
- ~~request a loan~~

## Wallet 

It simply shows the owner and the amount. Potentially also the transactions, but this would make it more complicated. 

After implementing the core logic this could be experimented with using CQRS and event-sourcing. 

User: 
- get my wallet

Admin:
- ~~get all wallets~~
- ~~create a wallet~~
- ~~top-up a wallet~~




