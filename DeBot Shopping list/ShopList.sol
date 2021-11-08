pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'structs_storage.sol';

contract ShopList {
    /*
     * ERROR CODES
     * 100 - Unauthorized
     * 102 - task not found
     */

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        _;
    }

    uint256 m_ownerPubkey;
    uint32 private index;
    mapping(uint32 => Purchase) mapp_purchase; //id to purchase

    constructor(uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }

    function addPurchase(string purchase_name, uint32 purchase_amount) public onlyOwner { 
        tvm.accept();
        index++;
        mapp_purchase[index] = Purchase(index, purchase_name, purchase_amount, now, false, 0);
    }

    function deletePurchase(uint32 id) public onlyOwner {
        require(mapp_purchase.exists(id), 102);
        tvm.accept();
        delete mapp_purchase[id];
    }

    function alreadyBuyed(uint32 id, uint32 price) public onlyOwner{
        require(mapp_purchase.exists(id), 102);
        tvm.accept();
        mapp_purchase[id].is_buy = true;
        mapp_purchase[id].price = price;
    }

    function getPurchases() public view returns (Purchase[] purchases) {
        string purchase_name;
        uint32 purchase_amount;
        uint64 createdAt;
        bool is_buy;
        uint32 price;

        for((uint32 id, Purchase purchase) : mapp_purchase) {

            purchase_name = purchase.purchase_name;
            purchase_amount = purchase.purchase_amount;
            createdAt = purchase.createdAt;
            is_buy = purchase.is_buy;
            price = purchase.price;

            purchases.push(Purchase(id, purchase_name, purchase_amount, createdAt, is_buy, price));
       }
    }

    function getStat() public view returns (summary_purchases stat) { //statistics of purchases
        uint32 completeCount;
        uint32 incompleteCount;
        uint32 total_price;

        for((,Purchase purchase) : mapp_purchase) {
            if  (purchase.is_buy) {
                completeCount ++;
            } else {
                incompleteCount ++;
            }
        }

        for (uint32 id = 0; id <= index; id++){
            total_price += mapp_purchase[id].price;
        }
        stat = summary_purchases(completeCount, incompleteCount, total_price);
    }
}
