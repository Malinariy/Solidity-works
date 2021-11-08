pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'Debot_InitList.sol';

contract fill_list is debot_init{
    
    function _menu() virtual override internal {}

// First step. Set name of purchase
    function addPurchase(uint32 index) public {
        Terminal.input(tvm.functionId(setPurchaseName), "Enter purchase name:", false);
    }

    function setPurchaseName(string purchase_name) public {
        m_purchase_name = purchase_name;
        Terminal.input(tvm.functionId(setPurchaseAmount), "Enter amount of purchases", false);
    }
// Second step. Set amount of the purchase
    function setPurchaseAmount(uint32 amount_of_purchase) public {
        require(amount_of_purchase > 0, "Amount of purchases must be integer and greater than zero");
        AddPurchase(uint32(amount_of_purchase));
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
            }(m_purchase_name, amount_of_purchase);
    }

    //Вывод списка покупок

    function showShoppingList(uint32 index) public view {
        index = index;
        optional(uint256) none;
        ITodo(m_address).getPurchases{
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

    function showShoppingList_( Purchase[] purchase) public {
        uint32 i;
        if (purchase.length > 0 ) {
            Terminal.print(0, "Your shopping list:");
            for (i = 0; i < tasks.length; i++) {
                Purchase purchasse = purchase[i];
                string paid;
                if (purchases.is_buy) {
                    paid = '✓';
                } else {
                    paid = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\" how many: {}", purchases.id, paid, purchases.purchase_name, purchases.purchase_amount));
            }
        } else {
            Terminal.print(0, "Your shopping list list is empty");
        }
        _menu();
    }

    //Удаление покупки
    function deleteSomePurchase() public {
        if (m_stat.complete_count + m_stat.incomplete_count > 0) {
            Terminal.input(tvm.functionId(deleteSomePurchase_), "Enter purchase id with you want to delete: ", false);
        } else {
            Terminal.print(0, "Sorry, you deleted all the purchases");
            _menu();
        }
    }

    function deleteSomePurchase_(string value) public{
        (uint id, bool status) = stoi(value);

        if(status) {
            optional(uint256) pubkey = 0;
            IShoppingList(m_address).deletePurchase{
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