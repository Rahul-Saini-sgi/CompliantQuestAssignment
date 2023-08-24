public class PermissionSetUtils {
    public static Boolean checkPermissionSet(String permissionSetName) {
        Boolean hasPermission = false;
        for (PermissionSetAssignment psa : [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()]) {
            if (psa.PermissionSet.Name == permissionSetName) {
                hasPermission = true;
                break;
            }
        }
        return hasPermission;
    }
}