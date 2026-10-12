let
 Source = CommonDataService.Database(DataverseHost),
 Raw = Source{[Schema="dbo",Item="cr36f_priorauthorizationcase"]}[Data],
 Selected = Table.SelectColumns(Raw,{"cr36f_priorauthorizationcaseid","cr36f_casenumber","cr36f_payer","cr36f_treatment","cr36f_diagnosis","cr36f_statusname","cr36f_assignedreviewer","cr36f_urgent","createdon"}),
 Renamed = Table.RenameColumns(Selected,{{"cr36f_priorauthorizationcaseid","Case ID"},{"cr36f_casenumber","Case Number"},{"cr36f_payer","Payer"},{"cr36f_treatment","Treatment"},{"cr36f_diagnosis","Diagnosis"},{"cr36f_statusname","Status"},{"cr36f_assignedreviewer","Assigned Reviewer"},{"createdon","Created Time"}}),
 WithUrgency = Table.AddColumn(Renamed,"Urgency",each if [cr36f_urgent] = true then "Urgent" else "Routine",type text),
 Removed = Table.RemoveColumns(WithUrgency,{"cr36f_urgent"}),
 WithDate = Table.AddColumn(Removed,"Created Date",each Date.From([Created Time]),type date)
in WithDate