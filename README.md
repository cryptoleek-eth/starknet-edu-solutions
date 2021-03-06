# Starknet Edu Solutions
A repo to solve starknet-edu challenges. Finished all the challenges under 2 days and attached my points screenshot.
![](https://user-images.githubusercontent.com/85657906/174603687-7bd0969a-7f27-419a-854c-e50cc72e6c44.jpeg)

## STARK EDU overall experiences
- Really enjoyed the challenge and problem solving moments.
- Env setup including nile tools setup etc.
- Got myself familiar with AgentX, Accounts concepts, Voyager etc.
- Got myself familiar with Cairo lang syntax and tricks.
- Got an overall good feeling on how to develop STARKNET smart contracts.
- Got myself familiar with Nile development tools and debug tricks.
- Understood STARKNET smart contracts design pattern and composibility.
- Understood ERC721, ERC20 and messaging protocol in cairo.

### STARK EDU Improvement proposal

#### Design a story
I feel a bit too technical and not very enjoyable to go through all the challenges, especially when you stuck. A more engaging story telling way of learning will be much better.

eg. We can design a story line such as `Long long time again, there is a STARK universe hero, he lost his fiancee in the battle of protecting STARK citizens. Now he starts his quest to find his beloved fiancee. He needs to collect 3 gems (NFTs) to get the wisdom crystal ball. The gems can only redeemed by points. And the crystal ball can tell where the fiancee is etc etc.`
Have a good story + some good images will be much more fun and engaging.

#### Tip system or hints system
Leaners are very likely to get stuck somewhere and there isn't much discord support around. I have to wait several hours or days before getting people to anwser my questions. So I suggest to introduce a Tip or hints system.
If people are stuck, they can consume their points to get some tips. Tips can be subimitted by the communities with a reputation system.

#### A further learning path or road map
From my personal perspective, it's totaly cool that I spent numerous hours to finish the tutorial and feel so proud of myself. But what's next? In the tutorial it would be good have an advanced session or some futher readings sessions to guide the developers who just fall into the STARK rabbit hole. For me, now I have to figure out what's my next learning journey in STARK ecosystem. There are lots of things out there and dont know what to choose. 


### StarkNet-Edu ERC721 Tutorial learning experiences
- The Reference 'token_id' was revoked.
  - Manage to find the answers in Discord after several hours trying and asking
- Contract caller reference
  - Manage to find the answers in Discord after several hours trying and asking.
  ![](https://user-images.githubusercontent.com/85657906/174252994-94e15b77-ac8a-466d-ae45-4c0ac7399a81.jpg)
- Nile Local env setup and debugging
  - For some complex tasks, I have to setup the Nile local envs to do some debugging.
  - It took a good couple of hours to redeploy all the cairo codes
- Some potential bugs in the starknet-ERC721 tutorial
  - [Issue Link](https://github.com/starknet-edu/starknet-erc721/issues/4)
- OpenZeppelin Cairo Contracts
  - Gives me a bit inspiration on how to do `token_of_owner_by_index`

### StarkNet-Edu ERC20 Tutorial learning experiences notes
- Part 1 of ERC20 tutorial is a breeze after finishing ERC721 and Messaging tutorials
- Some of the Part 2 questions and guides are misleading.
  - Exercise 13 the description are messed up a bit.
  ![](https://user-images.githubusercontent.com/85657906/174599756-ef7bf7e8-b1ee-4659-aca3-1cbff90bf7f6.png)
  - Exercise 18 seems give some misleading infomation such as `withdraw function so that it uses transferFrom() in ExerciseSolutionToken`

### StarkNet-Edu Messaging Bridge Tutorial learning experiences notes
- [Voyager](https://goerli.voyager.online) seems having issues to display correct message state and flow directions. [Version 2](https://beta.voyager.online/) is better.
- Need to be careful cause the layer2 -> layer1 message broadcast is very slow. Not sure there is a way to test layer1 <-> layer2 interoperability locally. So if there is sth wrong, it will cost a great time to redo it.

### What can I contribute to the ecosystem
First, I can engage myself more into both english and chinese STARK dev communities and answer questions. That's essential since lots of simple and duplicated questions out there and no one answer such as `In my contract there are four arguments, but when i passed in, the compiler expect 5 arguments etc.`

Second, I would like to co-dev a more engaging StarkEdu learning experiences such as putting a story line and good visual graphics etc. Develop a set of contracts which can give hints and tips, also redeemed their points for NFTs as an badge to show off in the community.

Third, I can run some meetups in Australia and South Eastern Asian territory and spread the words about STARK net and CairoLang. In fact, I am running a Melbourn STARKNET group at the moment.  https://www.meetup.com/starknet-melbourne/events/286679765/

### Summary
I really enjoyed the learning experience and hacking moments. Will continue to explore more.

What's next step to learn? starknet.js?
