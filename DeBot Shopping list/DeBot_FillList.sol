pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'DeBot_Init.sol';

contract fill_list is DeBot_init{

    string PurchaseName;

// First step. Set name of purchase
    function addPurchase(uint32 index) public {
        Terminal.input(tvm.functionId(setPurchaseName), "Enter purchase name:", false);
    }

    function setPurchaseName(string _purchase_name) public {
        PurchaseName = _purchase_name;
        Terminal.input(tvm.functionId(setPurchaseAmount), "Enter amount of purchases", false);
    }
// Second step. Set amount of the purchase
    function setPurchaseAmount(string amount_of_purchase) public {
        (uint value, bool flag) =stoi(amount_of_purchase);
        AddPurchase(uint32(value));
    }

    function AddPurchase(uint32 amount_of_purchase) public view {
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

    function showShoppingList() public view {
        optional(uint256) none;
        I_Purchase(m_address).getPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showShoppingList_),
            onErrorId: 0
        }();
    }

    function showShoppingList_(Purchase[] purchase) public {
        uint32 i;
        if (purchase.length > 0 ) {
            Terminal.print(0, "Your shopping list:");
            for (i = 0; i < purchase.length; i++) {
                Purchase purchases = purchase[i];
                string paid;
                if (purchase.is_buy) {
                    paid = '✓';
                } else {
                    paid = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\" how many: {}", purchase.id, paid, purchase.purchase_name, purchase.purchase_amount));
            }
        } else {
            Terminal.print(0, "Your shopping list list is empty");
        }
        Debot_Shop._menu();
    }

    function deleteSomePurchase() public {
        if (m_stat.complete_count + m_stat.incomplete_count > 0) {
            Terminal.input(tvm.functionId(deleteSomePurchase_), "Enter purchase id with you want to delete: ", false);
        } else {
            Terminal.print(0, "Sorry, you deleted all the purchases");
            Debot_Shop._menu();
        }
    }

    function deleteSomePurchase_(string value) public{
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
            deleteSomePurchase();
        }
    }
}
