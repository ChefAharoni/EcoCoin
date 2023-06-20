address = '0x3a16bD077f1BF9ddf38Ff76b78b9Fb4adB09D2bf'
abi = '[
	{
		"inputs": [],
		"name": "cashOut",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "document",
				"type": "string"
			}
		],
		"name": "checkEduCredentials",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "kill",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "document",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "blockNumber",
				"type": "uint256"
			}
		],
		"name": "Result",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "document",
				"type": "string"
			}
		],
		"name": "storeEduCredentials",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
]'
