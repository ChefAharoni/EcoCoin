"use client";
import { useState } from "react";
import { ethers } from "ethers";

// Connect to metamask
// Execute a function

export default function Home() {
  const [isConnected, setIsConnected] = useState(false);
  const [provider, setProvider] = useState();

  async function connect() {
    if (typeof window.ethereum !== "undefined") {
      try {
        await ethereum.request({ method: "eth_requestAccounts" });
        setIsConnected(true);
        let connectedProvider = new ethers.providers.Web3Provider(
          window.ethereum
        );
        setSigner(connectedProvider.getSigner());
      } catch (e) {
        console.log(e);
      }
    } else {
      setIsConnected(false);
    }
  }

  async function execute() {}

  return (
    <div className="z-10 max-w-5xl w-full items-center justify-between font-mono text-sm lg:flex">
      Lets get froggy!
      {isConnected ? (
        "Connected!"
      ) : (
        <button onClick={() => connect()}>Connect</button>
      )}
    </div>
  );
}
