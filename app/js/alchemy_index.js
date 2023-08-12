// const { Network, Alchemy } = require("alchemy-sdk");

// import { Network, Alchemy } from "alchemy-sdk";

const settings = {
  apiKey: "eONVnmT4-3JSXTwFtawp3zEIs3Ml4ctT",
  network: Network.ETH_SEPOLIA, 
};

const alchemy = new Alchemy(settings);

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

const municipalityAddress = "0x026aE1d240f2eFc621E24db35E17F96e498ca11e";
const municipalityABI = [
  {
    inputs: [],
    name: "Municipality__GenesisMunicipalityHasBeenSet_MappingIsNotEmpty",
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
    name: "Municipality__NotMunicipality",
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
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "MuniAddrToZipCode",
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
    inputs: [
      {
        internalType: "address",
        name: "_municipalityAddr",
        type: "address",
      },
      {
        internalType: "string",
        name: "_municipalityZipCode",
        type: "string",
      },
    ],
    name: "addMuni",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "incrementNumMunicipalities",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "numMunicipalities",
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
        name: "_municipalityAddr",
        type: "address",
      },
      {
        internalType: "string",
        name: "_municipalityZipCode",
        type: "string",
      },
    ],
    name: "updateMuniZipCode",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
];

const machineAddress = "0x510050535CAAF32d3F43Ce3325501267E4c6Dd0E";
const machineABI = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_ecoCoinAddr",
        type: "address",
      },
      {
        internalType: "address",
        name: "_depositorAddr",
        type: "address",
      },
      {
        internalType: "address",
        name: "_shopHandlerAddr",
        type: "address",
      },
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
    name: "Depositor__RecyclerNotRegistered",
    type: "error",
  },
  {
    inputs: [],
    name: "Machine__BottlesNumberToDepositMustBeGreaterThanZero",
    type: "error",
  },
  {
    inputs: [],
    name: "Machine__CallerIsNotMachine",
    type: "error",
  },
  {
    inputs: [],
    name: "Machine__CannotDepositMoreThan200BottlesAtOnce",
    type: "error",
  },
  {
    inputs: [],
    name: "Machine__CannotRedeemMoreThan9999TokensAtOnce",
    type: "error",
  },
  {
    inputs: [],
    name: "Machine__CoolDownTimerHasntPassed",
    type: "error",
  },
  {
    inputs: [],
    name: "Machine__InsufficientTokensBalanceToRedeem",
    type: "error",
  },
  {
    inputs: [],
    name: "Machine__RedeemedTokensMustBeGreaterThanZero",
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
    name: "Municipality__NotMunicipality",
    type: "error",
  },
  {
    inputs: [],
    name: "ShopHandler__ShopNotRegisteredOrApproved",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "exMachineAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "string",
        name: "exMachineZipCode",
        type: "string",
      },
      {
        indexed: true,
        internalType: "address",
        name: "addedBy",
        type: "address",
      },
    ],
    name: "AddedExchangeMachine",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint64",
        name: "exMachineID",
        type: "uint64",
      },
      {
        indexed: false,
        internalType: "address",
        name: "exMachineAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "recyAddr",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint64",
        name: "recyID",
        type: "uint64",
      },
      {
        indexed: true,
        internalType: "uint64",
        name: "bottles",
        type: "uint64",
      },
    ],
    name: "DepositedBottles",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "exMachineAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint64",
        name: "exMachineID",
        type: "uint64",
      },
      {
        indexed: true,
        internalType: "address",
        name: "recyAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokens",
        type: "uint256",
      },
    ],
    name: "DepositedTokens",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "exMachineAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint64",
        name: "exMachineID",
        type: "uint64",
      },
      {
        indexed: true,
        internalType: "address",
        name: "shopAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "tokens",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "string",
        name: "cashAppUsername",
        type: "string",
      },
    ],
    name: "RedeemedTokens",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_exMAddress",
        type: "address",
      },
      {
        internalType: "string",
        name: "_exMZip",
        type: "string",
      },
    ],
    name: "createMachine",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint64",
        name: "_exMachineID",
        type: "uint64",
      },
      {
        internalType: "uint64",
        name: "_bottles",
        type: "uint64",
      },
    ],
    name: "depositBottles",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "exMachineAddressToID",
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
        internalType: "uint64",
        name: "",
        type: "uint64",
      },
    ],
    name: "exMachineIDToAddress",
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
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "exchangeMachines",
    outputs: [
      {
        internalType: "uint64",
        name: "exMachineID",
        type: "uint64",
      },
      {
        internalType: "string",
        name: "exMachineZipCode",
        type: "string",
      },
      {
        internalType: "address",
        name: "exMachineAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "exMachineRMBalance",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint64",
        name: "_exMachineID",
        type: "uint64",
      },
      {
        internalType: "string",
        name: "_cashAppUsername",
        type: "string",
      },
      {
        internalType: "uint64",
        name: "_tokensAmt",
        type: "uint64",
      },
    ],
    name: "redeemTokens",
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

