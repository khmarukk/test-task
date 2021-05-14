public with sharing class AppointmentsTableController {
    public Datetime appointmentDate { get; set; }
    public Integer durationInMinutes { get; set; }
    public Integer size { get {return 20;} set; }
    public Id selectedPatient { get; set; }
    public Id selectedDoctor { get; set; }
    public List<Doctor__c> doctors { get; set; }
    public List<Patient__c> patients { get; set; }

    public ApexPages.StandardSetController setCtrl {
        get {
            if (setCtrl == null) {
                setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(
                [
                        SELECT Name,Appointment_Date__c,Doctor__c,Doctor__r.Name,Patient__c,Patient__r.Name,Duration_in_minutes__c
                        FROM Appointment__c
                ]));
                setCtrl.setPageSize(size);
            }
            return setCtrl;
        }
        set;
    }

    public List<SelectOption> doctorOptions {
        get {
            List<SelectOption> options = new List<SelectOption>();
            doctors = [
                    SELECT Name, Id, Working_Hours_Start__c,Working_Hours_End__c
                    FROM Doctor__c
            ];
            for (Doctor__c doctor : doctors) {
                options.add(new SelectOption(doctor.Id, doctor.Name));
            }
            return options;
        }
        set;
    }

    public Doctor__c doctor {
        get {
            if (doctor == null) {
                doctor = new Doctor__c();
            }
            return doctor;
        }
        set;
    }

    public Boolean workingHours {
        get {
            if (workingHours == null) {
                workingHours = false;
            }
            return workingHours;
        }
        set;
    }

    public List<SelectOption> patientOptions {
        get {
            List<SelectOption> options = new List<SelectOption>();
            patients = [
                    SELECT Name, Id
                    FROM Patient__c
            ];
            for (Patient__c patient : patients) {
                options.add(new SelectOption(patient.Id, patient.Name));
            }
            return options;
        }
        set;
    }

    public Patient__c patient {
        get {
            if (patient == null) {
                patient = new Patient__c();
            }
            return patient;
        }
        set;
    }

    public void onDoctorChange() {
        workingHours = true;
        doctor = [
                SELECT Name,Working_Hours_Start__c,Working_Hours_End__c
                FROM Doctor__c
                WHERE Id = :selectedDoctor
                LIMIT 1
        ];
    }

    public void onPatientChange() {
        patient = [
                SELECT Name,Id
                FROM Patient__c
                WHERE Id = :selectedPatient
        ];
    }

    public PageReference createDoctor() {
        PageReference doctorPage = Page.DoctorCreation;
        doctorPage.setRedirect(false);
        return doctorPage;
    }

    public PageReference createPatient() {
        PageReference patientPage = Page.PatientCreation;
        patientPage.setRedirect(false);
        return patientPage;
    }

    public void addNewAppointment() {
        Appointment__c appointment = new Appointment__c();
        appointment.Appointment_Date__c = appointmentDate;
        appointment.Duration_in_minutes__c = durationInMinutes;
        appointment.Doctor__c = doctor.Id;
        appointment.Patient__c = patient.Id;
        insert appointment;
        getAppointments();
    }

    public List<Appointment__c> getAppointments() {
        return setCtrl.getRecords();
    }
}
