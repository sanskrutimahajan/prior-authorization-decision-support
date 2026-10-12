// Administrative demo-data seed. Never attach to a published user action.
// Creates only missing DEMO-BI cases and missing named history events.
Clear(colPortfolioSeedErrors);
Set(varPortfolioSeedTime, DateAdd(Now(), -10, TimeUnit.Seconds));
ForAll(Sequence(40) As n,
 With({cn: "DEMO-BI-" & Text(n.Value, "000"),
       combo: Index(Table(
        {P:"Aetna",T:"Lumbar Epidural Steroid Injection",D:"Lumbar Radiculopathy"},
        {P:"Blue Cross",T:"Lumbar Radiculopathy",D:"Lumbar Radiculopathy"},
        {P:"United Health",T:"Total Knee Replacement",D:"Knee Osteoarthritis"},
        {P:"Blue Cross",T:"Xray",D:"Fracture"},
        {P:"Cigna",T:"Radiology",D:"Fracture"},
        {P:"Cigna",T:"Chemo Therapy",D:"Breast Cancer"}), Mod(n.Value-1,6)+1),
       st: Switch(Mod(n.Value,10),0,"Approved",1,"Approved",2,"Approved",3,"Approved",4,"Approved",5,"In Review",6,"In Review",7,"Pending",8,"Pending","Denied"),
       reviewer: "reviewer.ops" & Text(Mod(n.Value-1,3)+1) & "@example.com"},
 IfError(
  With({c: Coalesce(LookUp('Prior Authorization Cases', 'Case Number'=cn),
    Patch('Prior Authorization Cases', Defaults('Prior Authorization Cases'),
     {'Case Number':cn, 'Patient Name':"Demo Patient BI " & Text(n.Value,"000"),
      'Patient ID':"DEMO-ID-BI-" & Text(n.Value,"000"), Payer:combo.P, Treatment:combo.T, Diagnosis:combo.D,
      'Status (cr36f_status)':Switch(st,"Approved",'Status (Prior Authorization Cases)'.Approved,"In Review",'Status (Prior Authorization Cases)'.'In Review',"Denied",'Status (Prior Authorization Cases)'.Denied,'Status (Prior Authorization Cases)'.Pending),
      'Assigned Reviewer':reviewer, Urgent:Mod(n.Value,5)=0, 'Request Date':Today(),
      'Clinical Notes':"Invented portfolio demo case; no real patient data.",
      'Imaging Available':st="Approved" || st="In Review", 'Medication Trial':st="Approved",
      'Specialist Evaluation':st="Approved", 'Functional Limitation':st="Approved" || st="In Review",
      'Conservative Treatment Failed':st="Approved", 'Physical Therapy Weeks':If(st="Approved",6,If(st="In Review",2,0)),
      'Symptoms Duration Months':If(st="Approved",3,1)}))},
   ForAll(Filter(Table({Step:1,Prev:"",Next:"Pending"},{Step:2,Prev:"Pending",Next:"In Review"},{Step:3,Prev:"In Review",Next:st}),
     Step=1 || (Step=2 && st<>"Pending") || (Step=3 && st in ["Approved","Denied"])) As e,
    If(IsBlank(LookUp('Authorization Decisions','Decision Name'=cn & "-" & Text(e.Step))),
     Patch('Authorization Decisions',Defaults('Authorization Decisions'),
      {'Decision Name':cn & "-" & Text(e.Step), 'Authorization Case':c,
       'Decision Time':DateAdd(varPortfolioSeedTime,e.Step,TimeUnit.Seconds),
       'Previous Status':e.Prev,'New Status':e.Next,Reviewer:reviewer,
       Reason:If(e.Next="Denied","Demo scenario: required documentation incomplete.",e.Next="Approved","Demo scenario: all configured evidence criteria met.",e.Next="In Review","Demo scenario: assigned for evidence review.","Demo scenario: case intake recorded."),
       'Reviewer Notes':"Seeded demonstration history; not a real patient decision.",Outcome:"Applied"})))) ; true,
  Collect(colPortfolioSeedErrors,{CaseNumber:cn,Message:FirstError.Message}); false)));
Refresh('Prior Authorization Cases'); Refresh('Authorization Decisions');
If(CountRows(colPortfolioSeedErrors)=0,
 Notify("Portfolio demo data ready: 40 cases checked and linked history saved.",NotificationType.Success),
 Notify("Some demo records failed. Inspect colPortfolioSeedErrors before retrying.",NotificationType.Error))
