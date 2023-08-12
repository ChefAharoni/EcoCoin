import { MetaMaskSK } from "@metamask/sdk";

const MMSDK = new MetaMaskSK(options);
const ethereum = MMSDK.getProvider();

ethereum.request({ method: "eth_requestAccounts" });