import { ethers } from "ethers";
const { ethers } = require("ethers");

async function connect() {
  if (typeof window.ethereum !== "undefined") {
    console.log("MetaMask is installed!");
    await ethereum.request({ method: "eth_requestAccounts" });
  } else {
    console.log("MetaMask is not installed!");
  }
}

async function execute() {
  // Address
  // Contract ABI
  // Function
  // Node connection
  const ecoCoinAddress = "0xd4f8D30E2a6749a3E9cB21FBb546AF98F511035B";
  const ecoCoinABI = [
    {
      inputs: [
        {
          internalType: "address",
          name: "_municipalityAddr",
          type: "address",
        },
      ],
      stateMutability: "nonpayable",
      type: "constructor",
    },
    {
      inputs: [],
      name: "EcoCoin__genMunicipalityIsSet",
      type: "error",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      name: "Machine__SenderNotMachine",
      type: "error",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "municipalityAddr",
          type: "address",
        },
        {
          indexed: true,
          internalType: "string",
          name: "municipalityZipCode",
          type: "string",
        },
        {
          indexed: true,
          internalType: "address",
          name: "addedBy",
          type: "address",
        },
      ],
      name: "AddedMunicipality",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "owner",
          type: "address",
        },
        {
          indexed: true,
          internalType: "address",
          name: "spender",
          type: "address",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "value",
          type: "uint256",
        },
      ],
      name: "Approval",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "previousOwner",
          type: "address",
        },
        {
          indexed: true,
          internalType: "address",
          name: "newOwner",
          type: "address",
        },
      ],
      name: "OwnershipTransferred",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "from",
          type: "address",
        },
        {
          indexed: true,
          internalType: "address",
          name: "to",
          type: "address",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "value",
          type: "uint256",
        },
      ],
      name: "Transfer",
      type: "event",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      name: "_exMachineAddressToID",
      outputs: [
        {
          internalType: "uint64",
          name: "",
          type: "uint64",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "_genMunicipalityAddr",
          type: "address",
        },
        {
          internalType: "string",
          name: "_genMunicipalityZipCode",
          type: "string",
        },
      ],
      name: "addGenMuni",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "owner",
          type: "address",
        },
        {
          internalType: "address",
          name: "spender",
          type: "address",
        },
      ],
      name: "allowance",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "spender",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "amount",
          type: "uint256",
        },
      ],
      name: "approve",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "account",
          type: "address",
        },
      ],
      name: "balanceOf",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "account",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "amount",
          type: "uint256",
        },
      ],
      name: "burn",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "decimals",
      outputs: [
        {
          internalType: "uint8",
          name: "",
          type: "uint8",
        },
      ],
      stateMutability: "pure",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "spender",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "subtractedValue",
          type: "uint256",
        },
      ],
      name: "decreaseAllowance",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "i_genMunicipality",
      outputs: [
        {
          internalType: "address",
          name: "muniAddr",
          type: "address",
        },
        {
          internalType: "string",
          name: "s_muniZipCode",
          type: "string",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "spender",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "addedValue",
          type: "uint256",
        },
      ],
      name: "increaseAllowance",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "to",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "amount",
          type: "uint256",
        },
      ],
      name: "mint",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "name",
      outputs: [
        {
          internalType: "string",
          name: "",
          type: "string",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "owner",
      outputs: [
        {
          internalType: "address",
          name: "",
          type: "address",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "renounceOwnership",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "symbol",
      outputs: [
        {
          internalType: "string",
          name: "",
          type: "string",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "totalSupply",
      outputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "to",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "amount",
          type: "uint256",
        },
      ],
      name: "transfer",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "from",
          type: "address",
        },
        {
          internalType: "address",
          name: "to",
          type: "address",
        },
        {
          internalType: "uint256",
          name: "amount",
          type: "uint256",
        },
      ],
      name: "transferFrom",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "newOwner",
          type: "address",
        },
      ],
      name: "transferOwnership",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
  ];

  const depositorContract = "0x83b40CA5056FF87B975d05DD509E7450e7188556";
  const depositorABI = [
    {
      inputs: [
        {
          internalType: "address",
          name: "_ecoCoinAddr",
          type: "address",
        },
      ],
      stateMutability: "nonpayable",
      type: "constructor",
    },
    {
      inputs: [],
      name: "Depositor__GreenerID_DoesNotExist",
      type: "error",
    },
    {
      inputs: [],
      name: "Depositor__RecyclerNotRegistered",
      type: "error",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "recyAddr",
          type: "address",
        },
        {
          indexed: true,
          internalType: "uint64",
          name: "recyID",
          type: "uint64",
        },
        {
          indexed: true,
          internalType: "string",
          name: "recyName",
          type: "string",
        },
      ],
      name: "RecyclerRegistered",
      type: "event",
    },
    {
      inputs: [
        {
          internalType: "uint64",
          name: "searchID",
          type: "uint64",
        },
      ],
      name: "_getGreenerIndexByID",
      outputs: [
        {
          internalType: "uint64",
          name: "",
          type: "uint64",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "getGreeners",
      outputs: [
        {
          components: [
            {
              internalType: "uint64",
              name: "ID",
              type: "uint64",
            },
            {
              internalType: "string",
              name: "recyName",
              type: "string",
            },
            {
              internalType: "address",
              name: "recyAddr",
              type: "address",
            },
            {
              internalType: "uint64",
              name: "bottlesDepo",
              type: "uint64",
            },
            {
              internalType: "uint256",
              name: "recyBalance",
              type: "uint256",
            },
            {
              internalType: "uint256",
              name: "lastTimeStamp",
              type: "uint256",
            },
            {
              internalType: "bool",
              name: "status",
              type: "bool",
            },
          ],
          internalType: "struct Depositor.Recylcer[]",
          name: "",
          type: "tuple[]",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "_recyAddr",
          type: "address",
        },
      ],
      name: "getIdByAddress",
      outputs: [
        {
          internalType: "uint64",
          name: "",
          type: "uint64",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint256",
          name: "",
          type: "uint256",
        },
      ],
      name: "greeners",
      outputs: [
        {
          internalType: "uint64",
          name: "ID",
          type: "uint64",
        },
        {
          internalType: "string",
          name: "recyName",
          type: "string",
        },
        {
          internalType: "address",
          name: "recyAddr",
          type: "address",
        },
        {
          internalType: "uint64",
          name: "bottlesDepo",
          type: "uint64",
        },
        {
          internalType: "uint256",
          name: "recyBalance",
          type: "uint256",
        },
        {
          internalType: "uint256",
          name: "lastTimeStamp",
          type: "uint256",
        },
        {
          internalType: "bool",
          name: "status",
          type: "bool",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "address",
          name: "recycler",
          type: "address",
        },
      ],
      name: "recyclerToID",
      outputs: [
        {
          internalType: "uint64",
          name: "recyID",
          type: "uint64",
        },
      ],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "string",
          name: "_name",
          type: "string",
        },
      ],
      name: "registerRecycler",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        {
          internalType: "uint64",
          name: "_recyID",
          type: "uint64",
        },
      ],
      name: "updateRecyBalance",
      outputs: [
        {
          internalType: "bool",
          name: "",
          type: "bool",
        },
      ],
      stateMutability: "nonpayable",
      type: "function",
    },
  ];

  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner(); // This is going to get the connected account.
  const contract = new ethers.Contract(depositorContract, depositorABI, signer);
  await contract.registerRecycler("John Green");
}

module.exports = {
  connect,
  execute,
};

/*
Contracts Addresses - Deployed on Sepolia Testnet

EcoCoin      : 0xd4f8D30E2a6749a3E9cB21FBb546AF98F511035B
Municipality : 0x026aE1d240f2eFc621E24db35E17F96e498ca11e
Machine      : 0x510050535CAAF32d3F43Ce3325501267E4c6Dd0E
Depositor    : 0x83b40CA5056FF87B975d05DD509E7450e7188556
Spender      : 0x3505E52e634A1D25198E96d362A500102a6317DF
ShopHandler  : 0xdF0345af921b8b467e7B40D51bA1EaB4dBf8e18C 
*/
