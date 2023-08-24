trigger CreateTaskOnInactiveAccount on Account (before insert, after insert, after update) {
    List<Task> tasksToInsert = new List<Task>();
    List<Task> tasksToUpdate = new List<Task>();

    if (Trigger.isBefore) {
        // Logic for before insert event
        for (Account acc : Trigger.new) {
            acc.Activee__c = false;
        }
    } else if (Trigger.isAfter && Trigger.isInsert) {
        for (Account acc : Trigger.new) {
            Task newTask = new Task(
                WhatId = acc.Id,
                Subject = 'Review Account - ' + acc.AccountNumber,
                ActivityDate = System.today().addDays(7),
                Assignetoo__c = acc.OwnerId,
                Status = 'Not Started'
            );
            tasksToInsert.add(newTask);
        }

        insert tasksToInsert;
    } else if (Trigger.isAfter && Trigger.isUpdate) {
        for (Account acc : Trigger.new) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);

            // Check if the Active__c field has changed from false to true
            if (oldAcc.Activee__c == false && acc.Activee__c == true) {
                // Query for related Tasks and mark them as completed
                List<Task> relatedTasks = [SELECT Id, Status FROM Task WHERE WhatId = :acc.Id];
                for (Task task : relatedTasks) {
                    task.Status = 'Completed';
                    tasksToUpdate.add(task);
                }
            }
        }

        if (!tasksToUpdate.isEmpty()) {
            update tasksToUpdate;
        }
    }
}