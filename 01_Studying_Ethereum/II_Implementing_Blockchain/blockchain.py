import sys

import hashlib  # To hash using sha256
import json

from time import time  # For timestamping
from uuid import uuid4

from flask import Flask, jsonify, request, render_template

import requests
from urllib.parse import urlparse


class Blockchain(object):
    # As of now, the difficulty target is fixed for 4 zeros, change it later to become a variable.
    difficulty_target = "0000"  # Setting the difficulty target for the solution of the nonce to 4 zeros (before hash).

    def hash_block(self, block):
        """
        Encodes a block into an array of bytes and then hashes it; must ensure that the dictionary is sorted, or you'll
        have inconsistent hashes later.
        :param block:
        :return:
        """
        block_encoded = json.dumps(block,
                                   sort_keys=True).encode()
        return hashlib.sha256(block_encoded).hexdigest()

    def __init__(self):
        """
        The constructor for the class. Stores the entire blockchain as a list.
        Since every blockchain has a genesis block, initializing the genesis block with the hash of the previous block;
        here a fixed string called genesis_block is used to obtain its hash.
        Once the hash of the previous block is found, the nonce for the block is needed to find, using the
        proof_of_work() method.
        """
        self.nodes = set()  # For adding later all the connected nodes.
        self.chain = []  # Stores all the blocks in the entire blockchain
        self.current_transactions = []  # Temporarily stores the transactions for the current block
        # Create the genesis block with a specific fixed hash of previous block, genesis block starts with index 0.
        genesis_hash = self.hash_block("genesis_block")
        self.append_block(
            hash_of_previous_block=genesis_hash,
            nonce=self.proof_of_work(0, genesis_hash, [])
        )

    def add_node(self, address):
        """
        Allows a new node to be added to the nodes member.
        For example, if "http://192.168.0.5:5000" is passed to the method, the IP address and port number
        "192.168.0.5:5000" will be added the nodes (set in __init__) member.
        The url parse allows to dismantle an address to useful parts: http alone, "192.168.0.5" alone,
        port "5000" alone, etc.
        :param address:
        :return:
        """
        parsed_url = urlparse(address)
        self.nodes.add(parsed_url.netloc)
        print(parsed_url.netloc)

    def valid_chain(self, chain):
        """
        Validates that a given blockchain is valid by performing two checks:
        1. Goes through each block in the blockchain and hashes each block and verifies that the hash of each block
            correctly recorded in the next block.
        2. Verifies that the nonce in each block is valid.
        :param chain:
        :return:
        """
        last_block = chain[0]  # The genesis block
        current_index = 1  # Starts with the second block
        while current_index < len(chain):
            block = chain[current_index]
            if block['hash_of_previous_block'] != self.hash_block(last_block):
                return False
            # Check for valid nonce
            if not self.valid_proof(  # If valid proof method returns a false value.
                    current_index,
                    block['hash_of_previous_block'],
                    block['transactions'],
                    block['nonce']):
                return False
            # Move on to the next block on the chain
            last_block = block
            current_index += 1
        # The chain is valid
        return True

    def update_blockchain(self):
        """
        Checks that the blockchain from neighboring nodes is valid and that the node with the longest valid chain is
        the authoritative one; if another node with a valid blockchain is longer than the current one,
        it will replace the current blockchain.
        :return:
        """
        # Get the nodes around us that has been registered.
        neighbours = self.nodes
        new_chain = None
        # For simplicity, look for chains longer than ours.
        max_length = len(self.chain)
        # Grab and verify the chains from all the nodes in our network.
        for node in neighbours:
            # Get the blockchain from the other nodes
            response = requests.get(f'http://{node}/blockchain')
            if response.status_code == 200:
                length = response.json()['length']
                chain = response.json()['chain']
                # Check if the length is longer and the chain is valid.
                if length > max_length and self.valid_chain(chain):
                    max_length = length
                    new_chain = chain
        # Replace our chain if we discovered a new, valid chain longer than our
        if new_chain:
            self.chain = new_chain
            return True
        return False

    def proof_of_work(self, index, hash_of_previous_block, transactions):
        """
        Use PoW to find the nonce for the current block.
        Checks if 0 is the matching nonce for the hash with the difficulty target, and increments the nonce by one
        until it reaches a correct nonce.
        Returns a nonce that will result in a hash that matches the difficulty target (0000) when the content of the
        current block is hashed.
        :param index:
        :param hash_of_previous_block:
        :param transactions:
        :return: Correct nonce for the block, derived by the difficulty level (fixed is four zeroes).
        """
        nonce = 0  # Try with nonce = 0
        # Tries hashing the nonce together with the hash of the previous block until it is valid.
        while self.valid_proof(index, hash_of_previous_block, transactions, nonce) is False:
            nonce += 1
        return nonce

    def valid_proof(self, index, hash_of_previous_block, transactions, nonce):
        """
        Hashes the content of a block and checks to see if the block's hash meets the difficulty target (fixed = 0000).
        :param index:
        :param hash_of_previous_block:
        :param transactions:
        :param nonce:
        :return:
        """
        # Create a string containing the hash of the previous block and the block content, including the nonce.
        content = f'{index}{hash_of_previous_block}{transactions}{nonce}'.encode()
        content_hash = hashlib.sha256(content).hexdigest()  # Hashes the content str using sha256.
        # Checks if the hash meets the difficulty target
        return content_hash[:len(self.difficulty_target)] == self.difficulty_target

    def append_block(self, nonce, hash_of_previous_block):
        """
        Creates a new block and adds it to the blockchain.
        :param nonce: Solved value that applies difficulty level.
        :param hash_of_previous_block: Hash of the previous block.
        :return:
        """
        block = {
            'index': len(self.chain),
            'timestamp': time(),
            'transactions': self.current_transactions,
            'nonce': nonce,
            'hash_of_previous_block': hash_of_previous_block
        }
        self.current_transactions = []  # Reset the current list of transactions
        self.chain.append(block)
        return block

    def add_transaction(self, sender, recipient, amount):
        """
        Adds a new transaction to the current list of transactions, gets the index of the last block in the blockchain,
        and adds one to it. This new index is the block that the current transaction will be added to.
        :param sender:
        :param recipient:
        :param amount:
        :return:
        """
        self.current_transactions.append({
            'amount': amount,
            'recipient': recipient,
            'sender': sender
        })
        return self.last_block['index'] + 1  # Adds one to the index of the last block.

    @property
    def last_block(self):
        """
        Returns the last block in the blockchain.
        :return: Last block in the blockchain.
        """
        return self.chain[-1]