const depositorAddress = "0x83b40CA5056FF87B975d05DD509E7450e7188556";
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

const spenderAddress = "0x3505E52e634A1D25198E96d362A500102a6317DF";
const spenderABI = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_ecoCoinAddr",
        type: "address",
      },
      {
        internalType: "address",
        name: "_depositorAddr",
        type: "address",
      },
      {
        internalType: "address",
        name: "_shopHandlerAddr",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "Depositor__RecyclerNotRegistered",
    type: "error",
  },
  {
    inputs: [],
    name: "Spender__InsufficientFundsToSpend",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "uint64",
        name: "shopID",
        type: "uint64",
      },
      {
        indexed: false,
        internalType: "address",
        name: "shopAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "recyAddr",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint256",
        name: "spendAmount",
        type: "uint256",
      },
    ],
    name: "GoodsPurchased",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint64",
        name: "shopID",
        type: "uint64",
      },
      {
        internalType: "uint256",
        name: "_spendAmount",
        type: "uint256",
      },
    ],
    name: "purchaseGoods",
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

const shopHandlerAddress = "0xdF0345af921b8b467e7B40D51bA1EaB4dBf8e18C";
const shopHandlerABI = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_ecoCoinAddr",
        type: "address",
      },
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
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "Municipality__NotMunicipality",
    type: "error",
  },
  {
    inputs: [],
    name: "ShopHandler__InvalidCommand",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "approverAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "shopAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint64",
        name: "shopID",
        type: "uint64",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopName",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopType",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopZipCode",
        type: "string",
      },
    ],
    name: "ShopApproved",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "denierAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "shopAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint64",
        name: "shopID",
        type: "uint64",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopName",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopType",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopZipCode",
        type: "string",
      },
    ],
    name: "ShopDenied",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "shopAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint64",
        name: "shopID",
        type: "uint64",
      },
      {
        indexed: true,
        internalType: "string",
        name: "shopName",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopType",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopZipCode",
        type: "string",
      },
    ],
    name: "ShopRegistered",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "removerAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "shopAddress",
        type: "address",
      },
      {
        indexed: true,
        internalType: "uint64",
        name: "shopID",
        type: "uint64",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopName",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopType",
        type: "string",
      },
      {
        indexed: false,
        internalType: "string",
        name: "shopZipCode",
        type: "string",
      },
    ],
    name: "ShopRemoved",
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
    name: "_getIndexByID",
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
        internalType: "uint64",
        name: "_shopRegisterID",
        type: "uint64",
      },
      {
        internalType: "bool",
        name: "_decision",
        type: "bool",
      },
    ],
    name: "approveShop",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_shopAddress",
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
        internalType: "address",
        name: "_shopAddress",
        type: "address",
      },
    ],
    name: "getShopName",
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
    name: "getShops",
    outputs: [
      {
        components: [
          {
            internalType: "uint64",
            name: "shopID",
            type: "uint64",
          },
          {
            internalType: "address",
            name: "shopAddress",
            type: "address",
          },
          {
            internalType: "string",
            name: "shopName",
            type: "string",
          },
          {
            internalType: "string",
            name: "shopType",
            type: "string",
          },
          {
            internalType: "string",
            name: "shopZipCode",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "shopBalance",
            type: "uint256",
          },
          {
            internalType: "bool",
            name: "status",
            type: "bool",
          },
        ],
        internalType: "struct ShopHandler.Shop[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "printShopName",
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
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
      {
        internalType: "string",
        name: "_type",
        type: "string",
      },
      {
        internalType: "string",
        name: "_zipCode",
        type: "string",
      },
    ],
    name: "registerShop",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint64",
        name: "_shopRmvID",
        type: "uint64",
      },
      {
        internalType: "bool",
        name: "_decision",
        type: "bool",
      },
    ],
    name: "removeShop",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
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
    name: "shops",
    outputs: [
      {
        internalType: "uint64",
        name: "shopID",
        type: "uint64",
      },
      {
        internalType: "address",
        name: "shopAddress",
        type: "address",
      },
      {
        internalType: "string",
        name: "shopName",
        type: "string",
      },
      {
        internalType: "string",
        name: "shopType",
        type: "string",
      },
      {
        internalType: "string",
        name: "shopZipCode",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "shopBalance",
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
        internalType: "uint64",
        name: "_shopIndex",
        type: "uint64",
      },
      {
        internalType: "address",
        name: "_shopAddress",
        type: "address",
      },
    ],
    name: "updateShopBalance",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];

async function getLatestBlockNumber() {
  const latestBlock = await alchemy.core.getBlockNumber();
  console.log("The latest block number is", latestBlock);
}

export {
    getLatestBlockNumber
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
