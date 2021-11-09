pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

struct Purchase { //struct of purchase
    uint32 id;
    string purchase_name;
    uint32 purchase_amount;
    uint64 createdAt;
    bool is_buy;
    uint32 price;
}

struct summary_purchases { //statistics of shopping list
    uint32 complete_count;
    uint32 incomplete_count;   
    uint32 total_price;
}

interface IMsig {
   function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload) external;
}

interface I_Purchase {
   function addPurchase(string text, uint32 value) external;
   function deletePurchase(uint32 id) external;
   function alreadyBuyed (uint32 id, uint32 price) external;
   function getPurchases() external returns (Purchase[] purchase);
   function getStat() external returns (summary_purchases summary);
}

abstract contract A_HasConstructorWithPubKey {
   constructor(uint256 pubkey_when_deploy) public {}
}


import 'DeBot_Init.sol' as init;

contract Debot_Shop is DeBot_init{   

    function _menu() external {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (need to buy/already payed/total) purchases",
                    m_stat.incompleteCount,
                    m_stat.completeCount,
                    m_stat.completeCount + m_stat.incompleteCount
            ),
            sep,
            [
                MenuItem("Add new purchase","",tvm.functionId(addPurchase)),
                MenuItem("Show purchase list","",tvm.functionId(getPurchases)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase))
            ]
        );
    }
}
