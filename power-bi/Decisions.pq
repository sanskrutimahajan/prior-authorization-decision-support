let
 Source = CommonDataService.Database(DataverseHost),
 Raw = Source{[Schema="dbo",Item="cr36f_authorizationdecision"]}[Data],
 Selected = Table.SelectColumns(Raw,{"cr36f_authorizationdecisionid","cr36f_authorizationcase","cr36f_decisiontime","cr36f_previousstatus","cr36f_newstatus","cr36f_reviewer","cr36f_outcome"}),
 Renamed = Table.RenameColumns(Selected,{{"cr36f_authorizationdecisionid","Decision ID"},{"cr36f_authorizationcase","Case ID"},{"cr36f_decisiontime","Decision Time"},{"cr36f_previousstatus","Previous Status"},{"cr36f_newstatus","New Status"},{"cr36f_reviewer","Reviewer"},{"cr36f_outcome","Outcome"}}),
 WithDate = Table.AddColumn(Renamed,"Decision Date",each Date.From([Decision Time]),type date)
in WithDate