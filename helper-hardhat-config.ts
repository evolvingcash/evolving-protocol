// @ts-ignore
import { HardhatNetworkForkingUserConfig, HardhatUserConfig } from 'hardhat/types';
import {
  eEthereumNetwork,
  ePolygonNetwork,
  eXDaiNetwork,
  iParamsPerNetwork,
} from './helpers/types';

require('dotenv').config();

const INFURA_KEY = process.env.INFURA_KEY || '';
const ALCHEMY_KEY = process.env.ALCHEMY_KEY || '';
const TENDERLY_FORK_ID = process.env.TENDERLY_FORK_ID || '';

const GWEI = 1000 * 1000 * 1000;

export const NETWORKS_RPC_URL: iParamsPerNetwork<string> = {
  [eEthereumNetwork.kovan]: ALCHEMY_KEY
    ? `https://eth-kovan.alchemyapi.io/v2/${ALCHEMY_KEY}`
    : `https://kovan.infura.io/v3/${INFURA_KEY}`,
  [eEthereumNetwork.ropsten]: ALCHEMY_KEY
    ? `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_KEY}`
    : `https://ropsten.infura.io/v3/${INFURA_KEY}`,
  [eEthereumNetwork.main]: ALCHEMY_KEY
    ? `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_KEY}`
    : `https://mainnet.infura.io/v3/${INFURA_KEY}`,
  [eEthereumNetwork.coverage]: 'http://localhost:8555',
  [eEthereumNetwork.hardhat]: 'http://localhost:8545',
  [eEthereumNetwork.buidlerevm]: 'http://localhost:8545',
  [eEthereumNetwork.tenderlyMain]: `https://rpc.tenderly.co/fork/${TENDERLY_FORK_ID}`,
  [eEthereumNetwork.hecotest]: 'https://http-testnet.hecochain.com',
  [eEthereumNetwork.heco]: 'https://http-mainnet-node.huobichain.com',
  [eEthereumNetwork.bsc]: 'https://bsc-dataseed1.binance.org',
  [eEthereumNetwork.bsctest]: 'https://data-seed-prebsc-1-s1.binance.org:8545',
  [ePolygonNetwork.mumbai]: 'https://rpc-mumbai.maticvigil.com',
  [ePolygonNetwork.matic]: 'https://rpc-mainnet.matic.network',
  [eXDaiNetwork.xdai]: 'https://rpc.xdaichain.com/',
};

export const NETWORKS_DEFAULT_GAS: iParamsPerNetwork<number> = {
  [eEthereumNetwork.kovan]: 1 * GWEI,
  [eEthereumNetwork.ropsten]: 65 * GWEI,
  [eEthereumNetwork.main]: 65 * GWEI,
  [eEthereumNetwork.coverage]: 65 * GWEI,
  [eEthereumNetwork.hardhat]: 65 * GWEI,
  [eEthereumNetwork.buidlerevm]: 65 * GWEI,
  [eEthereumNetwork.tenderlyMain]: 0.01 * GWEI,
  [eEthereumNetwork.hecotest]: 1 * GWEI,
  [eEthereumNetwork.heco]: 2.25 * GWEI,
  [eEthereumNetwork.bsc]: 5 * GWEI,
  [eEthereumNetwork.bsctest]: 10 * GWEI,
  [ePolygonNetwork.mumbai]: 1 * GWEI,
  [ePolygonNetwork.matic]: 1 * GWEI,
  [eXDaiNetwork.xdai]: 1 * GWEI,
};

export const BLOCK_TO_FORK: iParamsPerNetwork<number | undefined> = {
  [eEthereumNetwork.main]: 12406069,
  [eEthereumNetwork.kovan]: undefined,
  [eEthereumNetwork.ropsten]: undefined,
  [eEthereumNetwork.coverage]: undefined,
  [eEthereumNetwork.hardhat]: undefined,
  [eEthereumNetwork.heco]: undefined,
  [eEthereumNetwork.hecotest]: undefined,
  [eEthereumNetwork.bsc]: undefined,
  [eEthereumNetwork.bsctest]: undefined,
  [eEthereumNetwork.buidlerevm]: undefined,
  [eEthereumNetwork.tenderlyMain]: 12406069,
  [ePolygonNetwork.mumbai]: undefined,
  [ePolygonNetwork.matic]: undefined,
  [eXDaiNetwork.xdai]: undefined,
};
