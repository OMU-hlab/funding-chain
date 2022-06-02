## What is MAZUME?
There are 3 roles in this system.
- drafter: submit project ideas
- voter: vote for ideas.
- customer: invest in ideas. comment on ideas. like ideas

The submitted ideas are eligible for investment if they meet certain conditions.
We are planning to implement the system in such a way that a certain percentage of voters will vote for an idea when it is implemented in the system.

For the purpose of this test, an idea will be eligible for investment if it receives at least 3 votes, i.e. the customer can invest, comment and like.

<img width="646" alt="fig" src="https://user-images.githubusercontent.com/85639354/171332169-90b74c82-c47f-4c18-bf18-68d84031fc6f.png">


## How to develop

### Advance preparation
install ```yarn```  and ```hardhat```

#### The development branch is main.

To develop locally
1. Fork this repository to your own GitHub account and then clone it to your local device.

2. Install packages required for execution:

　　```yarn```

3. Compile: 

　　```yarn hardhat compile```

To test on local network

4. Create local network: 

　　```yarn hardhat node```

5. Run 3 test.

   ```yarn hardhat run scripts/ post-idea.ts --network localhost```
   
   ```yarn hardhat run scripts/ vote.ts --network localhost```
   
   ```yarn hardhat run scripts/ pool.ts --network localhost```

### Description of each test (script)
- post-idea.ts
Drafters submit project idea. function post is executed to submit an idea with the following values given as arguments as a test.
	- explanation: unbelievable project
    - timelimit: 10
    - targetMoney: 3000
	- investmentForm: all-in
	 
Running the test outputs the data of the idea and the votingpossible if the Voter can vote or not

  ```True -> voter can vote```
  
  ```False -> voter cannot vote```
  
When the test is run, true is expected to be displayed, i.e. the voter can vote for this idea.
	 
- vote.ts
Voter vote for ideas. As a test, we run a function (functionvoteWithReason) that votes for an idea with the following values given as arguments
	 - ideaId: 1
	 - reason: wowow
	 
For the purpose of this test, an idea will be eligible for customers to invest and comment like when they have voted for it by 3 or more votes.
It means...

  ```Votingpossible -> false```
  
This operation also automatically makes the idea eligible for investment.
