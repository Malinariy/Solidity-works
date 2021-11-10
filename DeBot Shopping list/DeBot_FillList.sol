pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'DeBot_Init.sol';

contract fill_list is DeBot_init{

    string PurchaseName;

    function _menu() virtual override internal {}

// First step. Set name of purchase
    function createPurchase() public{
        Terminal.input(tvm.functionId(setPurchaseName), "Enter purchase name:", false);
    }

    function setPurchaseName(string value) public {
        PurchaseName = value;
        Terminal.input(tvm.functionId(setPurchaseAmount), "Enter amount of purchases", false);
        //ConfirmInput.get(tvm.functionId(setPurchaseAmount), "How much is needed?");
    }
// Second step. Set amount of the purchase
    function setPurchaseAmount(string value) public {
        (uint check_value, bool flag) = stoi(value);
        if(flag){
            AddMyPurchase(uint32(check_value));
        } else {
            Terminal.print(0, "Value must be integer number\nPlease, try again");
            createPurchase();
        }
    }

    function AddMyPurchase(uint32 amount_of_purchase) public {
        optional(uint256) pubkey = 0;
        I_Purchase(m_address).addPurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(PurchaseName, amount_of_purchase);
    }

    function showMyShoppingList() public view {
        optional(uint256) none;
        I_Purchase(m_address).showPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showMyShoppingList_),
            onErrorId: 0
        }();
    }

    function showMyShoppingList_(Purchase[] purchase) public {
        uint32 i;
        if (purchase.length > 0 ) {
            Terminal.print(0, "Your shopping list:");
            for (i = 0; i < purchase.length; i++) {
                Purchase mypPurchase = purchase[i];
                string paid;
                if (mypPurchase.is_buy) {
                    paid = '✓';
                } else {
                    paid = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\" how many: {}", mypPurchase.id, paid, mypPurchase.purchase_name, mypPurchase.purchase_amount));
            }
        } else {
            Terminal.print(0, "Your shopping list list is empty");
        }
        _menu();
    }

    function deleteMyPurchase() public {
        if (m_stat.complete_count + m_stat.incomplete_count > 0) {
            Terminal.input(tvm.functionId(deleteMyPurchase_), "Enter purchase id with you want to delete: ", false);
        } else {
            Terminal.print(0, "Sorry, you deleted all the purchases");
            _menu();
        }
    }

    function deleteMyPurchase_(string value) public{
        (uint id, bool flag) = stoi(value);
        if(flag) {
            optional(uint256) pubkey = 0;
            I_Purchase(m_address).deletePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0, 
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(id));
        } else {
            Terminal.print(0, "Id must be integer!");
            deleteMyPurchase();
        }
    }
}
