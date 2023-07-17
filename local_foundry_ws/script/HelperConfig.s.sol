// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint32 constant SEPOLIA_CHAIN_ID = 11155111;
    uint32 constant GANACHE_CHAIN_ID = 5777;
    string constant EUNICE_ZIP_CODE = "70535";
    string constant LAFAYETTE_ZIP_CODE = "70501";

    struct NetworkConfig {
        address GenesisMunicipalityAddress; // Address of the municipality.
        string GenesisMunicipalityZipCode; // Zip code location of the genesis municipality; string so it can handle long zip codes and non-us zipcodes as well.
        address RecyclerAddress; // Address of the recycler.
        address ShopAddress; // Address of the shops.
        address MachineAddress; // Address of the machine.
        address secondMunicipalityAddress; // Address of the second municipality.
        string secondMunicipalityZipCode; // Zip code location of the second municipality, used to test if the genesis municipality can add a new municipality.
    }

    constructor() {
        // Checks what network we're in, gets the relevant information accordingly.
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaNetConfig();
        } else if (block.chainid == GANACHE_CHAIN_ID) {
            activeNetworkConfig = getGanacheNetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    /**
     * @notice  Gets the relevant data from if deployed on the Sepolia testnet.
     * @dev     Uses forge's cheats to make a labeled address for each user.
     * @return  NetworkConfig  .
     */
    function getSepoliaNetConfig() public returns (NetworkConfig memory) {
        address genesisMunicipality = makeAddr("genMunicipality");
        address recycler = makeAddr("recycler");
        address shop = makeAddr("shop");
        address machine = makeAddr("machine");
        address secondMunicipality = makeAddr("secondMunicipality");

        return
            NetworkConfig({
                GenesisMunicipalityAddress: address(genesisMunicipality),
                GenesisMunicipalityZipCode: EUNICE_ZIP_CODE,
                RecyclerAddress: address(recycler),
                ShopAddress: address(shop),
                MachineAddress: address(machine),
                secondMunicipalityAddress: address(secondMunicipality),
                secondMunicipalityZipCode: LAFAYETTE_ZIP_CODE
            });
    }

    function getOrCreateAnvilEthConfig()
        public
        view
        returns (NetworkConfig memory)
    {
        // Line blelow checks if the contract has already been deployed. If it has, the address would be different from 0.
        if (activeNetworkConfig.GenesisMunicipalityAddress != address(0)) {
            return activeNetworkConfig;
        }

        return
            NetworkConfig({
                GenesisMunicipalityAddress: address(
                    0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
                ),
                GenesisMunicipalityZipCode: EUNICE_ZIP_CODE,
                RecyclerAddress: address(
                    0x70997970C51812dc3A010C7d01b50e0d17dc79C8
                ),
                ShopAddress: address(
                    0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
                ),
                MachineAddress: address(
                    0x90F79bf6EB2c4f870365E785982E1f101E93b906
                ),
                secondMunicipalityAddress: address(
                    0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65
                ),
                secondMunicipalityZipCode: LAFAYETTE_ZIP_CODE
            });
    }

    function getGanacheNetConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                GenesisMunicipalityAddress: address(
                    0xc3b0360670CE81F91cE4529C22b9a0e97D96D171
                ),
                GenesisMunicipalityZipCode: EUNICE_ZIP_CODE,
                RecyclerAddress: address(
                    0xDf6B8E2Fc696A0A262D51E165b23d2f6F29AbEBD
                ),
                ShopAddress: address(
                    0x3F9210997349BdeC67e02837b9f6Bc7b2F4BFB97
                ),
                MachineAddress: address(
                    0x7f86b03950d1858FB80b5769B862d8fc9b031883
                ),
                secondMunicipalityAddress: address(
                    0xd984ba179fb11A8c3aa22552018a4086101cFE1D
                ),
                secondMunicipalityZipCode: LAFAYETTE_ZIP_CODE
            });
    }
}
