
export type eNetwork = eEthereumNetwork | ePolygonNetwork | eXDaiNetwork;

export enum eEthereumNetwork {
    buidlerevm = 'buidlerevm',
    kovan = 'kovan',
    ropsten = 'ropsten',
    main = 'main',
    coverage = 'coverage',
    hardhat = 'hardhat',
    tenderlyMain = 'tenderlyMain',
    hecotest = 'hecotest',
    heco = 'heco',
    bsctest = 'bsctest',
    bsc = 'bsc',
}

export enum ePolygonNetwork {
    matic = 'matic',
    mumbai = 'mumbai',
}
  
export enum eXDaiNetwork {
    xdai = 'xdai',
}

export enum EthereumNetworkNames {
    kovan = 'kovan',
    ropsten = 'ropsten',
    main = 'main',
    matic = 'matic',
    mumbai = 'mumbai',
    xdai = 'xdai',
    hecotest = 'hecotest',
    heco = 'heco',
    bsctest = 'bsctest',
    bsc = 'bsc',
}

export type iParamsPerNetwork<T> =
  | iEthereumParamsPerNetwork<T>
  | iPolygonParamsPerNetwork<T>
  | iXDaiParamsPerNetwork<T>;

export interface iEthereumParamsPerNetwork<T> {
    [eEthereumNetwork.coverage]: T;
    [eEthereumNetwork.buidlerevm]: T;
    [eEthereumNetwork.kovan]: T;
    [eEthereumNetwork.ropsten]: T;
    [eEthereumNetwork.main]: T;
    [eEthereumNetwork.hardhat]: T;
    [eEthereumNetwork.tenderlyMain]: T;
    [eEthereumNetwork.hecotest]: T;
    [eEthereumNetwork.heco]: T;
    [eEthereumNetwork.bsctest]: T;
    [eEthereumNetwork.bsc]: T;
}
  
export interface iPolygonParamsPerNetwork<T> {
    [ePolygonNetwork.matic]: T;
    [ePolygonNetwork.mumbai]: T;
}
  
export interface iXDaiParamsPerNetwork<T> {
    [eXDaiNetwork.xdai]: T;
}
