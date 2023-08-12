import { configureChains, sepolia } from "@wagmi/core";
import { publicProvider } from "@wagmi/core/providers/public";
import { connect, fetchEnsName } from "@wagmi/core";
import { InjectedConnector } from "@wagmi/core/connectors/injected";
// import { sepolia } from "@wagmi/core/chains";
import { alchemyProvider } from "@wagmi/core/providers/alchemy";
import { MetaMaskConnector } from "@wagmi/core/connectors/metaMask";

const { chains, publicClient, webSocketPublicClient } = configureChains(
  [sepolia],
  [
    alchemyProvider({ apiKey: "eONVnmT4-3JSXTwFtawp3zEIs3Ml4ctT" }),
    publicProvider(),
  ]
);

const config = createConfig({
  autoConnect: true,
  publicClient,
  webSocketPublicClient,
  connectors: [new InjectedConnector({ chains })],
});

const { address } = await connect({
  connector: new InjectedConnector(),
});
const ensName = await fetchEnsName({ address });

const connector = new MetaMaskConnector({
  chains: [sepolia],
  options: {
    shimDisconnect: true, // Default is true.
    UNSTABLE_shimOnConnectSelectAccount: true, // allows user to select a different MetaMask account (than the currently connected account) when trying to connect.
  },
});

// Create a function that connects to the MetaMask wallet.

const connectToMetaMask = async () => {
  const { address } = await connect({
    connector,
  });
  const ensName = await fetchEnsName({ address });
  console.log(`Hello, ${ensName}!`);
};
