var kycManagerABI = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "managerAddr",
				"type": "address"
			}
		],
		"name": "NFTidOfOwner",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "NFTid",
				"type": "uint256"
			}
		],
		"name": "availableOfNFTid",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "tokenUrl",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "manager",
				"type": "address"
			}
		],
		"name": "createKYCNFT",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "NFTid",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "manager",
				"type": "address"
			}
		],
		"name": "createNFTidToManagerAddr",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "NFTid",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "newManager",
				"type": "address"
			}
		],
		"name": "modifyNFTidToManagerAddr",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "NFTid",
				"type": "uint256"
			}
		],
		"name": "ownerOfNFTid",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_kycnftContractAddr",
				"type": "address"
			}
		],
		"name": "setKYCNFTContractAddress",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "NFTid",
				"type": "uint256"
			},
			{
				"internalType": "bool",
				"name": "_available",
				"type": "bool"
			}
		],
		"name": "setNFTAvailable",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_accumulator",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_n",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_g",
				"type": "uint256"
			}
		],
		"name": "updateAccumulator",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_n",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_g",
				"type": "uint256"
			}
		],
		"name": "updateAccumulatorPublicKey",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_accumulator",
				"type": "string"
			}
		],
		"name": "updateAccumulatorValue",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "NFTid",
				"type": "uint256"
			}
		],
		"name": "userDataOfNFTID",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "NFTid",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "accumulator",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "n",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "g",
						"type": "uint256"
					}
				],
				"internalType": "struct KYCManager.UserData",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "managerAddr",
				"type": "address"
			}
		],
		"name": "userDataOfOwner",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "NFTid",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "accumulator",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "n",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "g",
						"type": "uint256"
					}
				],
				"internalType": "struct KYCManager.UserData",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]