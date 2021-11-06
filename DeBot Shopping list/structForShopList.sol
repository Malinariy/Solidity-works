pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

struct Purchase {
    uint32 id;
    string purchase_name;
    uint32 purchase_amount;
    uint64 createdAt;
    bool is_buy;
    uint32 price;
}

struct summary_purchases {
    uint32 complete_count;
    uint32 incomplete_count;   
    uint32 total_price;
}

interface FunctionInterface {
    function shoppig_list() external;
    }

interface IMsig {
   function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload  ) external;
}

interface I_Purchase {
   function addPurchase(string text) external;
   function deletePurchase(uint32 id) external;
   function getPurchases() external returns (Purchase[] purchase);
   function getStat() external returns (summary_purchases);
}

abstract contract A_HasConstructorWithPubKey {
   constructor(uint256 pubkey) public {}
}

contract structForShopList{

    TvmCell m_todoCode; // shoplist contract code
    address m_address;  // shoplist contract address
    summary_purchases m_stat;        // Statistics of incompleted and completed purchases
    uint32 m_purchaseId;    
    uint256 m_masterPubKey; // User pubkey
    address m_msigAddress;  // User wallet address

    uint32 INITIAL_BALANCE =  200000000;  // Initial shoplist contract balance

    mapping(uint32 => Purchase) mapp_purchase; //id to purchase
}

