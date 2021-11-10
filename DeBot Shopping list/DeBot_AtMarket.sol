pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'DeBot_Init.sol';

contract AtMarket is DeBot_init{

    uint32 PurchaseId; 

    function _menu() virtual override internal {}

    function payMyPurchase() public {
        if(m_stat.incomplete_count > 0) {
            Terminal.input(tvm.functionId(getPurchaseId), "Enter purchase id you want to pay", false);
        } else {
            Terminal.print(0, "You paid all the purchases");
            _menu();
        }
    }

    function getPurchaseId(string value) public {
        (uint purchaseId, bool status) = stoi(value);

        if(status) {
            PurchaseId = uint32(purchaseId);
            Terminal.input(tvm.functionId(BuyPurchase), "Enter how mach money you spent", false);

        } else {
            Terminal.print(0, "Id must be integer number");
            payMyPurchase();
        }
    }

    function BuyPurchase(string value) public {
        (uint payed_value, bool flag) = stoi(value);
        if(flag) {
            optional(uint) pubkey = 0;
            I_Purchase(m_address).alreadyBuyed{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(PurchaseId, uint32(payed_value));
        } else {
            Terminal.print(0, "Input must be integer number");
            payMyPurchase();
        }
    }
}
