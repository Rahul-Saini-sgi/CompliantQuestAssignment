@isTest
private class Test_CreateTaskOnInactiveAccount {
    @isTest static void testTrigger() {
        // Create a test Account
        Account testAccount = new Account(
            Name = 'Test Account',
            Activee__c = false
        );
        
        insert testAccount;
        
        // Create a test Task related to the Account
        Task testTask = new Task(
            WhatId = testAccount.Id,
            Subject = 'Test Task',
            Status = 'Not Started'
        );
        
        insert testTask;
        
        // Update the Account to activate it and complete the Task
        testAccount.Activee__c = true;
        update testAccount;
        
        // Retrieve the updated Account and Task
        testAccount = [SELECT Id, Description FROM Account WHERE Id = :testAccount.Id];
        testTask = [SELECT Id, Status FROM Task WHERE Id = :testTask.Id];
        
        // Assertions
        System.assertEquals(true, testAccount.Activee__c, 'Account should be activated');
        System.assertEquals('Completed', testTask.Status, 'Task should be completed');
        System.assertEquals(testTask.Subject, testAccount.Description, 'Task Comments should be transferred to Account Description');
    }
}