# Exposing the Blockchain Class as a REST API
app = Flask(__name__)

# Generate a globally unique address for this node
node_identifier = str(uuid4()).replace('-', '')

# Instantiate the Blockchain
blockchain = Blockchain()


# Obtaining the Full Blockchain
# For the REST API, creating a route for users to obtain the current blockchain.
# Return the entire blockchain
@app.route('/blockchain', methods=['GET'])
def full_chain():
    response = {
        'chain': blockchain.chain,
        'length': len(blockchain.chain)
    }
    # return jsonify(response), 200
    return render_template('full_blockchain.html', t_response=response, s_code=200)


# Creating a route to allow miners to mine a block so that it can be added to the blockchain.
@app.route('/mine', methods=['GET'])
def mine_block():
    """
    Mining the nonce for the blockchain, sending 1 unit reward for the miner.
    :return:
    """
    blockchain.add_transaction(
        sender="0",
        recipient=node_identifier,
        amount=1
    )
    # Obtain the hash of the last block in the blockchain.
    last_block_hash = blockchain.hash_block(blockchain.last_block)
    # Using PoW, get the nonce for the new block to be added to the blockchain
    index = len(blockchain.chain)
    nonce = blockchain.proof_of_work(index, last_block_hash, blockchain.current_transactions)
    # Add the new block to the blockchain using the lst block hash and the current nonce
    block = blockchain.append_block(nonce, last_block_hash)
    response = {
        'message': "New Block Mined",
        'index': block['index'],
        'hash_of_previous_block': block['hash_of_previous_block'],
        'nonce': block['nonce'],
        'transactions': block['transactions']
    }
    return render_template('mine.html', t_response=response, s_code=200)


@app.route('/transactions/new', methods=['POST'])
def new_transaction():
    """
    Adding a new transaction to the blockchain.
    :return:
    """
    # Get the value passed in from the client.
    values = request.get_json()
    # Check that the required fields are in the POST'ed data
    required_fields = ['sender', 'recipient', 'amount']
    if not all(k in values for k in required_fields):
        return 'Missing fields', 400

    # Create a new transaction
    index = blockchain.add_transaction(
        values['sender'],
        values['recipient'],
        values['amount']
    )

    response = {
        'message': f'Transaction will be added to Block {index}'
    }

    return jsonify(response, 201)


@app.route('/nodes/add_nodes', methods=['POST'])
def add_nodes():
    """
    Allows a node to register one or more neighboring nodes.
    :return:
    """
    # Get the nodes passed in from the client.
    values = request.get_json()
    nodes = values.get('nodes')
    if nodes is None:
        return "Error: Missing node(s) info", 400
    for node in nodes:
        blockchain.add_node(node)
    response = {
        'message': 'New nodes added',
        'nodes': list(blockchain.nodes)
    }
    return jsonify(response), 201


@app.route('/nodes/sync', methods=['GET'])
def sync():
    """
    Allows a node to synchronize its blockchain with its neighboring nodes.
    :return:
    """
    updated = blockchain.update_blockchain()
    if updated:
        response = {
            'message': 'The blockchain has been updated to the latest',
            'blockchain': blockchain.chain
        }
    else:
        response = {
            'message': 'Our blockchain is the latest',
            'blockchain': blockchain.chain
        }

    return jsonify(response), 200


@app.route('/')
def index():
    return render_template('index.html', node_id=node_identifier)


@app.route('/about_me')
def about_me():
    return render_template('about_me.html')


if __name__ == '__main__':
    # Testing the blockchain, allowing the user to run the API based on the specified port number.
    app.run(host='0.0.0.0', port=int(sys.argv[1]))
