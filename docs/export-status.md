# Export and release notes

Prepared 12 October 2026.

The canvas app was published on 12 October 2026. A fresh native app download was obtained afterward; its four screen YAML files and App YAML are included in `src/canvas`. These are Power Apps-generated source for review and reconstruction in Studio, not a standalone executable or a full Dataverse solution.

The original native `.msapp` is preserved locally outside this repository. Native app bindings include the originating Dataverse instance and AI model identifiers. The public version supplies source without those environment bindings; configure the destination connections and AI Builder prompt in Studio. No native package has been import-tested in a clean environment.

Power BI query and DAX source are included. A fresh 12 October native report download supplied the refined report/page/visual JSON in `power-bi/report-definition`. It is layout source, not a complete PBIP project. The native PBIX is retained locally outside this repository because its binary model carries deployment metadata that has not been made portable. Clean screenshots show the cloud report without account headers. The report snapshot contains 48 cases and 102 decisions; the later app test brought Dataverse to 49 cases and 104 decisions.

The Power Automate source contains the configured reviewer-notification trigger and actions. It is a Code view reference, not an importable solution package. Connections must be created in the destination environment. Deployment and a controlled mailbox test are setup steps.

Unmodified native exports and release screenshots remain in local project working files, outside this public folder. No GitHub upload was performed during preparation.
