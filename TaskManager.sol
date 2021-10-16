
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskManager {

    int8 public undoneTasksAmount;         // переменная для хранения количества открытых задач
    int8 private lastTaskNumber;           // переменная для хранения номера последней задачи
    int8 private constant INT8_MAX = 127;

    struct Task {
        string title;         // название задачи
        uint32 creationTime;  // время добавления задачи
        bool isDone;          // статус задачи: выполнена или нет
    }

    mapping(int8 => Task) public tasks;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    // с помощью этого модификатора проверяем наличие в сопоставлении задачи с заданным номером
    modifier checkTaskExistence(int8 taskNumber) {
        require(tasks.exists(taskNumber), 201, "task with this number dosn't exist");
        _;
    }

    // функция для добавление новой задачи в сопоставление
    function addTask(string title) public checkOwnerAndAccept {
        require(lastTaskNumber < INT8_MAX, 202, "maximum number of tasks has been reached"); // проверяем, допустимо ли добавление новой задачи

        lastTaskNumber++;
        tasks[lastTaskNumber] = Task(title, now, false);
        undoneTasksAmount++; // т.к. новая задача является открытой по умолчанию
    }

    // функция для удаления задачи из сопоставления
    function removeTask(int8 taskNumber)
        public
        checkOwnerAndAccept
        checkTaskExistence(taskNumber)
    {
        if (!tasks[taskNumber].isDone) {
            undoneTasksAmount--;  // если удалённая задача была открытой, то их общее число уменьшается
        }
        delete tasks[taskNumber];
    }
    
    // функция, которая помечает задачу как выполненную
    function setTaskAsDone(int8 taskNumber)
        public
        checkOwnerAndAccept
        checkTaskExistence(taskNumber)
    {
        require(!tasks[taskNumber].isDone, 203, "this task has already been done"); // проверяем, является ли задача открытой
        
        undoneTasksAmount--;
        tasks[taskNumber].isDone = true;
    }

    // функция для получения описания задачи по ключу
    function getTaskByNum(int8 taskNumber)
        public view
        checkTaskExistence(taskNumber)
        returns (Task)
    {   
        return tasks[taskNumber];
    }
}
