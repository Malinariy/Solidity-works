pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'Debot_InitList.sol';

contract AtMarket is debot_init {

    uint32 m_purchaseId; // Money for making of purchase

    function _menu() virtual override internal {}

    function payPurchase() public {
        if(m_stat.incomplete_count > 0) {
            Terminal.input(tvm.functionId(setPurchaseId), "Enter purchase id you want to pay", false);
        } else {
            Terminal.print(0, "You paid all the purchases");
            _menu();
        }
    }

    function getPurchaseId(string value) public {
        (uint purchaseId, bool status) = stoi(value);

        if(status) {
            m_purchaseId = uint32(purchaseId);
            Terminal.input(tvm.functionId(BuyPurchase), "Enter how mach money you spent", false);

        } else {
            Terminal.print(0, "Id must be integer number");
            makePurchase();
        }
    }

    function BuyPurchase(string value) public {
        (uint money, bool status) = stoi(value);

        if(status) {
            optional(uint) pubkey = 0;
            IShoppingList(m_address).alreadyBuyed{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(m_purchaseId, uint64(money));
        } else {
            Terminal.print(0, "Money must be integer number");
            payPurchase();
        }
    }
}