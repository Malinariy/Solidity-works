pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'Debot_FullListPurchases.sol';
import 'Debot_AtMarket.sol';

contract ShopDebot is fill_list, AtMarket{
    function _menu() internal override(fill_list, AtMarket){
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (need to buy/already purchased/total) purchases",
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
