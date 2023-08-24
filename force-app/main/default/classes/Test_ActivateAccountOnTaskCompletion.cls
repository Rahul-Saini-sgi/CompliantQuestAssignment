@isTest
private class Test_ActivateAccountOnTaskCompletion {
    @isTest static void testTrigger() {
        // Create a test User with the "CQ Account Admin" permission set
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        PermissionSet cqAccountAdmin = [SELECT Id FROM PermissionSet WHERE Name = 'CQ Account Admin'];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'test@example.com',
            Alias = 'testu',
            Username = 'test@example.com',
            ProfileId = adminProfile.Id
        );
        insert testUser;
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = testUser.Id,
            PermissionSetId = cqAccountAdmin.Id
        );
        insert psa;
        
        // Create a test Account and Task
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        Task testTask = new Task(
            WhatId = testAccount.Id,
            Subject = 'Test Task',
            Status = 'Completed'
        );
        insert testTask;

        // Update the Task status to trigger the trigger
        testTask.Status = 'Not Started';
        update testTask;
        
        // Retrieve the updated Account
        testAccount = [SELECT Id, Activee__c FROM Account WHERE Id = :testAccount.Id];
        
        // Assertions
        System.assertEquals(true, testAccount.Activee__c, 'Account should be activated');
    }
}