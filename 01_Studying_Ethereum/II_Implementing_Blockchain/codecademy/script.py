from blockchain import Blockchain

block_one_transactions = {"sender": "Alice", "receiver": "Bob", "amount": "50"}
block_two_transactions = {"sender": "Bob", "receiver": "Cole", "amount": "25"}
block_three_transactions = {"sender": "Alice", "receiver": "Cole", "amount": "35"}
fake_transactions = {"sender": "Bob", "receiver": "Cole, Alice", "amount": "25"}

local_blockchain = Blockchain()
# local_blockchain.print_blocks()
local_blockchain.add_block(block_one_transactions)
local_blockchain.add_block(block_two_transactions)
local_blockchain.add_block(block_three_transactions)
# local_blockchain.print_blocks()
# print(local_blockchain.chain[1].transactions)
local_blockchain.chain[1].transactions = fake_transactions  # In order to make the blockchain unvalid
local_blockchain.validate_chain()
