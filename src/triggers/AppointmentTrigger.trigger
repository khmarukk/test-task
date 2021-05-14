trigger AppointmentTrigger on Appointment__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        AppointmentTriggerHandler inst = new AppointmentTriggerHandler();
        inst.checkAppointment(Trigger.new);
    }
}