pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'structs_storage.sol';
import 'base/Terminal.sol';
import 'base/Sdk.sol';
import 'base/AddressInput.sol';
import 'base/ConfirmInput.sol';
import 'base/Debot.sol';
import 'base/Menu.sol';
import 'base/Upgradable.sol';


abstract contract DeBot_init is Debot{

    bytes m_icon;
    TvmCell m_shopListCode; // ShopList.sol contract code
    address m_address;  // ShopList.sol contract addr
    summary_purchases m_stat;   // Statistics of incompleted and completed tasks
    uint32 m_purchaseId;    
    uint256 m_masterPubKey; // User pubkey
    address m_msigAddress;  // User wallet address

    uint32 INITIAL_BALANCE =  200000000;  // Initial ShopList.sol contract balance

    function start() public override{
        Terminal.input(tvm.functionId(savePublicKey), "Please enter your public key", false);
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon){
        name = "Shopping List DeBot";
        version = "0.2.0";
        publisher = "Chuk";
        key = "ShopList list manager";
        author = "Chuk";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a Shopping List DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }

    function setShopList(TvmCell code) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        m_shopListCode = code;
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
    }

    function onSuccess() public view {
        _getSummary(tvm.functionId(SetSummary));
    }

    function savePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status){
            m_masterPubKey = res; 

            Terminal.print(0, "Cheking if you already have a shopping list...");
            TvmCell deployState = tvm.insertPubkey(m_shopListCode, m_masterPubKey);
            m_address = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format("Info: your shopping list contract address is {}", m_address));
            Sdk.getAccountType(tvm.functionId(checkStatus), m_address);
        }else{
            Terminal.input(tvm.functionId(savePublicKey), "Wrong public key, Please try again.\nEnter your public key.", false);
        }
    }

    // Block of check account status type
    function checkStatus(int8 acc_type) public {
        if (acc_type == 1){
            _getSummary(tvm.functionId(SetSummary)); // acc is active and deployed, we can see statistics
        }else if (acc_type == -1){ // acc is inactive
            Terminal.print(0, "You don't have a shopping list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount), "Select a wallet for payment. We will ask you to sign two transactions");
        }else if (acc_type == 0){ //acc is uninitialized
            Terminal.print(0, "Deploying your new contract, check if your shopping list contract has enough tokens on its balance");
            deploy();
        }else if (acc_type == 2){
            Terminal.print(0, format("Can not continue: account {} is frozen", m_address));
            }
        }

    function creditAccount(address value) public {
        m_msigAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        IMsig(m_msigAddress).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit)  // Just repeat if something went wrong
        }(m_address, INITIAL_BALANCE, false, 3, empty);
    }

    function onErrorRepeatCredit() public {
        Terminal.print(0, "Something gone wrong, sending transaction again");
        creditAccount(m_msigAddress);
    }

    function _getSummary(uint32 answer_id) private view {
        optional(uint256) none;
        I_Purchase(m_address).getStat{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answer_id,
            onErrorId: 0
        }();
    }

    function SetSummary(summary_purchases summary) public {
        m_stat = summary;
        Debot_Shop._menu();
    }

    function deploy() private view {
        TvmCell image = tvm.insertPubkey(m_shopListCode, m_masterPubKey);
        optional(uint256) none;
        TvmCell deployMsg = tvm.buildExtMsg({
            abiVer: 2,
            dest: m_address,
            callbackId: tvm.functionId(onSuccess),
            onErrorId:  tvm.functionId(onErrorRepeatDeploy), // Just repeat if something went wrong
            time: 0,
            expire: 0,
            sign: true,
            pubkey: none,
            stateInit: image,
            call: {A_HasConstructorWithPubKey, m_masterPubKey}
        });
        tvm.sendrawmsg(deployMsg, 1);
    }

    function onErrorRepeatDeploy() public {
        Terminal.print(0, "Something gone wrong, contract deploying again");
        deploy();
    }

    // Deploy loop
    function waitBeforeDeploy() public  {
        Sdk.getAccountType(tvm.functionId(checkIfStatusIs0), m_address);
    }

    function checkIfStatusIs0(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitBeforeDeploy();
        }
    }
}
