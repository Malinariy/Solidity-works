pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract tasks {

    int8 public task_count = 0;
    string[] public str_names; 


    struct Task {
        string task_name;
        uint32 timestamp;
        bool flag;    
    }

    mapping (int8=>Task) public mapp_task;

    function add_task(string value) public checkOwnerAndAccept{
        task_count ++;
        mapp_task[task_count] = Task(value, now, false);
        str_names.push(value);
    }

    function count_open_tasks() public checkOwnerAndAccept returns (int8) {
        int8 num_of_tasks = 0;

        for(int8 i = 0; i < task_count; i++) {
            if (!mapp_task[i].flag) {
                num_of_tasks ++;
            }
        }
        return num_of_tasks;
    }

    function get_tasks() public checkOwnerAndAccept returns (string[]) {
        return str_names;
    }

    function name_task(int8 key) public checkOwnerAndAccept returns (string) {
         return mapp_task[key].task_name;
    }

    function delete_task(int8 key) public checkOwnerAndAccept {
        delete mapp_task[key - 1];
        delete str_names[uint256(key) - 1];
        task_count --;
    }

    function completed_task(int8 key) public checkOwnerAndAccept{
        mapp_task[key].flag = true;
        task_count --;
    }

    modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102); 
		tvm.accept();
		_;
    }
}  
