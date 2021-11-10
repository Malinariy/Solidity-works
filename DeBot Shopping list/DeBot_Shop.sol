pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'DeBot_FillList.sol';
import 'DeBot_AtMarket.sol';
import 'DeBot_Init.sol';
    
contract DeBot_Shop is fill_list, AtMarket {

    function _menu() override(fill_list, AtMarket) internal{
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{} (need to buy/already payed/total) purchases and you have total spend {}",
                    m_stat.incomplete_count,
                    m_stat.complete_count,
                    m_stat.complete_count + m_stat.incomplete_count,
                    m_stat.total_price
            ),
            sep,
            [
                MenuItem("Add new purchase","",tvm.functionId(createPurchase)),
                MenuItem("Show purchase list","",tvm.functionId(showMyShoppingList)),
                MenuItem("Delete purchase","",tvm.functionId(deleteMyPurchase)),
                MenuItem("Pay purchase","",tvm.functionId(payMyPurchase))
            ]
        );
    }
}