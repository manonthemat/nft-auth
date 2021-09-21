#!/bin/bash
export W1=`curl -s -d '' http://localhost:9080/wallet/create | jq '.wiWallet.getWalletId'`
sleep 1
export W2=`curl -s -d '' http://localhost:9080/wallet/create | jq '.wiWallet.getWalletId'`
sleep 1
export W3=`curl -s -d '' http://localhost:9080/wallet/create | jq '.wiWallet.getWalletId'`
sleep 1


export W1_IID=$(curl -s -H "Content-Type: application/json" -X POST -d '{"caID": "NFTAuthenticationContract", "caWallet":{"getWalletId": '$W1'}}' http://localhost:9080/api/contract/activate | jq .unContractInstanceId | tr -d '"')
export W2_IID=$(curl -s -H "Content-Type: application/json" -X POST -d '{"caID": "NFTAuthenticationContract", "caWallet":{"getWalletId": '$W2'}}' http://localhost:9080/api/contract/activate | jq .unContractInstanceId | tr -d '"')
export W3_IID=$(curl -s -H "Content-Type: application/json" -X POST -d '{"caID": "NFTAuthenticationContract", "caWallet":{"getWalletId": '$W3'}}' http://localhost:9080/api/contract/activate | jq .unContractInstanceId | tr -d '"')
sleep 1

printf "\nAbout this demo: This demo shows an authentication NFT minted by an issuer and delivered to a client wallet.\n"
printf "\nThe NFT can be used to verify the identity of the NFT holder\n"
printf "\nHere, wallet 1 - W1 is the NFT issuing authority and wallet 2 - W2 is the client wallet\n"
printf "\n"


printf "\n1. First, lets log the nft token name of wallet 2. Note the token name\n"
read -n1 -r -p "Press any key to continue..." key
printf "\n"
curl -H "Content-Type: application/json" -X POST -d 0 http://localhost:9080/api/contract/instance/$W2_IID/endpoint/logOwnNftTokenName
sleep 4
printf "\n"


printf "\n2. Next, wallet 2 requests for auth NFT by giving its credentials. The 'mint' endpoint of Issuer wallet W1 will be invoked\n"
printf "Wallet 2's credential here is its wallet ID\n"
read -n1 -r -p "Press any key to continue..." key
printf "\n"

curl -H "Content-Type: application/json" -X POST -d '{"getWalletId": '$W2'}' http://localhost:9080/api/contract/instance/$W1_IID/endpoint/mint
sleep 4
printf "\n"


printf "\n3.a. To the see the outcome we first inspect Issuer wallet W1 for value it now contains\n"
read -n1 -r -p "Press any key to continue..." key
printf "\n"
curl -H "Content-Type: application/json" -X POST -d "\"dummy\"" http://localhost:9080/api/contract/instance/$W1_IID/endpoint/inspect
sleep 4
printf "\n"


printf "\n3.b. Finally we first inspect the client wallet W2 to see the value it now contains\n"
read -n1 -r -p "Press any key to continue..." key
printf "\n"
curl -H "Content-Type: application/json" -X POST -d "\"dummy\"" http://localhost:9080/api/contract/instance/$W2_IID/endpoint/inspect
sleep 4
printf "\n"

read -n1 -r -p "Press any key to continue..." key
printf "\nTo conclude: What you saw is that Wallet 1 minted auth NFT with token name linked to the public of wallet 2 and delivered it\n"


