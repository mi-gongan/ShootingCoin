/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../common";
import type {
  GameCore,
  GameCoreInterface,
} from "../../../contracts/libs/GameCore";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "betInfo",
    outputs: [
      {
        internalType: "address",
        name: "coinAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "betAmount",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "feeRecieveAddress",
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
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "gameHistory",
    outputs: [
      {
        internalType: "uint256",
        name: "gameId",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "user1",
        type: "address",
      },
      {
        internalType: "address",
        name: "user1coinAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "user1GetAmount",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "user2",
        type: "address",
      },
      {
        internalType: "address",
        name: "user2coinAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "user2GetAmount",
        type: "uint256",
      },
      {
        internalType: "uint240",
        name: "timeStamp",
        type: "uint240",
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
    name: "gameInfo",
    outputs: [
      {
        internalType: "address",
        name: "user1",
        type: "address",
      },
      {
        internalType: "address",
        name: "user2",
        type: "address",
      },
      {
        components: [
          {
            internalType: "address",
            name: "coinAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "betAmount",
            type: "uint256",
          },
          {
            internalType: "uint256[5]",
            name: "nftSkinId",
            type: "uint256[5]",
          },
        ],
        internalType: "struct GameCore.BetInfo",
        name: "user1BetInfo",
        type: "tuple",
      },
      {
        components: [
          {
            internalType: "address",
            name: "coinAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "betAmount",
            type: "uint256",
          },
          {
            internalType: "uint256[5]",
            name: "nftSkinId",
            type: "uint256[5]",
          },
        ],
        internalType: "struct GameCore.BetInfo",
        name: "user2BetInfo",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getShootingNft",
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
    name: "getShootingRole",
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
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "isOnGame",
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
    inputs: [],
    name: "shootingNft",
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
    name: "shootingRole",
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
        internalType: "address",
        name: "nftContract",
        type: "address",
      },
    ],
    name: "updateShootingNft",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "roleContract",
        type: "address",
      },
    ],
    name: "updateShootingRole",
    outputs: [],
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
    name: "whitelist",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b50610dc6806100206000396000f3fe608060405234801561001057600080fd5b50600436106100b35760003560e01c80637999a68c116100715780637999a68c146101815780639b19251a1461019f578063a6f81668146101cf578063ae07a3aa14610202578063c3b9ed0214610220578063e2d35f0714610251576100b3565b8062b95ab2146100b85780632f59f6f4146100d65780633f2ea8bb146100f257806348b526e114610129578063601a6d8914610147578063660b68ca14610165575b600080fd5b6100c0610281565b6040516100cd919061091b565b60405180910390f35b6100f060048036038101906100eb9190610967565b6102ab565b005b61010c600480360381019061010791906109ca565b6103ca565b604051610120989796959493929190610a52565b60405180910390f35b6101316104d9565b60405161013e919061091b565b60405180910390f35b61014f610502565b60405161015c919061091b565b60405180910390f35b61017f600480360381019061017a9190610967565b610528565b005b610189610646565b604051610196919061091b565b60405180910390f35b6101b960048036038101906101b49190610967565b61066c565b6040516101c69190610aeb565b60405180910390f35b6101e960048036038101906101e49190610b06565b61068c565b6040516101f99493929190610c2f565b60405180910390f35b61020a61085a565b604051610217919061091b565b60405180910390f35b61023a60048036038101906102359190610967565b61087e565b604051610248929190610c76565b60405180910390f35b61026b60048036038101906102669190610967565b6108c2565b6040516102789190610c9f565b60405180910390f35b6000600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166324d7806c336040518263ffffffff1660e01b8152600401610304919061091b565b6020604051808303816000875af1158015610323573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906103479190610ce6565b610386576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161037d90610d70565b60405180910390fd5b80600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b600660205281600052604060002081815481106103e657600080fd5b9060005260206000209060080201600091509150508060000154908060010160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060020160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060030154908060040160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060050160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060060154908060070160009054906101000a90047dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff16905088565b60008060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905090565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166324d7806c336040518263ffffffff1660e01b8152600401610581919061091b565b6020604051808303816000875af11580156105a0573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105c49190610ce6565b610603576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016105fa90610d70565b60405180910390fd5b806000806101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b600260009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60076020528060005260406000206000915054906101000a900460ff1681565b60056020528060005260406000206000915090508060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060010160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1690806002016040518060600160405290816000820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020016001820154815260200160028201600580602002604051908101604052809291908260058015610797576020028201915b815481526020019060010190808311610783575b50505050508152505090806009016040518060600160405290816000820160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001600182015481526020016002820160058060200260405190810160405280929190826005801561084c576020028201915b815481526020019060010190808311610838575b505050505081525050905084565b60008054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b60046020528060005260406000206000915090508060000160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16908060010154905082565b60036020528060005260406000206000915090505481565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000610905826108da565b9050919050565b610915816108fa565b82525050565b6000602082019050610930600083018461090c565b92915050565b600080fd5b610944816108fa565b811461094f57600080fd5b50565b6000813590506109618161093b565b92915050565b60006020828403121561097d5761097c610936565b5b600061098b84828501610952565b91505092915050565b6000819050919050565b6109a781610994565b81146109b257600080fd5b50565b6000813590506109c48161099e565b92915050565b600080604083850312156109e1576109e0610936565b5b60006109ef85828601610952565b9250506020610a00858286016109b5565b9150509250929050565b610a1381610994565b82525050565b60007dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff82169050919050565b610a4c81610a19565b82525050565b600061010082019050610a68600083018b610a0a565b610a75602083018a61090c565b610a82604083018961090c565b610a8f6060830188610a0a565b610a9c608083018761090c565b610aa960a083018661090c565b610ab660c0830185610a0a565b610ac360e0830184610a43565b9998505050505050505050565b60008115159050919050565b610ae581610ad0565b82525050565b6000602082019050610b006000830184610adc565b92915050565b600060208284031215610b1c57610b1b610936565b5b6000610b2a848285016109b5565b91505092915050565b610b3c816108fa565b82525050565b610b4b81610994565b82525050565b600060059050919050565b600081905092915050565b6000819050919050565b6000610b7d8383610b42565b60208301905092915050565b6000602082019050919050565b610b9f81610b51565b610ba98184610b5c565b9250610bb482610b67565b8060005b83811015610be5578151610bcc8782610b71565b9650610bd783610b89565b925050600181019050610bb8565b505050505050565b60e082016000820151610c036000850182610b33565b506020820151610c166020850182610b42565b506040820151610c296040850182610b96565b50505050565b600061020082019050610c45600083018761090c565b610c52602083018661090c565b610c5f6040830185610bed565b610c6d610120830184610bed565b95945050505050565b6000604082019050610c8b600083018561090c565b610c986020830184610a0a565b9392505050565b6000602082019050610cb46000830184610a0a565b92915050565b610cc381610ad0565b8114610cce57600080fd5b50565b600081519050610ce081610cba565b92915050565b600060208284031215610cfc57610cfb610936565b5b6000610d0a84828501610cd1565b91505092915050565b600082825260208201905092915050565b7f53686f6f74696e67526f6c653a206f6e6c792061646d696e0000000000000000600082015250565b6000610d5a601883610d13565b9150610d6582610d24565b602082019050919050565b60006020820190508181036000830152610d8981610d4d565b905091905056fea2646970667358221220c1d37bec512453b1090ca1ea3846b254a49f047d379f24710af9562698940cb264736f6c63430008110033";

type GameCoreConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: GameCoreConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class GameCore__factory extends ContractFactory {
  constructor(...args: GameCoreConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<GameCore> {
    return super.deploy(overrides || {}) as Promise<GameCore>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): GameCore {
    return super.attach(address) as GameCore;
  }
  override connect(signer: Signer): GameCore__factory {
    return super.connect(signer) as GameCore__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): GameCoreInterface {
    return new utils.Interface(_abi) as GameCoreInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): GameCore {
    return new Contract(address, _abi, signerOrProvider) as GameCore;
  }
}
