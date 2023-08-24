trigger ActivateAccountOnTaskCompletion on Task (after update) {
    List<Id> accountIdsToUpdate = new List<Id>();

    for (Task task : Trigger.new) {
        if (task.Status == 'Completed' && task.WhatId != null && task.WhatId.getSObjectType() == Account.SObjectType) {
            accountIdsToUpdate.add(task.WhatId);
        }
    }

    if (!accountIdsToUpdate.isEmpty()) {
        List<Account> accountsToUpdate = new List<Account>();

        for (Id accountId : accountIdsToUpdate) {
            // Check if the current user has the "CQ Account Admin" permission set
            if (PermissionSetUtils.checkPermissionSet('CQ Account Admin')) {
                accountsToUpdate.add(new Account(Id = accountId, Activee__c = true));
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}