public with sharing class AppointmentTriggerHandler {
    public void checkAppointment(List<Appointment__c> appointments) {
        Set<Id> doctorsIds = new Set<Id>();
        for (Appointment__c appointment : appointments) {
            doctorsIds.add(appointment.Doctor__c);
        }
        List<Doctor__c> doctors = [
                SELECT Name, Working_Hours_Start__c,Working_Hours_End__c, (SELECT Appointment_Date__c FROM Appointments__r)
                FROM Doctor__c
                WHERE Id IN :doctorsIds
        ];
        for (Appointment__c appointment : appointments) {
            for (Doctor__c doctor : doctors) {
                if (appointment.Doctor__c == doctor.Id) {
                    for (Appointment__c docsAppointment : doctor.Appointments__r) {
                        if (docsAppointment.Appointment_Date__c == appointment.Appointment_Date__c) {
                            appointment.addError(System.Label.The_doctor_already_has_an_appointment);
                        }
                    }
                }
            }
        }
    }
}
